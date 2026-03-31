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
      body: Center(
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
    child: SafeArea(
      child: NavBar(currentPath: '/'),
    ),
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
  final List<String> items = ['Medical Professional', 'Researcher', 'Patient', 'Student', 'Other'];

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
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
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

