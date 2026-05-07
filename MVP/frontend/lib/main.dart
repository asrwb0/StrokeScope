import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dio/dio.dart';

// ── API base URL ───────────────────────────────────────────────────────────────
const String _apiBase = 'http://localhost:8000';

// ── Brand colors ───────────────────────────────────────────────────────────────
const kMaroon      = Color(0xFF5A0F1C);
const kMaroonLight = Color(0xFF7A1B2E);
const kMaroonDark  = Color(0xFF3A0A12);
const kWhite       = Color(0xFFFAFAFA);
const kNavBg       = Color(0xFF4A0D18);

// ── Entry point ────────────────────────────────────────────────────────────────
void main() {
  runApp(const StrokeScopeApp());
}

// ── Router ─────────────────────────────────────────────────────────────────────
final _router = GoRouter(
  routes: [
    GoRoute(path: '/',         builder: (context, state) => const HomePage()),
    GoRoute(path: '/analyze',  builder: (context, state) => const AnalyzePage()),
    GoRoute(path: '/feedback', builder: (context, state) => const FeedbackPage()),
    GoRoute(path: '/info',     builder: (context, state) => const InfoPage()),
    GoRoute(path: '/about',    builder: (context, state) => const AboutUsPage()),
  ],
);

// ── Root app ───────────────────────────────────────────────────────────────────
class StrokeScopeApp extends StatelessWidget {
  const StrokeScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'StrokeScope',
      routerConfig: _router,
      theme: ThemeData(colorSchemeSeed: kMaroon, useMaterial3: true),
    );
  }
}

// ── Shared card container ──────────────────────────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const AppCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin  = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: kMaroon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kMaroonDark, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Shared button ──────────────────────────────────────────────────────────────
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const AppButton({super.key, required this.label, required this.onPressed});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _hovered ? kMaroonDark : kMaroon,
          foregroundColor: kWhite,
          side: const BorderSide(color: kMaroonDark, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: _hovered ? 4 : 2,
        ),
        child: Text(widget.label, style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite)),
      ),
    );
  }
}

// ── NavBar ─────────────────────────────────────────────────────────────────────
class NavBar extends StatelessWidget {
  final String currentPath;
  const NavBar({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      color: kNavBg,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/icon.png'),
          ),
          const Text(
            'Stroke Scope',
            style: TextStyle(
              color: kWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          _NavLink(label: 'Home',     path: '/',         currentPath: currentPath),
          _NavLink(label: 'Analyze',  path: '/analyze',  currentPath: currentPath),
          _NavLink(label: 'Feedback', path: '/feedback', currentPath: currentPath),
          _NavLink(label: 'About Us', path: '/about',    currentPath: currentPath),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final String path;
  final String currentPath;
  const _NavLink({required this.label, required this.path, required this.currentPath});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.currentPath == widget.path;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.path),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isActive || _hovered
                ? Colors.white.withOpacity(0.2)
                : Colors.transparent,
            border: Border.all(
              color: isActive || _hovered
                  ? Colors.white.withOpacity(0.8)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: kWhite,
              fontSize: 15,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOME PAGE
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
    final double topSectionHeight = MediaQuery.of(context).size.height - 68;

    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(color: kNavBg, child: SafeArea(child: NavBar(currentPath: '/'))),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: kWhite,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: topSectionHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'STROKE SCOPE',
                      style: GoogleFonts.bebasNeue(fontSize: 72, color: kMaroonDark, letterSpacing: 4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AI-Powered Hemorrhagic Stroke Analysis',
                      style: GoogleFonts.jost(fontSize: 20, color: Colors.black54, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppButton(label: 'Analyze a Scan', onPressed: () => context.go('/analyze')),
                        const SizedBox(width: 12),
                        AppButton(
                          label: 'Learn More',
                          onPressed: () => _scrollController.animateTo(
                            topSectionHeight,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64),
              Text('HOW IT WORKS', style: GoogleFonts.bebasNeue(fontSize: 52, color: kMaroonDark)),
              const SizedBox(height: 8),
              Text(
                'Three simple steps to fast, accessible stroke screening.',
                style: GoogleFonts.jost(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 36),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 24,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _Step(number: '01', title: 'Upload',  description: 'Submit a CT scan in JPEG or PNG format.'),
                  const _ArrowDivider(),
                  _Step(number: '02', title: 'Detect',  description: 'Our model analyses the scan for stroke markers.'),
                  const _ArrowDivider(),
                  _Step(number: '03', title: 'Results', description: 'Receive a clear, instant classification result.'),
                ],
              ),
              const SizedBox(height: 64),
              Text('WHY IT MATTERS', style: GoogleFonts.bebasNeue(fontSize: 52, color: kMaroonDark)),
              const SizedBox(height: 36),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 24,
                children: [
                  _Stat(stat: 'Every 40s',  detail: 'someone in the U.S. has a stroke',                    icon: Icons.timer_rounded),
                  _Stat(stat: '80%',        detail: 'of strokes are preventable with early analysis',       icon: Icons.health_and_safety_rounded),
                  _Stat(stat: '−11 months', detail: 'of healthy life lost per 10-min treatment delay',      icon: Icons.trending_down_rounded),
                ],
              ),
              const SizedBox(height: 64),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                decoration: BoxDecoration(color: kMaroon, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Text(
                      'TRY STROKE SCOPE TODAY',
                      style: GoogleFonts.bebasNeue(fontSize: 40, color: kWhite, letterSpacing: 2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload a scan now or learn more about strokes',
                      style: GoogleFonts.jost(fontSize: 16, color: kWhite),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppButton(label: 'Analyze a Scan', onPressed: () => context.go('/analyze')),
                        const SizedBox(width: 12),
                        AppButton(label: 'Learn More',     onPressed: () => context.go('/info')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData? icon;

  const _Step({required this.number, required this.title, required this.description, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kMaroon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kMaroonDark, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(number, style: GoogleFonts.bebasNeue(fontSize: 36, color: kWhite.withOpacity(0.3))),
          const SizedBox(height: 4),
          if (icon != null) Icon(icon, color: kWhite, size: 36),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.bebasNeue(fontSize: 26, color: kWhite)),
          const SizedBox(height: 8),
          Text(description,
              style: GoogleFonts.jost(fontSize: 13, color: kWhite.withOpacity(0.75), height: 1.5),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ArrowDivider extends StatelessWidget {
  const _ArrowDivider();

  @override
  Widget build(BuildContext context) {
    return Text('›', style: TextStyle(fontSize: 52, color: kMaroon.withOpacity(0.5), fontWeight: FontWeight.w200));
  }
}

class _Stat extends StatelessWidget {
  final String stat;
  final String detail;
  final IconData? icon;

  const _Stat({required this.stat, required this.detail, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kMaroon, width: 1.5),
        boxShadow: [BoxShadow(color: kMaroon.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          if (icon != null) Icon(icon, color: kMaroon, size: 32),
          const SizedBox(height: 12),
          Text(stat, style: GoogleFonts.bebasNeue(fontSize: 36, color: kMaroonDark)),
          const SizedBox(height: 6),
          Text(detail,
              style: GoogleFonts.jost(fontSize: 13, color: Colors.black54, height: 1.5),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANALYZE PAGE
// ─────────────────────────────────────────────────────────────────────────────

class AnalyzeResult {
  final String predictedClass;
  final double confidence;
  final String confidenceTier;
  final double strokeProbability;
  final bool lowConfidence;
  final Map<String, double> allClassScores;
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
        (json['all_class_scores'] as Map).map((k, v) => MapEntry(k as String, (v as num).toDouble())),
      ),
      llmExplanation: json['llm_explanation'] as String?,
      disclaimer:     json['disclaimer'] as String,
    );
  }
}

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  PlatformFile? _selectedFile;
  bool _isLoading = false;
  AnalyzeResult? _result;
  String? _error;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'bmp'],
    );
    if (result != null) setState(() => _selectedFile = result.files.first);
  }

  Future<void> _analyzeFile() async {
    if (_selectedFile == null) return;
    setState(() { _isLoading = true; _error = null; _result = null; });

    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(_selectedFile!.bytes!, filename: _selectedFile!.name),
      });
      final response = await dio.post('$_apiBase/api/analyze', data: formData);
      setState(() => _result = AnalyzeResult.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      setState(() => _error = e.response?.data?['detail'] ?? e.response?.data?['message'] ?? 'Request failed. Is the backend running?');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(color: kNavBg, child: SafeArea(child: NavBar(currentPath: '/analyze'))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scan Analysis', style: GoogleFonts.bebasNeue(fontSize: 32, color: kMaroonDark)),
            const SizedBox(height: 8),
            Text('Upload a CT scan to detect signs of stroke.',
                style: GoogleFonts.jost(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildUploadBox(),
                        const SizedBox(height: 12),
                        _buildDisclaimer(),
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

  Widget _buildUploadBox() {
    return DottedBorder(
      color: kMaroon,
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
            color: kMaroonLight.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _selectedFile == null ? _emptyState() : _fileSelected(),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.psychology, color: kMaroon, size: 48),
        const SizedBox(height: 12),
        Text('Click to upload a CT scan', style: GoogleFonts.jost(color: Colors.black87, fontSize: 16)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickFile,
          style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
          child: Text('Browse Files', style: GoogleFonts.jost(color: kWhite)),
        ),
        const SizedBox(height: 8),
        Text('Supported formats: JPEG, PNG, BMP',
            style: GoogleFonts.jost(color: Colors.black45, fontSize: 12)),
      ],
    );
  }

  Widget _fileSelected() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: kMaroon, size: 48),
        const SizedBox(height: 12),
        Text(_selectedFile!.name,
            style: GoogleFonts.jost(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _isLoading ? null : _analyzeFile,
          style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: kWhite))
              : Text('Analyze File', style: GoogleFonts.jost(color: kWhite)),
        ),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kMaroonLight.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kMaroon, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Disclaimer', style: GoogleFonts.bebasNeue(fontSize: 20, color: kMaroonDark)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.jost(color: Colors.black54, fontSize: 12, height: 1.5),
              children: const [
                TextSpan(text: 'Model trained on '),
                TextSpan(
                  text: 'Brain Stroke CT Dataset (ozguraslank/brain-stroke-ct-dataset)',
                  style: TextStyle(color: kMaroonDark, fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' — publicly available for research use on Kaggle.'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This app is for educational purposes only and should not be used for medical diagnosis or treatment. Always consult a healthcare professional for medical advice.',
            style: GoogleFonts.jost(color: Colors.black87, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsBox() {
    Widget body;

    if (_error != null) {
      body = Center(child: Text(_error!, style: GoogleFonts.jost(color: Colors.redAccent, fontSize: 14)));
    } else if (_result == null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.document_scanner_outlined, color: kMaroon, size: 48),
            const SizedBox(height: 12),
            Text('Detection results will appear here after analysis',
                style: GoogleFonts.jost(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text('Await results...', style: GoogleFonts.jost(color: Colors.black45, fontSize: 14)),
          ],
        ),
      );
    } else {
      body = SingleChildScrollView(child: _buildBinaryResult(_result!));
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: kMaroonLight.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kMaroon, width: 1.5),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: body),
    );
  }

  Widget _buildBinaryResult(AnalyzeResult result) {
    final isStroke    = result.predictedClass == 'Stroke';
    final accentColor = isStroke ? Colors.red.shade700 : Colors.green.shade700;
    final verdictIcon = isStroke ? '⚠' : '✓';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$verdictIcon  ${isStroke ? "Stroke Detected" : "No Stroke Detected"}',
          style: GoogleFonts.bebasNeue(fontSize: 28, color: accentColor),
        ),
        const SizedBox(height: 4),
        Text(
          '${result.confidenceTier} confidence  •  ${(result.confidence * 100).toStringAsFixed(1)}%',
          style: GoogleFonts.jost(color: Colors.black54, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Text('Class Probabilities', style: GoogleFonts.jost(color: Colors.black54, fontSize: 13)),
        const SizedBox(height: 8),
        _buildScoreBar('Normal', result.allClassScores['Normal'] ?? 0.0, Colors.green.shade600),
        const SizedBox(height: 8),
        _buildScoreBar('Stroke', result.allClassScores['Stroke'] ?? 0.0, Colors.red.shade600),

        if (result.lowConfidence) ...[
          const SizedBox(height: 12),
          Text('⚠ Low confidence result — interpret with caution.',
              style: GoogleFonts.jost(color: Colors.amber.shade800, fontSize: 12)),
        ],

        if (result.llmExplanation != null) ...[
          const SizedBox(height: 20),
          Text('EXPLANATION OF RESULTS',
              style: GoogleFonts.jost(
                  color: kMaroonDark, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _buildExplanationCard(result.llmExplanation!),
        ],

        const SizedBox(height: 16),
        Text(result.disclaimer,
            style: GoogleFonts.jost(color: Colors.black38, fontSize: 11, height: 1.4)),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildScoreBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.jost(color: Colors.black87, fontSize: 13)),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: kMaroon.withOpacity(0.1),
          color: color,
          minHeight: 8,
        ),
        Text('${(value * 100).toStringAsFixed(1)}%',
            style: GoogleFonts.jost(color: Colors.black45, fontSize: 11)),
      ],
    );
  }

  Widget _buildExplanationCard(String raw) {
    final sectionLabels = ['Finding', 'Confidence', 'Details', 'Safety Note'];
    final Map<String, String> sections = {};

    for (int i = 0; i < sectionLabels.length; i++) {
      final label = sectionLabels[i];
      final start = raw.indexOf('$label:');
      if (start == -1) continue;
      final contentStart = start + label.length + 1;
      int end = raw.length;
      for (int j = i + 1; j < sectionLabels.length; j++) {
        final nextIdx = raw.indexOf('${sectionLabels[j]}:');
        if (nextIdx != -1 && nextIdx < end) end = nextIdx;
      }
      sections[label] = raw.substring(contentStart, end).trim();
    }

    if (sections.isEmpty) {
      return Text(raw, style: GoogleFonts.jost(color: Colors.black87, fontSize: 13, height: 1.5));
    }

    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kMaroon.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sections.containsKey('Finding'))
            _buildExplanationRow('Finding',     sections['Finding']!,     Colors.black87),
          if (sections.containsKey('Confidence'))
            _buildExplanationRow('Confidence',  sections['Confidence']!,  Colors.black54),
          if (sections.containsKey('Details'))
            _buildExplanationRow('Details',     sections['Details']!,     Colors.black54),
          if (sections.containsKey('Safety Note'))
            _buildExplanationRow('Safety Note', sections['Safety Note']!, Colors.amber.shade800),
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
          Text(label.toUpperCase(),
              style: GoogleFonts.jost(
                  color: kMaroonDark, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(content, style: GoogleFonts.jost(color: contentColor, fontSize: 13, height: 1.45)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FEEDBACK PAGE
// ─────────────────────────────────────────────────────────────────────────────
class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(color: kNavBg, child: SafeArea(child: NavBar(currentPath: '/feedback'))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Feedback', style: GoogleFonts.bebasNeue(fontSize: 32, color: kMaroonDark)),
            const SizedBox(height: 8),
            Text('Help us improve StrokeScope.',
                style: GoogleFonts.jost(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 24),
            const MyCustomForm(),
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
    this.starCount     = 5,
    this.initialRating = 0.0,
    this.color         = kMaroon,
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
  double userRating = 0.0;
  String? selectedExperience;
  String? selectedPermission;
  final TextEditingController _commentsController = TextEditingController();

  final List<String> roleItems         = ['Medical Professional', 'Researcher', 'Patient', 'Student', 'Other'];
  final List<String> aspectToComment   = ['Analysis', 'Home Page', 'Contact Us', 'Overall Experience'];
  final List<String> permissionGranted = [
    'Yes, I give consent to use my feedback to help improve the app',
    'No, I do not give consent to use my feedback',
  ];

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kMaroonDark),
      border:        OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kMaroon, width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kMaroonDark, width: 2)),
      filled: true,
      fillColor: kMaroonLight.withOpacity(0.08),
    );
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: kMaroonLight.withOpacity(0.08)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: DropdownButtonFormField<String>(
                value: selectedRole,
                dropdownColor: const Color.fromARGB(255, 145, 60, 60),
                style: const TextStyle(color: Colors.black87),
                decoration: _fieldDecoration('Your role'),
                hint: const Text('Select your role', style: TextStyle(color: Colors.black45)),
                items: roleItems
                    .map((v) => DropdownMenuItem(
                        value: v, child: Text(v, style: const TextStyle(color: Colors.black87))))
                    .toList(),
                onChanged: (v) => setState(() => selectedRole = v),
                validator: (v) => v == null ? 'Please choose a role' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kMaroonLight.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kMaroon, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('How would you rate your experience?',
                        style: GoogleFonts.jost(color: Colors.black87, fontSize: 14)),
                    StarRatingWidget(
                      starCount: 5,
                      initialRating: userRating,
                      color: kMaroon,
                      onRatingChanged: (r) => setState(() => userRating = r),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: DropdownButtonFormField<String>(
                value: selectedExperience,
                dropdownColor: const Color.fromARGB(255, 145, 60, 60),
                style: const TextStyle(color: Colors.black87),
                decoration: _fieldDecoration('Area of feedback'),
                hint: const Text('Area of app you want to comment on',
                    style: TextStyle(color: Colors.black45)),
                items: aspectToComment
                    .map((v) => DropdownMenuItem(
                        value: v, child: Text(v, style: const TextStyle(color: Colors.black87))))
                    .toList(),
                onChanged: (v) => setState(() => selectedExperience = v),
                validator: (v) => v == null ? 'Please select an area' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextFormField(
                controller: _commentsController,
                maxLines: 5,
                style: const TextStyle(color: Colors.black87),
                decoration: _fieldDecoration('Your comments').copyWith(
                  hintText: 'Share your thoughts...',
                  hintStyle: const TextStyle(color: Colors.black38),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: DropdownButtonFormField<String>(
                value: selectedPermission,
                dropdownColor: const Color.fromARGB(255, 145, 60, 60),
                style: const TextStyle(color: Colors.black87),
                decoration: _fieldDecoration('Permission to use feedback'),
                hint: const Text('Select permission', style: TextStyle(color: Colors.black45)),
                items: permissionGranted
                    .map((v) => DropdownMenuItem(
                        value: v, child: Text(v, style: const TextStyle(color: Colors.black87))))
                    .toList(),
                onChanged: (v) => setState(() => selectedPermission = v),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Submit',
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  await Dio().post('$_apiBase/api/feedback', data: {
                    'role':         selectedRole,
                    'rating':       userRating,
                    'area':         selectedExperience,
                    'comments':     _commentsController.text,
                    'permission':   selectedPermission,
                    'consentGiven': selectedPermission?.startsWith('Yes') ?? false,
                  });
                  _formKey.currentState?.reset();
                  _commentsController.clear();
                  setState(() {
                    selectedRole       = null;
                    selectedExperience = null;
                    selectedPermission = null;
                    userRating         = 0.0;
                  });
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: kWhite),
                            SizedBox(width: 12),
                            Text('Feedback submitted — thank you!',
                                style: TextStyle(color: kWhite, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        backgroundColor: kMaroonDark,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ABOUT US PAGE
// ─────────────────────────────────────────────────────────────────────────────
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(color: kNavBg, child: SafeArea(child: NavBar(currentPath: '/about'))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(height: 2, color: kMaroon),
            const SizedBox(height: 20),
            Text('ABOUT US',
                style: GoogleFonts.bebasNeue(
                    fontSize: 60,
                    color: kMaroonDark,
                    decoration: TextDecoration.underline,
                    decorationColor: kMaroonDark)),
            const SizedBox(height: 8),
            Text('Why did we build StrokeScope?',
                style: GoogleFonts.jost(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 32),
            _SectionHeader(title: 'OUR MISSION'),
            const SizedBox(height: 16),
            AppCard(
              width: 1100,
              child: Text(
                'StrokeScope was built on the belief that life-saving stroke analysis should not be gated by geography, wealth, or wait times. We set out to create a fast, accessible, and educational platform that puts preliminary CT scan analysis in the hands of anyone who needs it — while always encouraging users to follow up with a qualified medical professional.',
                style: GoogleFonts.jost(fontSize: 18, color: kWhite, height: 1.7),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 36),
            _SectionHeader(title: 'OUR GOALS'),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: [
                _GoalCard(
                  icon: Icons.public_rounded,
                  title: 'Accessibility',
                  description: 'Expand imaging software to underprivileged or local clinics that may not have the tools or money to use current resources.',
                ),
                _GoalCard(
                  icon: Icons.school_rounded,
                  title: 'Education',
                  description: 'Assist the general public, students, researchers, and medical professionals in understanding CT imaging results in real time.',
                ),
                _GoalCard(
                  icon: Icons.bolt_rounded,
                  title: 'Speed',
                  description: 'Reduce the time between brain scan analysis and action to prevent delays in treatment and permanent damage.',
                ),
              ],
            ),
            const SizedBox(height: 36),
            _SectionHeader(title: 'WHAT MOTIVATED US'),
            const SizedBox(height: 16),
            AppCard(
              width: 1100,
              child: Text(
                'The current healthcare system lacks accessibility to medical professionals on a small timeline. This cycle spans days or even weeks. For a condition where every 10-minute delay costs 11 healthy living months, the delay is simply risking too many lives. We built StrokeScope to be a first line of information, bridging the gap between a patient\'s concern and the first steps to a diagnosis.',
                style: GoogleFonts.jost(fontSize: 18, color: kWhite, height: 1.7),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 36),
            Container(height: 2, color: kMaroon),
            const SizedBox(height: 28),
            AppButton(label: 'Try the Analyzer', onPressed: () => context.go('/analyze')),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: GoogleFonts.bebasNeue(
            fontSize: 42,
            color: kMaroonDark,
            decoration: TextDecoration.underline,
            decorationColor: kMaroonDark,
            letterSpacing: 1.5));
  }
}

class _GoalCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String description;

  const _GoalCard({this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: kMaroon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kMaroonDark, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          if (icon != null) Icon(icon, color: kWhite, size: 40),
          const SizedBox(height: 14),
          Text(title, style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite)),
          const SizedBox(height: 10),
          Text(description,
              style: GoogleFonts.jost(fontSize: 14, color: kWhite.withOpacity(0.8), height: 1.6),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INFO PAGE
// ─────────────────────────────────────────────────────────────────────────────
class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(color: kNavBg, child: const SafeArea(child: NavBar(currentPath: '/info'))),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: kWhite,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 2, color: kMaroon),
              Text('LEARN MORE ABOUT STROKES',
                  style: GoogleFonts.bebasNeue(
                      fontSize: 60,
                      color: kMaroonDark,
                      decoration: TextDecoration.underline,
                      decorationColor: kMaroonDark)),
              const SizedBox(height: 24),
              AppCard(
                width: 1200,
                child: Text(
                  'Strokes are the fifth leading cause of death in the United States and the second leading cause of death worldwide (NINDS, 2024). Every 40 seconds, an individual suffers from a stroke in the U.S., with a death occurring every three minutes (CDC, 2025). These devastating incidents are the result of "brain attacks," times at which the brain is cut off from blood circulation, and oxygen is not able to properly reach brain cells. Deprived of vital nutrients, the brain loses nearly two million functioning cells each minute (CDC, 2025).',
                  style: GoogleFonts.jost(fontSize: 20, color: kWhite),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                width: 1200,
                child: Text(
                  'There are two main types of strokes, both of which require vastly different courses of medical treatment. Hemorrhagic strokes are the result of a ruptured blood vessel in the brain. Ischemic strokes, unlike hemorrhagic ones, are the result of vessel blockage that restricts the flow of blood to the brain. Hemorrhagic and ischemic strokes make up twenty percent and eighty percent of all strokes, respectively (NINDS, 2024). Early analysis is the biggest preventative measure, as 80% of these occurrences can be averted.',
                  style: GoogleFonts.jost(fontSize: 20, color: kWhite),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                width: 900,
                child: Column(
                  children: [
                    Image.asset('images/types-of-stroke-img.webp', width: 500, height: 400, fit: BoxFit.cover),
                    const SizedBox(height: 8),
                    Text(
                      'Figure 1: Types of Strokes (Stroke: Symptoms, Causes, Treatment, Types, and More, n.d.).',
                      style: GoogleFonts.jost(fontSize: 16, color: kWhite),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                width: 1200,
                child: Text(
                  'In the current healthcare system, the average patient must first book an appointment, get referred to a specialist, wait for imaging approval, and finally have results interpreted — a process spanning days or even weeks. For a condition in which every second counts, this lengthy process actively diminishes an individual\'s chance of a full recovery. Each 10-minute delay in treatment results in a loss of eleven months of healthy life (American Stroke Association, 2021).',
                  style: GoogleFonts.jost(fontSize: 20, color: kWhite),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}