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
    GoRoute(path: '/info', builder: (context, state) => const InfoPage()),
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
      height: 75,
      color: const Color(0xFF0A1F44),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/icon.png'),
          ),
          const Text(
            'Stroke Scope ',
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
                onPressed: () => context.go('/info'),
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

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Material(
          color: const Color(0xFF0A1F44),
          child: const SafeArea(child: NavBar(currentPath: '/')),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 230, 235, 255),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 2, color: Colors.black),
              Text(
                'LEARN MORE ABOUT STROKES',
                style: GoogleFonts.bebasNeue(
                  fontSize: 60,
                  decoration: TextDecoration.underline,
                ),
              ),

              const SizedBox(height: 24),
              Container(
                width: 1200,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF0A1F44), width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Strokes are the fifth leading cause of death in the United States and the second leading cause of death worldwide (NINDS Recognizes Stroke Awareness Month | National Institute of Neurological Disorders and Stroke, 2024). Every 40 seconds, an individual suffers from a stroke in the U.S., with a death occurring every three minutes (CDC, 2025). These devastating incidents are the result of "brain attacks," times at which the brain is cut off from blood circulation, and oxygen is not able to properly reach brain cells. Deprived of vital nutrients, the brain loses nearly two million functioning cells each minute (CDC, 2025). While this damage can be minimized if blood flow is restored quickly, the body\'s natural response often can cause further harm by exerting pressure on the skull and creating tissue damage that cannot be repaired. These outcomes can often lead to seizures or other permanent impairments, making strokes the primary contributor to serious long-term disabilities (CDC, 2025).',
                  style: GoogleFonts.jost(fontSize: 20),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 1200,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF0A1F44), width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Despite their ubiquitously negative effects, not all strokes fall under the same category. As shown in Figure 1, there are two main types of strokes, both of which require vastly different courses of medical treatment. First, hemorrhagic strokes are the result of a ruptured blood vessel in the brain, either intracerebral (inside the brain) or subarachnoid (between the brain and the skull). In these cases, medical professionals prescribe medication intended to lower brain pressure and swelling, sometimes with the use of blood thinners ("A Neurosurgeon\'s Guide to Stroke," n.d.). Hemorrhagic and ischemic strokes make up twenty percent and eighty percent of all strokes, respectively (NINDS Recognizes Stroke Awareness Month | National Institute of Neurological Disorders and Stroke, 2024). Ischemic strokes, unlike hemorrhagic ones, are the result of vessel blockage (in the form of clots or plaque) that restricts the flow of blood to the brain. Treatment plans for these patients may include a catheter-based procedure to remove the clot, or "clot-buster" medications that break down the protein that binds blood together (NINDS Recognizes Stroke Awareness Month | National Institute of Neurological Disorders and Stroke, 2024). Although more common, some ischemic strokes appear to be "mini" and harmless; these are coined as transient ischemic attacks (TIA), which can actually serve as a life-threatening symptom for more imminent events (Friends, 2025). Thus, early detection of strokes is the biggest preventative measure, as 80% of these occurrences can be averted (May Is American Stroke Month, n.d.).',
                  style: GoogleFonts.jost(fontSize: 20),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 900,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF0A1F44), width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
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
                      style: GoogleFonts.jost(fontSize: 20),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 1200,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF0A1F44), width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Despite growing stroke education initiatives, significant gaps remain in current treatment approaches. In the current healthcare system, the average patient must first book an appointment at a local hospital, then get referred to a specialist for brain imaging, wait for approval and an assigned date, and finally either have the results interpreted for future treatment plans or get referred for second and third opinions, in a seemingly never-ending loop (Healthwatch, 2023). Even this proposed path, as further supported by Figure 2, is the optimal case at best. In reality, doctors are in high demand, making it hard to get in contact with a trusted provider in the first place. Additionally, for many, consulting multiple specialists may not be an option, especially for those in resource-limited areas or with financial constraints.',
                  style: GoogleFonts.jost(fontSize: 20),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 900,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF0A1F44), width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
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
                      style: GoogleFonts.jost(fontSize: 20),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 1200,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF0A1F44), width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  'It is this very cycle that jeopardizes patient health. For a condition in which every second counts, this lengthy process actively diminishes an individual\'s chance of a full recovery. In fact, in 2021, the American Stroke Association conducted a study to determine the effects of delayed treatment on the lifespan of severe stroke patients. The study, conducted around 406 individuals with life-threatening artery blockages, revealed that each 10-minute delay in treatment resulted in a loss of eleven months of healthy life (Even Short Delays in the ER May Reduce the Lifespan of Stroke Survivors, n.d.). Thus, rapid detection is vital to stroke recovery.',
                  style: GoogleFonts.jost(fontSize: 20),
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
