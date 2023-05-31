import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtm_mobile_app/constants/global_variables.dart';
import 'package:wtm_mobile_app/features/auth/screens/login_screen.dart';
import 'package:wtm_mobile_app/features/auth/screens/register_screen.dart';
import 'package:wtm_mobile_app/features/auth/screens/concerts_page.dart';
import 'package:wtm_mobile_app/features/auth/screens/interested_page.dart';
import 'package:wtm_mobile_app/providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Whats The Move',
        theme: ThemeData(
          // Your theme data
        ),
        routes: {
          '/': (context) => HomeScreen(), // Set your home screen as the initial route
          AuthScreen.routeName: (context) => AuthScreen(),
          // Add more routes for your other screens
          '/home': (context) => ConcertsScreen(),

          '/register': (context) => RegisterScreen(),

          '/interested': (context) => InterestedScreen(),
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    void logout() {
      if (authProvider.userId != null) {
        authProvider.clearUser();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Logged Out'),
              content: Text('You have been successfully logged out.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

       return Scaffold(
      appBar: AppBar(
        title: const Text('Whats The Move'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AuthScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RegisterScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, ConcertsScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
              child: const Text(
                'Skip',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: logout,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}