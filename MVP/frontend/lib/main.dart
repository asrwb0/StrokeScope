import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const StrokeScopeApp());
}

// ── Change 1: update the base URL to point at the FastAPI backend ──────────────
const String _apiBase = 'http://localhost:8000';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/analyze', builder: (context, state) => const AnalyzePage()),
    GoRoute(
      path: '/feedback',
      builder: (context, state) => const FeedbackPage(),
    ),
  ],
);

class StrokeScopeApp extends StatelessWidget {
  const StrokeScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'StrokeScope',
      routerConfig: _router,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
    );
  }
}

class NavBar extends StatelessWidget {
  final String currentPath;
  const NavBar({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      color: const Color(0xFF0A1F44),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Text(
            'Stroke Scope',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          _NavLink(label: 'Home', path: '/', currentPath: currentPath),
          _NavLink(label: 'Analyze', path: '/analyze', currentPath: currentPath),
          _NavLink(label: 'Feedback', path: '/feedback', currentPath: currentPath),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final String path;
  final String currentPath;
  const _NavLink({
    required this.label,
    required this.path,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(path),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Change 2: replace the old 6-class result model with the new binary one
// ─────────────────────────────────────────────────────────────────────────────
class AnalyzeResult {
  final String predictedClass;       // "Normal" or "Stroke"
  final double confidence;           // probability of the predicted class
  final String confidenceTier;       // "Low", "Moderate", or "High"
  final double strokeProbability;    // raw sigmoid score for Stroke
  final bool lowConfidence;
  final Map<String, double> allClassScores; // {"Normal": x, "Stroke": y}
  final String? llmExplanation;
  final String disclaimer;

  const AnalyzeResult({
    required this.predictedClass,
    required this.confidence,
    required this.confidenceTier,
    required this.strokeProbability,
    required this.lowConfidence,
    required this.allClassScores,
    this.llmExplanation,
    required this.disclaimer,
  });

  factory AnalyzeResult.fromJson(Map<String, dynamic> json) {
    return AnalyzeResult(
      predictedClass:    json['predicted_class'] as String,
      confidence:        (json['confidence'] as num).toDouble(),
      confidenceTier:    json['confidence_tier'] as String,
      strokeProbability: (json['stroke_probability'] as num).toDouble(),
      lowConfidence:     json['low_confidence'] as bool,
      allClassScores:    Map<String, double>.from(
        (json['all_class_scores'] as Map).map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ),
      ),
      llmExplanation: json['llm_explanation'] as String?,
      disclaimer:     json['disclaimer'] as String,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(
          color: const Color(0xFF0A1F44),
          child: SafeArea(child: NavBar(currentPath: '/')),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: const Color.fromARGB(255, 230, 235, 255),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 275),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(color: const Color(0xFF0A1F44), width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Stroke Detection Platform',
                  style: GoogleFonts.bebasNeue(fontSize: 40),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => context.go('/analyze'),
                    child: Text('Analyze a Scan', style: GoogleFonts.bebasNeue(fontSize: 28)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _scrollController.animateTo(
                      600,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    ),
                    child: Text('Learn More', style: GoogleFonts.bebasNeue(fontSize: 28)),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Container(height: 2, color: Colors.black),
              const SizedBox(height: 24),
              Text('HOW DOES OUR APP WORK?',
                  style: GoogleFonts.bebasNeue(fontSize: 60, decoration: TextDecoration.underline)),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  _infoBox('learn'),
                  Text('➡', style: GoogleFonts.bebasNeue(fontSize: 60)),
                  _infoBox('Upload'),
                  Text('➡', style: GoogleFonts.bebasNeue(fontSize: 60)),
                  _infoBox('Detect'),
                  Text('➡', style: GoogleFonts.bebasNeue(fontSize: 60)),
                  _infoBox('Results'),
                ],
              ),
              const SizedBox(height: 24),
              Container(height: 2, color: Colors.black),
              const SizedBox(height: 14),
              Text('DID YOU KNOW?',
                  style: GoogleFonts.bebasNeue(fontSize: 60, decoration: TextDecoration.underline)),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  _wideInfoBox('A "hemorrhage" is the medical term for bleeding inside your body.'),
                  _wideInfoBox('A stroke adds extra pressure inside your brain, which can damage or kill brain cells.'),
                  _wideInfoBox('Every 40 seconds, an individual suffers from a stroke in the U.S., with a death occurring every three minutes (CDC, 2025)'),
                ],
              ),
              const SizedBox(height: 24),
              Container(height: 2, color: Colors.black),
              const SizedBox(height: 14),
              Text('WHAT IS A HEMORRHAGIC STROKE?',
                  style: GoogleFonts.bebasNeue(fontSize: 60, decoration: TextDecoration.underline)),
              const SizedBox(height: 16),
              Container(
                width: 10000,
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(color: const Color(0xFF0A1F44), width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Hemorrhagic strokes are the result of a ruptured blood vessel in the brain, either intracerebral (inside the brain) or subarachnoid (between the brain and the skull). In these cases, medical professionals prescribe medication intended to lower brain pressure and swelling, sometimes with the use of blood thinners ("A Neurosurgeon\'s Guide to Stroke," n.d.). Hemorrhagic strokes make up twenty percent of all strokes (NINDS Recognizes Stroke Awareness Month | National Institute of Neurological Disorders and Stroke, 2024). ',
                    style: GoogleFonts.bebasNeue(fontSize: 28),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/analyze'),
                child: Text('Click here to learn more!', style: GoogleFonts.bebasNeue(fontSize: 28)),
              ),
              const SizedBox(height: 24),
              Container(height: 2, color: Colors.black),
              const SizedBox(height: 14),
              Text('WHAT IS OUR GOAL?',
                  style: GoogleFonts.bebasNeue(fontSize: 60, decoration: TextDecoration.underline)),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  _infoBox('Education'),
                  _infoBox('Accessibility'),
                  _infoBox('Speed'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox(String label) {
    return Container(
      width: 200,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF0A1F44), width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(child: Text(label, style: GoogleFonts.bebasNeue(fontSize: 28), textAlign: TextAlign.center)),
    );
  }

  Widget _wideInfoBox(String label) {
    return Container(
      width: 400,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF0A1F44), width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(child: Text(label, style: GoogleFonts.bebasNeue(fontSize: 28), textAlign: TextAlign.center, softWrap: true)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AnalyzePage — all 4 changes live here
// ─────────────────────────────────────────────────────────────────────────────

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  PlatformFile? _selectedFile;
  bool _isLoading = false;
  // Change 2 (cont): _result is now typed as AnalyzeResult? instead of Map<String, dynamic>?
  AnalyzeResult? _result;
  String? _error;

  Future<void> _pickFile() async {
    // Change 3: remove 'dcm' and 'dicom' — the new model only accepts JPEG/PNG
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'bmp'],
    );
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _analyzeFile() async {
    if (_selectedFile == null) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          _selectedFile!.bytes!,
          filename: _selectedFile!.name,
        ),
      });
      // Change 4: fix endpoint — was '/api/predict', now '/api/analyze'
      final response = await dio.post('$_apiBase/api/analyze', data: formData);
      setState(() {
        _result = AnalyzeResult.fromJson(response.data as Map<String, dynamic>);
      });
    } on DioException catch (e) {
      setState(() {
        _error = e.response?.data?['detail'] ??
            e.response?.data?['message'] ??
            'Request failed. Is the backend running?';
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildUploadBox() {
    return DottedBorder(
      color: Colors.white,
      strokeWidth: 2,
      dashPattern: const [6, 6],
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      child: GestureDetector(
        onTap: _pickFile,
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 21, 34, 51),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _selectedFile == null ? _emptyState() : _fileSelected(),
        ),
      ),
    );
  }

  // Change 5: completely rewritten _buildResultsBox() for binary output
  Widget _buildResultsBox() {
    Widget body;

    if (_error != null) {
      body = Center(
        child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
      );
    } else if (_result == null) {
      body = const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.document_scanner_outlined, color: Colors.white38, size: 48),
            SizedBox(height: 12),
            Text(
              'Detection results will appear here after analysis',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Text('Await results...', style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      );
    } else {
      // Results: single scroll view, no nesting
      body = SingleChildScrollView(
        child: _buildBinaryResult(_result!),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B3C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    );
  }

  Widget _buildBinaryResult(AnalyzeResult result) {
    final isStroke = result.predictedClass == 'Stroke';
    final accentColor = isStroke ? Colors.redAccent : Colors.greenAccent;
    final verdictIcon = isStroke ? '⚠' : '✓';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Verdict header ──────────────────────────────────────────
        Text(
          '$verdictIcon ${isStroke ? "Stroke Detected" : "No Stroke Detected"}',
          style: TextStyle(color: accentColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '${result.confidenceTier} confidence  •  ${(result.confidence * 100).toStringAsFixed(1)}%',
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
        const SizedBox(height: 16),

        // ── Score bars ──────────────────────────────────────────────
        const Text('Class Probabilities', style: TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 8),
        _buildScoreBar('Normal', result.allClassScores['Normal'] ?? 0.0, Colors.greenAccent),
        const SizedBox(height: 8),
        _buildScoreBar('Stroke', result.allClassScores['Stroke'] ?? 0.0, Colors.redAccent),

        // ── Low-confidence warning ──────────────────────────────────
        if (result.lowConfidence) ...[
          const SizedBox(height: 12),
          const Text(
            '⚠ Low confidence result — interpret with caution.',
            style: TextStyle(color: Colors.amber, fontSize: 12),
          ),
        ],

        // ── AI Explanation ──────────────────────────────────────────
        if (result.llmExplanation != null) ...[
          const SizedBox(height: 20),
          const Text(
            'EXPLANATION OF RESULTS',
            style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          _buildExplanationCard(result.llmExplanation!),
        ],

        // ── Disclaimer ──────────────────────────────────────────────
        const SizedBox(height: 16),
        Text(
          result.disclaimer,
          style: const TextStyle(color: Colors.white38, fontSize: 11, height: 1.4),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildScoreBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.white12,
          color: color,
          minHeight: 8,
        ),
        Text(
          '${(value * 100).toStringAsFixed(1)}%',
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }

  /// Parse the GPT output into labelled sections and render each as a row.
  /// GPT always returns lines like "Finding:\n...", "Confidence:\n...", etc.
  Widget _buildExplanationCard(String raw) {
    // Split on the four known section labels; keep the label with its content.
    final sectionLabels = ['Finding', 'Confidence', 'Details', 'Safety Note'];
    final Map<String, String> sections = {};

    // Walk through the raw text and extract each section's content.
    for (int i = 0; i < sectionLabels.length; i++) {
      final label = sectionLabels[i];
      final start = raw.indexOf('$label:');
      if (start == -1) continue;
      final contentStart = start + label.length + 1; // skip "Label:"
      // Next section starts at the next label, or end of string
      int end = raw.length;
      for (int j = i + 1; j < sectionLabels.length; j++) {
        final nextIdx = raw.indexOf('${sectionLabels[j]}:');
        if (nextIdx != -1 && nextIdx < end) end = nextIdx;
      }
      sections[label] = raw.substring(contentStart, end).trim();
    }

    // If parsing found nothing (unexpected format), fall back to plain text.
    if (sections.isEmpty) {
      return Text(raw, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5));
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sections.containsKey('Finding'))
            _buildExplanationRow('Finding', sections['Finding']!, Colors.white),
          if (sections.containsKey('Confidence'))
            _buildExplanationRow('Confidence', sections['Confidence']!, Colors.white70),
          if (sections.containsKey('Details'))
            _buildExplanationRow('Details', sections['Details']!, Colors.white70),
          if (sections.containsKey('Safety Note'))
            _buildExplanationRow('Safety Note', sections['Safety Note']!, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildExplanationRow(String label, String content, Color contentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            content,
            style: TextStyle(color: contentColor, fontSize: 13, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.psychology, color: Color(0xFF0A1F44), size: 48),
        const SizedBox(height: 12),
        const Text('Click to upload a CT scan',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        const Text('Click to Browse Files',
            style: TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickFile,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1ECBFF)),
          child: const Text('Browse Files', style: TextStyle(color: Colors.black)),
        ),
        const SizedBox(height: 8),
        // Change 3 (cont): updated format hint — no more DICOM
        const Text(
          'Supported formats: JPEG, PNG',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _fileSelected() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF00C8FF), size: 48),
        const SizedBox(height: 12),
        Text(
          _selectedFile!.name,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _isLoading ? null : _analyzeFile,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Analyze File'),
        ),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B3C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.5),
              children: [
                TextSpan(text: 'Model trained on '),
                TextSpan(
                  // Change 6: update dataset credit in disclaimer
                  text: 'Brain Stroke CT Dataset (ozguraslank/brain-stroke-ct-dataset)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ' — publicly available for research use on Kaggle.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Disclaimer',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This app is for educational purposes only and should not be used for medical diagnosis or treatment. Always consult a healthcare professional for medical advice.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(
          color: const Color(0xFF0A1F44),
          child: SafeArea(child: NavBar(currentPath: '/analyze')),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scan Analysis',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Change 6 (cont): update subtitle — was "hemorrhagic stroke", now binary
            const Text(
              'Upload a CT scan to detect signs of stroke.',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch, // both columns fill full height
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildUploadBox(),
                        const SizedBox(height: 12),
                        _buildDisclaimer(),
                        // spacer so left column fills remaining height cleanly
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildResultsBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FeedbackPage — unchanged
// ─────────────────────────────────────────────────────────────────────────────

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(
          color: const Color(0xFF0A1F44),
          child: SafeArea(child: NavBar(currentPath: '/feedback')),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text('Feedback Page', style: TextStyle(fontSize: 24)),
            SizedBox(height: 24),
            MyCustomForm(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class StarRatingWidget extends StatefulWidget {
  final int starCount;
  final double initialRating;
  final Color color;
  final ValueChanged<double>? onRatingChanged;

  const StarRatingWidget({
    super.key,
    this.starCount = 5,
    this.initialRating = 0.0,
    this.color = Colors.blue,
    this.onRatingChanged,
  });

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late double rating;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating;
  }

  Widget buildStar(BuildContext context, int index) {
    final icon = index < rating
        ? Icon(Icons.star, size: 24, color: widget.color)
        : const Icon(Icons.star_border, size: 24, color: Colors.grey);
    return GestureDetector(
      onTap: () {
        setState(() => rating = (index + 1).toDouble());
        widget.onRatingChanged?.call(rating);
      },
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (i) => buildStar(context, i)),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRole;
  String? selectedExperience;
  String? selectedPermission;
  double userRating = 0.0;
  String answer1 = '';
  String answer2 = '';

  final List<String> roleItems = ['Medical Professional', 'Researcher', 'Patient', 'Student', 'Other'];
  final List<String> aspectToComment = ['Analysis', 'Home Page', 'Contact Us', 'Overall Experience'];
  final List<String> permissionGranted = [
    'Yes, I give consent to use my feedback to help improve the app',
    'No, I do not give consent to use my feedback',
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            value: selectedRole,
            decoration: const InputDecoration(labelText: 'Your role', border: OutlineInputBorder()),
            hint: const Text('Select a role'),
            items: roleItems.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => selectedRole = v),
            validator: (v) => v == null ? 'Please choose a role' : null,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('How would you rate your experience?', style: TextStyle(fontSize: 14)),
              StarRatingWidget(
                starCount: 5,
                initialRating: userRating,
                color: Colors.amber,
                onRatingChanged: (r) => setState(() => userRating = r),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedExperience,
            decoration: const InputDecoration(labelText: 'Area of feedback', border: OutlineInputBorder()),
            hint: const Text('Area of app you want to comment on'),
            items: aspectToComment.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => selectedExperience = v),
            validator: (v) => v == null ? 'Please select experience' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedPermission,
            decoration: const InputDecoration(labelText: 'Permission to use feedback', border: OutlineInputBorder()),
            hint: const Text('Select permission option'),
            items: permissionGranted.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => selectedPermission = v),
            validator: (v) => v == null ? 'Please select permission' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'How was your experience?',
              hintText: 'Type here...',
            ),
            maxLines: 3,
            onChanged: (v) => answer1 = v,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required field' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Additional comments',
              hintText: 'Type here...',
            ),
            maxLines: 3,
            onChanged: (v) => answer2 = v,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                debugPrint('Form submitted: role=$selectedRole experience=$selectedExperience '
                    'permission=$selectedPermission rating=$userRating '
                    'answer1=$answer1 answer2=$answer2');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'Feedback submitted — thank you!',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFF0A1F44),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}