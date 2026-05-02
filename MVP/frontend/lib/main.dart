import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StrokeScopeApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/analyze', builder: (context, state) => const AnalyzePage()),
    GoRoute(path: '/feedback', builder: (context, state) => const FeedbackPage()),
    GoRoute(path: '/info', builder: (context, state) => const InfoPage()),
    GoRoute(path: '/about', builder: (context, state) => const AboutUsPage()),
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
          _NavLink(label: 'About Us', path: '/about', currentPath: currentPath),
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
              const SizedBox(height: 80),
              Text(
                'STROKE SCOPE',
                style: GoogleFonts.bebasNeue(
                  fontSize: 72,
                  color: kMaroonDark,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'AI-Powered Hemorrhagic Stroke Analysis',
                style: GoogleFonts.jost(
                  fontSize: 20,
                  color: Colors.black54,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 32),
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
                      500,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),

            
              Container(height: 2, color: kMaroon),
              const SizedBox(height: 28),
              Text(
                'HOW IT WORKS',
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                  color: kMaroonDark,
                  decoration: TextDecoration.underline,
                  decorationColor: kMaroonDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Three simple steps to fast, accessible stroke screening.',
                style: GoogleFonts.jost(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 28),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _StepCard(
                    number: '01',
                    title: 'Upload',
                    description: 'Submit a CT scan\nin DICOM, JPEG, or PNG format.',
                  ),
                  const _ArrowDivider(),
                  _StepCard(
                    number: '02',
                    title: 'Detect',
                    description: 'Our model analyzes\nthe scan for hemorrhagic markers.',
                  ),
                  const _ArrowDivider(),
                  _StepCard(
                    number: '03',
                    title: 'Results',
                    description: 'Receive a clear,\ninstant classification result.',
                  ),
                ],
              ),
              const SizedBox(height: 48),

           
              Container(height: 2, color: kMaroon),
              const SizedBox(height: 28),
              Text(
                'WHY IT MATTERS',
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                  color: kMaroonDark,
                  decoration: TextDecoration.underline,
                  decorationColor: kMaroonDark,
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  _StatCard(
                    stat: 'Every 40s',
                    detail: 'someone in the U.S. has a stroke',
                    icon: Icons.timer_rounded,
                  ),
                  _StatCard(
                    stat: '80%',
                    detail: 'of strokes are preventable with early analysis',
                    icon: Icons.health_and_safety_rounded,
                  ),
                  _StatCard(
                    stat: '−11 months',
                    detail: 'of life lost every 10 minutes of delayed treatment',
                    icon: Icons.trending_down_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 36),

        
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                decoration: BoxDecoration(
                  color: kMaroon,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'TRY STROKE SCOPE TODAY',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 40,
                        color: kWhite,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload a scan now or learn more about strokes',
                      style: GoogleFonts.jost(
                        fontSize: 16,
                        color: Color(0xFFFAFAFA),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                          onPressed: () => context.go('/info'),
                        ),
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


class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData? icon;

  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kMaroon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kMaroonDark, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: GoogleFonts.bebasNeue(
              fontSize: 36,
              color: kWhite.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 4),
          if (icon != null) Icon(icon, color: kWhite, size: 36),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.bebasNeue(fontSize: 26, color: kWhite),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.jost(
              fontSize: 13,
              color: kWhite.withOpacity(0.75),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ArrowDivider extends StatelessWidget {
  const _ArrowDivider();

  @override
  Widget build(BuildContext context) {
    return Text(
      '›',
      style: TextStyle(
        fontSize: 52,
        color: kMaroon.withOpacity(0.5),
        fontWeight: FontWeight.w200,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String stat;
  final String detail;
  final IconData? icon;

  const _StatCard({
    required this.stat,
    required this.detail,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kMaroon, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kMaroon.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (icon != null) Icon(icon, color: kMaroon, size: 32),
          const SizedBox(height: 12),
          Text(
            stat,
            style: GoogleFonts.bebasNeue(fontSize: 36, color: kMaroonDark),
          ),
          const SizedBox(height: 6),
          Text(
            detail,
            style: GoogleFonts.jost(
              fontSize: 13,
              color: Colors.black54,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(
          color: kNavBg,
          child: SafeArea(child: NavBar(currentPath: '/about')),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(height: 2, color: kMaroon),
            const SizedBox(height: 20),
            Text(
              'ABOUT US',
              style: GoogleFonts.bebasNeue(
                fontSize: 60,
                color: kMaroonDark,
                decoration: TextDecoration.underline,
                decorationColor: kMaroonDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Who we are and why we built StrokeScope.',
              style: GoogleFonts.jost(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 32),

            _SectionHeader(title: 'OUR MISSION'),
            const SizedBox(height: 16),
            AppCard(
              width: 1100,
              child: Text(
                'StrokeScope is built on a simple goal: Life-saving stroke analysis should be accesable regardless of where a patient lives, their wealth and income, or increased wait times. The team set out to create a fast, accessible, and educational platform that uses a CT scan analysis algorithim that is accessible to anyone who needs it, while continuing to recommend users to follow up with a medical professional. ',
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
                  icon: Icons.school_rounded,
                  title: 'Education',
                  description:
                      'Assist the general public, students/researchers, and medical professionals in experimenting with and understanding CT imaging results in real time',
                ),
                _GoalCard(
                  icon: Icons.public_rounded,
                  title: 'Accessibility',
                  description:
                      'Expand imaging software to underprivileged or local clinics that may not have the tools or money to use current resources',
                ),
                _GoalCard(
                  icon: Icons.bolt_rounded,
                  title: 'Speed',
                  description:
                      'Reduce the time between brain scan analysis and action to prevent delays in treatment and permanent damage',
                ),
              ],
            ),
            const SizedBox(height: 36),

            _SectionHeader(title: 'WHAT MOTIVATED US'),
            const SizedBox(height: 16),
            AppCard(
              width: 1100,
              child: Text(
                'The current healthcare system lacks accessibility to medical professionals on a small timeline, with the average stroke patient needing to book an appointment, get referred to a specialist, wait for the imaging approval, then wait again for the results. This cycle spans days or even weeks. For a condition where every 10-minute delay costs 11 healthy living months, the delay is simply risking too many lives. We built StrokeScope to be a first line of information, bridging the gap between a patient\’s concern and the first steps to a diagnosis.',
                style: GoogleFonts.jost(fontSize: 18, color: kWhite, height: 1.7),
                textAlign: TextAlign.center,
              ),
            ), 
            const SizedBox(height: 48),

            Container(height: 2, color: kMaroon),
            const SizedBox(height: 28),
            AppButton(
              label: 'Try the Analyzer',
              onPressed: () => context.go('/analyze'),
            ),
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
    return Text(
      title,
      style: GoogleFonts.bebasNeue(
        fontSize: 42,
        color: kMaroonDark,
        decoration: TextDecoration.underline,
        decorationColor: kMaroonDark,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String description;

  const _GoalCard({
    this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: kMaroon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kMaroonDark, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (icon != null) Icon(icon, color: kWhite, size: 40),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.bebasNeue(fontSize: 28, color: kWhite),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.jost(
              fontSize: 14,
              color: kWhite.withOpacity(0.8),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final String name;
  final String role;
  final IconData? icon;

  const _TeamCard({required this.name, required this.role, this.icon  = Icons.person_rounded });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kMaroon, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kMaroon.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: kMaroon,
            child: const Icon(Icons.person_rounded, color: kWhite, size: 36),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: GoogleFonts.bebasNeue(fontSize: 20, color: kMaroonDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: GoogleFonts.jost(fontSize: 13, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
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
          child: const SafeArea(child: NavBar(currentPath: '/info')),
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
                  'Despite their ubiquitously negative effects, not all strokes fall under the same category. As shown in Figure 1, there are two main types of strokes, both of which require vastly different courses of medical treatment. First, hemorrhagic strokes are the result of a ruptured blood vessel in the brain, either intracerebral (inside the brain) or subarachnoid (between the brain and the skull). In these cases, medical professionals prescribe medication intended to lower brain pressure and swelling, sometimes with the use of blood thinners ("A Neurosurgeon\'s Guide to Stroke," n.d.). Hemorrhagic and ischemic strokes make up twenty percent and eighty percent of all strokes, respectively (NINDS Recognizes Stroke Awareness Month | National Institute of Neurological Disorders and Stroke, 2024). Ischemic strokes, unlike hemorrhagic ones, are the result of vessel blockage (in the form of clots or plaque) that restricts the flow of blood to the brain. Treatment plans for these patients may include a catheter-based procedure to remove the clot, or "clot-buster" medications that break down the protein that binds blood together (NINDS Recognizes Stroke Awareness Month | National Institute of Neurological Disorders and Stroke, 2024). Although more common, some ischemic strokes appear to be "mini" and harmless; these are coined as transient ischemic attacks (TIA), which can actually serve as a life-threatening symptom for more imminent events (Friends, 2025). Thus, early analysis of strokes is the biggest preventative measure, as 80% of these occurrences can be averted (May Is American Stroke Month, n.d.).',
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
                  'It is this very cycle that jeopardizes patient health. For a condition in which every second counts, this lengthy process actively diminishes an individual\'s chance of a full recovery. In fact, in 2021, the American Stroke Association conducted a study to determine the effects of delayed treatment on the lifespan of severe stroke patients. The study, conducted around 406 individuals with life-threatening artery blockages, revealed that each 10-minute delay in treatment resulted in a loss of eleven months of healthy life (Even Short Delays in the ER May Reduce the Lifespan of Stroke Survivors, n.d.). Thus, rapid analysis is vital to stroke recovery.',
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
                  text: 'RSNA Intracranial Hemorrhage Analysis',
                  style: TextStyle(
                    color: kMaroonDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' dataset and '),
                TextSpan(
                  text: 'ISLES 2022',
                  style: TextStyle(
                    color: kMaroonDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text:
                      ' ischemic stroke lesion segmentation dataset — both publicly available for research use.',
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

  Widget _buildResultsBox() {
    return Container(
      constraints: const BoxConstraints(minHeight: 320),
      decoration: BoxDecoration(
        color: kMaroonLight.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kMaroon, width: 1.5),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.document_scanner_outlined, color: kMaroon, size: 48),
              SizedBox(height: 12),
              Text(
                'Analysis results will appear here after processing',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6),
              Text(
                'Await results...',
                style: TextStyle(color: Colors.black45, fontSize: 14),
              ),
            ],
          ),
        ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const SizedBox(height: 24),
          ],
        ),
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
      data: Theme.of(context).copyWith(
        canvasColor: kMaroonLight.withOpacity(0.08),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: DropdownButtonFormField<String>(
                value: selectedRole,
                dropdownColor: const Color.fromARGB(255, 145, 60, 60),
                style: const TextStyle(color: Colors.black87),
                decoration: _fieldDecoration('Your role'),
                hint: const Text(
                  'Select your role',
                  style: TextStyle(color: Colors.black45),
                ),
                items: roleItems
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    )
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
                dropdownColor: const Color.fromARGB(255, 145, 60, 60),
                style: const TextStyle(color: Colors.black87),
                decoration: _fieldDecoration('Area of feedback'),
                hint: const Text(
                  'Area of app you want to comment on',
                  style: TextStyle(color: Colors.black45),
                ),
                items: aspectToComment
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    )
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
                dropdownColor: const Color.fromARGB(255, 145, 60, 60),
                style: const TextStyle(color: Colors.black87),
                decoration: _fieldDecoration('Permission to use feedback'),
                hint: const Text(
                  'Select permission',
                  style: TextStyle(color: Colors.black45),
                ),
                items: permissionGranted
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => selectedPermission = v),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: AppButton(
                label: 'Submit',
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await FirebaseFirestore.instance.collection('feedback').add({
                      'role': selectedRole,
                      'rating': userRating,
                      'area': selectedExperience,
                      'comments': _commentsController.text,
                      'permission': selectedPermission,
                      'submittedAt': FieldValue.serverTimestamp(),
                      'consentGiven': selectedPermission?.startsWith('Yes') ?? false,
                    });
                    _formKey.currentState?.reset();
                    _commentsController.clear();
                    setState(() {
                      selectedRole = null;
                      selectedExperience = null;
                      selectedPermission = null;
                      userRating = 0.0;
                    });
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Feedback submitted!')),
                      );
                    }
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