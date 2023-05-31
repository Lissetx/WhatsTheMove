import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? userId;
  String? token;

  void setUser(String userId, String token) {
    this.userId = userId;
    this.token = token;
    notifyListeners();
  }

  void clearUser() {
    this.userId = null;
    this.token = null;
    notifyListeners();
  }



  

  void logout() {
    userId = null;
    token = null;
    notifyListeners();
  }
}
