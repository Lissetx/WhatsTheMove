import 'package:flutter/material.dart';
class GlobalVariables{
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 235, 63, 60),
      Color.fromARGB(255, 159, 15, 15),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const backgroundColor = Color.fromARGB(255, 123, 123, 123);
}

class ApiConstants{
  static String baseurl = "http://localhost:5053/api";
  static String login = "/login";
  static String register = "/register";
  static String verify = "/verify";
  static String concerts = "/concerts";
  static String interestred = "/concerts/interested/";
  //get concerts/interested/{id}
  static String uninterested = "/concerts/uninterested/";

  static String userId ="";
}



