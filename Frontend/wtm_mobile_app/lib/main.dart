import 'package:flutter/material.dart';
import 'package:wtm_mobile_app/constants/global_variables.dart';
import 'package:wtm_mobile_app/features/auth/screens/login_screen.dart';
import 'package:wtm_mobile_app/features/auth/screens/register_screen.dart';
import 'package:wtm_mobile_app/features/auth/screens/concerts_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whats The Move',
      theme: ThemeData(
        // Your theme data
      ),
      routes: {
        '/': (context) => HomeScreen(), // Set your home screen as the initial route
        AuthScreen.routeName: (context) => AuthScreen(),
        // Add more routes for your other screens
        '/home': (context) => ConcertsScreen(),


      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whats The Move'),
      ),
      body: Column(
        children: [
          const Center(
            // Your center widget content
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AuthScreen.routeName);
            },
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the registration screen
            },
            child: const Text('Register'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, ConcertsScreen.routeName); // Navigate to the home screen
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }
}
