import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  const _NavLink({required this.label, required this.path, required this.currentPath}); 

  // need to figure out hover at some point

  @override
  Widget build(BuildContext context) {                      
    final isActive = currentPath == path;                     

    return GestureDetector(
      onTap: () => context.go(path),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,                              
            fontSize: 15,
          ),
        ),
      ),
    );                                                      
  }
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
    child: SafeArea(
      child: NavBar(currentPath: '/'),
    ),
  ),
),

      body: SingleChildScrollView(
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
    child: SafeArea(
      child: NavBar(currentPath: '/'),
    ),
  ),
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Feedback Page', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            const MyCustomForm(),
            const SizedBox(height: 24),
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
  final _formKey = GlobalKey<FormState>();
  String? selectedRole;
  String? selectedExperience;
  String? selectedPermission;
  String answer1 = '';
  String answer2 = '';

  final List<String> roleItems = ['Medical Professional', 'Researcher', 'Patient', 'Student', 'Other'];
  final List<String> aspectToComment = ['Analysis', 'Home Page', 'Contact Us', 'Overall Experience'];
  final List<String> permissionGranted = ['Yes, I give consent to use my feedback to help improve the app', 'No, I do not give consent to use my feedback'];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DropdownButtonFormField<String>(
            value: selectedRole,
            decoration: const InputDecoration(
              labelText: 'Your role',
              border: OutlineInputBorder(),
            ),
            hint: const Text('Select a role'),
            items: roleItems
                .map((value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedRole = newValue;
              });
            },
            validator: (value) => value == null ? 'Please choose a role' : null,
          ),

          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedExperience,
            decoration: const InputDecoration(
              labelText: 'Area of feedback',
              border: OutlineInputBorder(),
            ),
            hint: const Text('Area of app you want to comment on'),
            items: aspectToComment
                .map((value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedExperience = newValue;
              });
            },
            validator: (value) => value == null ? 'Please select experience' : null,
          ),

          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedPermission,
            decoration: const InputDecoration(
              labelText: 'Permission to use feedback',
              border: OutlineInputBorder(),
            ),
            hint: const Text('Select permission option'),
            items: permissionGranted
                .map((value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedPermission = newValue;
              });
            },
            validator: (value) => value == null ? 'Please select permission' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'How was your experience?',
              hintText: 'Type here...',
            ),
            maxLines: 3,
            onChanged: (value) => answer1 = value,
            validator: (value) => value == null || value.trim().isEmpty ? 'Required field' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Additional comments',
              hintText: 'Type here...',
            ),
            maxLines: 3,
            onChanged: (value) => answer2 = value,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                debugPrint('Form submitted: role=$selectedRole experience=$selectedExperience permission=$selectedPermission answer1=$answer1 answer2=$answer2');
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

