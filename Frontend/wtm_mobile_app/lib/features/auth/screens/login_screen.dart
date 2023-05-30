import 'package:flutter/material.dart';
import 'package:wtm_mobile_app/constants/global_variables.dart';
//import http
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wtm_mobile_app/features/auth/screens/concerts_page.dart';

class AuthScreen extends StatefulWidget{
  static const String routeName = '/login';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<void> login() async {
    // Validate email
    String email = emailController.text.trim();
    if (!_isEmailValid(email)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Email'),
            content: Text('Please enter a valid email address.'),
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
      return;
    }

    // Send user information to API
    String password = passwordController.text.trim();
    try {
      final response = await http.post(
    Uri.parse('http://10.0.2.2:5053/api/login'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
    },
    body: jsonEncode({'email': email, 'password': password}), // Convert body to JSON string
  );
      if (response.statusCode == 200) {
        // Successful login
        String userId = response.body; // Assuming the API returns the user ID
        // Save the user ID in session storage or any other persistent storage method
      
        // Redirect the user to the home screen
        Navigator.pushReplacementNamed(context, ConcertsScreen.routeName);
      } else {
        // Unsuccessful login
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid email or password. Please try again. Response code: ${response.statusCode} ${response.reasonPhrase}'),
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
    } catch (error, stackTrace) {
    print("Error message : $error \nStack trace : $stackTrace");
      showDialog(
        
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text("Error message : $error \nStack trace : $stackTrace"),
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

  bool _isEmailValid(String email) {
    //check if email is valid and not empty
    if (email.isEmpty) {
      return false;
    }else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return false;
    }
    return true;
  }



  //////////////////////////////PAGE LAYOUT/////////////////////////////////////
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                login();

               
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
}
}

