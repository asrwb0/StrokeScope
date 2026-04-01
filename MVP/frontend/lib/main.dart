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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            const Text('Home Page', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/analyze'),
              child: const Text('Go to Analysis'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go('/feedback'),
              child: const Text('Go to Feedback'),
            ),
          ],
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

