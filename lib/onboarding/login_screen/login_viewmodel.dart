import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/onboarding/managers/user_session_manager.dart';

class LoginViewModel extends ChangeNotifier {
  final UserSessionManager _userSessionManager = UserSessionManager.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Call this method to sign in the user
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = ''; // Clear any previous error
    notifyListeners();

    // Delay to simulate loading, can be removed in production
    await Future.delayed(Duration(seconds: 2));

    try {
      User? user = await _userSessionManager.signInWithEmailPassword(email, password);
      if (user != null) {
        // Successfully signed in
        // You can navigate to another screen, for example:
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}