import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart'; // Import your login screen file
import 'features/auth/screens/register_screen.dart'; // Import your register screen file
import 'features/auth/screens/concerts_page.dart'; // Import your verify screen file
import 'features/auth/screens/interested_page.dart'; // Import your verify screen file

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/login':
      return MaterialPageRoute(builder: (context) => const AuthScreen());
    case '/home':
      return MaterialPageRoute(builder: (context) => const ConcertsScreen());
    case '/register':
      return MaterialPageRoute(builder: (context) => const RegisterScreen());
    case '/interested':
      return MaterialPageRoute(builder: (context) => const InterestedScreen());
    default:
      return MaterialPageRoute(builder: (context) => const AuthScreen());
  }
}
