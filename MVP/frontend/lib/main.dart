import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
          // Need to add logo to is a place holder
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
          _NavLink(
            label: 'Analyze',
            path: '/analyze',
            currentPath: currentPath,
          ),
          _NavLink(
            label: 'Feedback',
            path: '/feedback',
            currentPath: currentPath,
          ),
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

  // need to figure out hover at some point

  @override
  Widget build(BuildContext context) {
    final isActive = currentPath == path;

    return GestureDetector(
      onTap: () => context.go(path),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(label, style: TextStyle(color: Colors.white, fontSize: 15)),
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
                    child: Text(
                      'Analyze a Scan',
                      style: GoogleFonts.bebasNeue(fontSize: 28),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _scrollController.animateTo(
                      600,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    ),
                    child: Text(
                      'Learn More',
                      style: GoogleFonts.bebasNeue(fontSize: 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Container(height: 2, color: Colors.black),
              const SizedBox(height: 24),
              Text(
                'HOW DOES OUR APP WORK?',
                style: GoogleFonts.bebasNeue(
                  fontSize: 60,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  Container(
                    width: 200,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color(0xFF0A1F44),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'learn',
                        style: GoogleFonts.bebasNeue(fontSize: 28),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  Text('➡', style: GoogleFonts.bebasNeue(fontSize: 60)),
                  Container(
                    width: 200,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color(0xFF0A1F44),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'Upload',
                        style: GoogleFonts.bebasNeue(fontSize: 28),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  Text('➡', style: GoogleFonts.bebasNeue(fontSize: 60)),
                  Container(
                    width: 200,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color(0xFF0A1F44),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'Detect',
                        style: GoogleFonts.bebasNeue(fontSize: 28),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  Text('➡', style: GoogleFonts.bebasNeue(fontSize: 60)),
                  Container(
                    width: 200,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color(0xFF0A1F44),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'Results',
                        style: GoogleFonts.bebasNeue(fontSize: 28),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(height: 2, color: Colors.black),
              const SizedBox(height: 14),
              Text(
                'DID YOU KNOW?',
                style: GoogleFonts.bebasNeue(
                  fontSize: 60,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  Container(
                    width: 400,
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color(0xFF0A1F44),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'A "hemorrhage" is the medical term for bleeding inside your body.',
                        style: GoogleFonts.bebasNeue(fontSize: 28),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color(0xFF0A1F44),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'A stroke adds extra pressure inside your brain, which can damage or kill brain cells.',
                        style: GoogleFonts.bebasNeue(fontSize: 28),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color(0xFF0A1F44),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'Every 40 seconds, an individual suffers from a stroke in the U.S., with a death occurring every three minutes (CDC, 2025)',
                        style: GoogleFonts.bebasNeue(fontSize: 28),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Container(height: 2, color: Colors.black),
              const SizedBox(height: 14),
              Text(
                'WHAT IS A HEMORRHAGIC STROKE?',
                style: GoogleFonts.bebasNeue(
                  fontSize: 60,
                  decoration: TextDecoration.underline,
                ),
              ),
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
                    'Hemorrhagic strokes are the result of a ruptured blood vessel in the brain, either intracerebral (inside the brain) or subarachnoid (between the brain and the skull). In these cases, medical professionals prescribe medication intended to lower brain pressure and swelling, sometimes with the use of blood thinners (“A Neurosurgeon’s Guide to Stroke,” n.d.). Hemorrhagic strokes make up twenty percent of all strokes (NINDS Recognizes Stroke Awareness Month | National Institute of Neurological Disorders and Stroke, 2024). ',
                    style: GoogleFonts.bebasNeue(fontSize: 28),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => context.go('/analyze'),
                child: Text(
                  'Click here to learn more!',
                  style: GoogleFonts.bebasNeue(fontSize: 28),
                ),
              ),
              const SizedBox(height: 24),
              Container(height: 2, color: Colors.black),
              const SizedBox(height: 14),
              Text(
                'WHAT IS OUR GOAL?',
                style: GoogleFonts.bebasNeue(
                  fontSize: 60,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  Container(
                    width: 200,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color(0xFF0A1F44),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'Education',
                        style: GoogleFonts.bebasNeue(fontSize: 28),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),

                  Container(
                    width: 200,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color(0xFF0A1F44),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'Accessibility',
                        style: GoogleFonts.bebasNeue(fontSize: 28),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color(0xFF0A1F44),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'Speed',
                        style: GoogleFonts.bebasNeue(fontSize: 28),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnalyzePage extends StatelessWidget {
  const AnalyzePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(
          color: const Color(0xFF0A1F44),
          child: SafeArea(child: NavBar(currentPath: '/analyze')),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Analysis Page', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to Home'),
            ),
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(
          color: const Color(0xFF0A1F44),
          child: SafeArea(child: NavBar(currentPath: '/feedback')),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Feedback Page', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            const MyCustomForm(),
          ],
        ),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  String? selectedValue;
  final List<String> items = [
    'Medical Professional',
    'Researcher',
    'Patient',
    'Student',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: DropdownButton<String>(
            value: selectedValue,
            hint: const Text('Select an option'),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue;
              });
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Type Here...',
            ),
          ),
        ),
        //add a overall experience star rating at some point
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: ElevatedButton(
            onPressed: () {
              // Handle form submission
              print('Form submitted with selected value: $selectedValue');
            },
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }
}
