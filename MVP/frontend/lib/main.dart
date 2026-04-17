import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';

void main() {
  runApp(const StrokeScopeApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/analyze', builder: (context, state) => const AnalyzePage()),
    GoRoute(
      path: '/feedback',
      builder: (context, state) => const FeedbackPage(),
    ),
    GoRoute(path: '/info', builder: (context, state) => const InfoPage()),
  ],
);


const kMaroon = Color(0xFF5A0F1C);     
const kMaroonLight = Color(0xFF7A1B2E); 
const kMaroonDark = Color(0xFF3A0A12);  
const kWhite = Color(0xFFFAFAFA);      
const kNavBg = Color(0xFF4A0D18);       

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
    this.margin = const EdgeInsets.symmetric(horizontal: 8),
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
          _NavLink(label: 'Home', path: '/', currentPath: currentPath),
          _NavLink(label: 'Analyze', path: '/analyze', currentPath: currentPath),
          _NavLink(label: 'Feedback', path: '/feedback', currentPath: currentPath),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final String path;
  final String currentPath;
  const _NavLink({
    required this.label,
    required this.path,
    required this.currentPath,
  });

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
      onExit: (_) => setState(() => _hovered = false),
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

// ─────────────────────────────────────────────
// APP BUTTON (replaces _GlowButton)
// ─────────────────────────────────────────────
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
      onExit: (_) => setState(() => _hovered = false),
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
        child: Text(
          widget.label,
          style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
        ),
      ),
    );
  }
}


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
      backgroundColor: kWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(
          color: kNavBg,
          child: SafeArea(child: NavBar(currentPath: '/')),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: kWhite,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 275),
              // Hero title card
              AppCard(
                child: Text(
                  'Stroke Detection Platform',
                  style: GoogleFonts.bebasNeue(fontSize: 40, color: kWhite),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    label: 'Analyze a Scan',
                    onPressed: () => context.go('/analyze'),
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    label: 'Learn More',
                    onPressed: () => _scrollController.animateTo(
                      600,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Container(height: 2, color: kMaroon),
              const SizedBox(height: 24),
              Text(
                'HOW DOES OUR APP WORK?',
                style: GoogleFonts.bebasNeue(
                  fontSize: 60,
                  color: kMaroonDark,
                  decoration: TextDecoration.underline,
                  decorationColor: kMaroonDark,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  AppCard(
                    width: 200,
                    height: 100,
                    child: Center(
                      child: Text(
                        'Learn',
                        style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text('➡',
                      style: GoogleFonts.bebasNeue(fontSize: 60, color: kMaroon)),
                  AppCard(
                    width: 200,
                    height: 100,
                    child: Center(
                      child: Text(
                        'Upload',
                        style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text('➡',
                      style: GoogleFonts.bebasNeue(fontSize: 60, color: kMaroon)),
                  AppCard(
                    width: 200,
                    height: 100,
                    child: Center(
                      child: Text(
                        'Detect',
                        style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text('➡',
                      style: GoogleFonts.bebasNeue(fontSize: 60, color: kMaroonDark)),
                  AppCard(
                    width: 200,
                    height: 100,
                    child: Center(
                      child: Text(
                        'Results',
                        style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(height: 2, color: kMaroon),
              const SizedBox(height: 14),
              Text(
                'DID YOU KNOW?',
                style: GoogleFonts.bebasNeue(
                  fontSize: 60,
                  color: kMaroonDark,
                  decoration: TextDecoration.underline,
                  decorationColor: kMaroonDark,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  AppCard(
                    width: 400,
                    height: 200,
                    child: Center(
                      child: Text(
                        'A "hemorrhage" is the medical term for bleeding inside your body.',
                        style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  AppCard(
                    width: 400,
                    height: 200,
                    child: Center(
                      child: Text(
                        'A stroke adds extra pressure inside your brain, which can damage or kill brain cells.',
                        style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  AppCard(
                    width: 400,
                    height: 200,
                    child: Center(
                      child: Text(
                        'Every 40 seconds, an individual suffers from a stroke in the U.S., with a death occurring every three minutes (CDC, 2025)',
                        style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(height: 2, color: kMaroon),
              const SizedBox(height: 14),
              Text(
                'WHAT IS A HEMORRHAGIC STROKE?',
                style: GoogleFonts.bebasNeue(
                  fontSize: 60,
                  color: kMaroonDark,
                  decoration: TextDecoration.underline,
                  decorationColor: kMaroonDark,
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                width: 10000,
                height: 200,
                child: Center(
                  child: Text(
                    'Hemorrhagic strokes are the result of a ruptured blood vessel in the brain, either intracerebral (inside the brain) or subarachnoid (between the brain and the skull). In these cases, medical professionals prescribe medication intended to lower brain pressure and swelling, sometimes with the use of blood thinners ("A Neurosurgeon\'s Guide to Stroke," n.d.). Hemorrhagic strokes make up twenty percent of all strokes (NINDS Recognizes Stroke Awareness Month | National Institute of Neurological Disorders and Stroke, 2024).',
                    style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Click here to learn more!',
                onPressed: () => context.go('/info'),
              ),
              const SizedBox(height: 24),
              Container(height: 2, color: kMaroon),
              const SizedBox(height: 14),
              Text(
                'WHAT IS OUR GOAL?',
                style: GoogleFonts.bebasNeue(
                  fontSize: 60,
                  color: kMaroonDark,
                  decoration: TextDecoration.underline,
                  decorationColor: kMaroonDark,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  AppCard(
                    width: 200,
                    height: 100,
                    child: Center(
                      child: Text(
                        'Education',
                        style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  AppCard(
                    width: 200,
                    height: 100,
                    child: Center(
                      child: Text(
                        'Accessibility',
                        style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  AppCard(
                    width: 200,
                    height: 100,
                    child: Center(
                      child: Text(
                        'Speed',
                        style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}


class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(
          color: kNavBg,
          child: const SafeArea(child: NavBar(currentPath: '/')),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: kWhite,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 2, color: kMaroon),
              Text(
                'LEARN MORE ABOUT STROKES',
                style: GoogleFonts.bebasNeue(
                  fontSize: 60,
                  color: kMaroonDark,
                  decoration: TextDecoration.underline,
                  decorationColor: kMaroonDark,
                ),
              ),
              const SizedBox(height: 24),
              AppCard(
                width: 1200,
                child: Text(
                  'Strokes are the fifth leading cause of death in the United States and the second leading cause of death worldwide (NINDS Recognizes Stroke Awareness Month | National Institute of Neurological Disorders and Stroke, 2024). Every 40 seconds, an individual suffers from a stroke in the U.S., with a death occurring every three minutes (CDC, 2025). These devastating incidents are the result of "brain attacks," times at which the brain is cut off from blood circulation, and oxygen is not able to properly reach brain cells. Deprived of vital nutrients, the brain loses nearly two million functioning cells each minute (CDC, 2025). While this damage can be minimized if blood flow is restored quickly, the body\'s natural response often can cause further harm by exerting pressure on the skull and creating tissue damage that cannot be repaired. These outcomes can often lead to seizures or other permanent impairments, making strokes the primary contributor to serious long-term disabilities (CDC, 2025).',
                  style: GoogleFonts.jost(fontSize: 20, color: kWhite),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                width: 1200,
                child: Text(
                  'Despite their ubiquitously negative effects, not all strokes fall under the same category. As shown in Figure 1, there are two main types of strokes, both of which require vastly different courses of medical treatment. First, hemorrhagic strokes are the result of a ruptured blood vessel in the brain, either intracerebral (inside the brain) or subarachnoid (between the brain and the skull). In these cases, medical professionals prescribe medication intended to lower brain pressure and swelling, sometimes with the use of blood thinners ("A Neurosurgeon\'s Guide to Stroke," n.d.). Hemorrhagic and ischemic strokes make up twenty percent and eighty percent of all strokes, respectively (NINDS Recognizes Stroke Awareness Month | National Institute of Neurological Disorders and Stroke, 2024). Ischemic strokes, unlike hemorrhagic ones, are the result of vessel blockage (in the form of clots or plaque) that restricts the flow of blood to the brain. Treatment plans for these patients may include a catheter-based procedure to remove the clot, or "clot-buster" medications that break down the protein that binds blood together (NINDS Recognizes Stroke Awareness Month | National Institute of Neurological Disorders and Stroke, 2024). Although more common, some ischemic strokes appear to be "mini" and harmless; these are coined as transient ischemic attacks (TIA), which can actually serve as a life-threatening symptom for more imminent events (Friends, 2025). Thus, early detection of strokes is the biggest preventative measure, as 80% of these occurrences can be averted (May Is American Stroke Month, n.d.).',
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
                    Image.asset(
                      'images/types-of-stroke-img.webp',
                      width: 500,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Figure 1: Types of Strokes. This visual depicts the three main classes of strokes, which include permanent blockages, vessel ruptures, and temporary blockages (Stroke: Symptoms, Causes, Treatment, Types, and More, n.d.).',
                      style: GoogleFonts.jost(fontSize: 20, color: kWhite),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                width: 1200,
                child: Text(
                  'Despite growing stroke education initiatives, significant gaps remain in current treatment approaches. In the current healthcare system, the average patient must first book an appointment at a local hospital, then get referred to a specialist for brain imaging, wait for approval and an assigned date, and finally either have the results interpreted for future treatment plans or get referred for second and third opinions, in a seemingly never-ending loop (Healthwatch, 2023). Even this proposed path, as further supported by Figure 2, is the optimal case at best. In reality, doctors are in high demand, making it hard to get in contact with a trusted provider in the first place. Additionally, for many, consulting multiple specialists may not be an option, especially for those in resource-limited areas or with financial constraints.',
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
                    Image.asset(
                      'images/process.png',
                      width: 500,
                      height: 400,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Figure 2: Flowchart of Patient Timeline for Receiving Care. This figure models how patients must go through a cycle of booking and waiting for specialist appointments (Healthwatch, 2023).',
                      style: GoogleFonts.jost(fontSize: 20, color: kWhite),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                width: 1200,
                child: Text(
                  'It is this very cycle that jeopardizes patient health. For a condition in which every second counts, this lengthy process actively diminishes an individual\'s chance of a full recovery. In fact, in 2021, the American Stroke Association conducted a study to determine the effects of delayed treatment on the lifespan of severe stroke patients. The study, conducted around 406 individuals with life-threatening artery blockages, revealed that each 10-minute delay in treatment resulted in a loss of eleven months of healthy life (Even Short Delays in the ER May Reduce the Lifespan of Stroke Survivors, n.d.). Thus, rapid detection is vital to stroke recovery.',
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


class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['dcm', 'dicom', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
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
        const Text(
          'Click to upload a CT scan',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text(
          'Click to Browse Files',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickFile,
          style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
          child: const Text('Browse Files', style: TextStyle(color: kWhite)),
        ),
        const SizedBox(height: 8),
        const Text(
          'Supported formats: DICOM, JPEG, PNG',
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ],
    );
  }

  Widget _fileSelected() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: kMaroon, size: 48),
        const SizedBox(height: 12),
        Text(
          _selectedFile!.name,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: kMaroon),
          child: const Text('Analyze File', style: TextStyle(color: kWhite)),
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
          const Text(
            'Disclaimer',
            style: TextStyle(
              color: kMaroonDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.5),
              children: [
                TextSpan(text: 'Model trained on '),
                TextSpan(
                  text: 'RSNA Intracranial Hemorrhage Detection',
                  style: TextStyle(color: kMaroonDark, fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' dataset and '),
                TextSpan(
                  text: 'ISLES 2022',
                  style: TextStyle(color: kMaroonDark, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ' ischemic stroke lesion segmentation dataset — both publicly available for research use.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This app is for educational purposes only and should not be used for medical diagnosis or treatment. Always consult a healthcare professional for medical advice.',
            style: TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(
          color: kNavBg,
          child: SafeArea(child: NavBar(currentPath: '/analyze')),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan Analysis',
              style: GoogleFonts.bebasNeue(fontSize: 32, color: kMaroonDark),
            ),
            const SizedBox(height: 16),
            const Text(
              'Upload a CT scan to detect signs of hemorrhagic stroke.',
              style: TextStyle(color: Colors.black54, fontSize: 18),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildUploadBox(),
                        const SizedBox(height: 12),
                        _buildDisclaimer(),
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

  Widget _buildResultsBox() {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: kMaroonLight.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kMaroon, width: 1.5),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.document_scanner_outlined, color: kMaroon, size: 48),
          SizedBox(height: 12),
          Text(
            'Detection results will appear here after analysis',
            style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            'Await results...',
            style: TextStyle(color: Colors.black45, fontSize: 14),
          ),
        ],
      ),
    );
  }
}


class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(
          color: kNavBg,
          child: SafeArea(child: NavBar(currentPath: '/feedback')),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feedback',
              style: GoogleFonts.bebasNeue(fontSize: 32, color: kMaroonDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'Help us improve StrokeScope.',
              style: TextStyle(color: Colors.black54, fontSize: 18),
            ),
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
    this.starCount = 5,
    this.initialRating = 0.0,
    this.color = kMaroon,
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
    Icon icon;
    if (index < rating) {
      icon = Icon(Icons.star, size: 24, color: widget.color);
    } else {
      icon = const Icon(Icons.star_border, size: 24, color: Colors.grey);
    }
    return GestureDetector(
      onTap: () {
        setState(() => rating = (index + 1).toDouble());
        widget.onRatingChanged?.call(rating);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: icon,
      ),
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

  final List<String> roleItems = [
    'Medical Professional',
    'Researcher',
    'Patient',
    'Student',
    'Other',
  ];

  final List<String> aspectToComment = [
    'Analysis',
    'Home Page',
    'Contact Us',
    'Overall Experience',
  ];

  final List<String> permissionGranted = [
    'Yes, I give consent to use my feedback to help improve the app',
    'No, I do not give consent to use my feedback',
  ];

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kMaroonDark),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kMaroon, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kMaroonDark, width: 2),
      ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: DropdownButtonFormField<String>(
                value: selectedRole,
                dropdownColor: kMaroonLight.withOpacity(0.08),
                style: const TextStyle(color: Colors.black87),
                decoration: _fieldDecoration('Your role'),
                hint: const Text('Select your role',
                    style: TextStyle(color: Colors.black45)),
                items: roleItems
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: Colors.black87)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedRole = v),
                validator: (v) => v == null ? 'Please choose a role' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    const Text(
                      'How would you rate your experience?',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: DropdownButtonFormField<String>(
                value: selectedExperience,
                dropdownColor: kMaroonLight.withOpacity(0.08),
                style: const TextStyle(color: Colors.black87),
                decoration: _fieldDecoration('Area of feedback'),
                hint: const Text('Area of app you want to comment on',
                    style: TextStyle(color: Colors.black45)),
                items: aspectToComment
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: Colors.black87)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedExperience = v),
                validator: (v) => v == null ? 'Please select an area' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextFormField(
                controller: _commentsController,
                maxLines: 5,
                style: const TextStyle(color: Colors.black87),
                decoration: _fieldDecoration('Your comments').copyWith(
                  hintText: 'Share your thoughts about this area...',
                  hintStyle: const TextStyle(color: Colors.black38),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: DropdownButtonFormField<String>(
                value: selectedPermission,
                dropdownColor: kMaroonLight.withOpacity(0.08),
                style: const TextStyle(color: Colors.black87),
                decoration: _fieldDecoration('Permission to use feedback'),
                hint: const Text('Select permission',
                    style: TextStyle(color: Colors.black45)),
                items: permissionGranted
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: Colors.black87)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedPermission = v),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: AppButton(
                label: 'Submit',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    debugPrint(
                      'Form submitted: role=$selectedRole experience=$selectedExperience '
                      'permission=$selectedPermission rating=$userRating comments=${_commentsController.text}',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}