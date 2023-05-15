import 'package:flutter/material.dart';
import 'package:wtm_mobile_app/constants/global_variables.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whats The Move',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 42, 40, 40),
        colorScheme: const ColorScheme.dark(
          primary:Color.fromARGB(255, 195, 50, 50),
          secondary: Color.fromARGB(255, 233, 59, 59),
        ), 
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 255, 36, 36),
          ),
        ),
      ),
      home:  Scaffold(
        appBar: AppBar(
          title: const Text('Whats The Move'),
        ),
          body: Column(
            children:[
              const Center(
                
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Login'),
                
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Register'),
              ),
     
            ]
      )),
    );
  }
}
