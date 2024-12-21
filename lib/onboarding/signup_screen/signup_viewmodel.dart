import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../managers/user_session_manager.dart';

class SignUpViewModel extends ChangeNotifier {
  bool _isLoading = false; // Track the loading state privately
  bool get isLoading => _isLoading; // Public getter to expose the loading state

  // This function sets the loading state and notifies listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Sign-up function to create a user and store data in Firestore
  Future<void> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      _setLoading(true); // Start loading

      // Delay to simulate loading, can be removed in production
      await Future.delayed(Duration(seconds: 2));

      // Sign up the user with the email and password
      var user = await UserSessionManager.instance.signUpWithEmailPassword(
        email,
        password,
        {
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      // Check if user was created successfully and proceed
      if (user != null) {
        // If the user is signed up, the user data is already saved in Firestore
        // through the `signUpWithEmailPassword` method in UserSessionManager
      } else {
        throw Exception("Failed to create user.");
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    } finally {
      _setLoading(false); // End loading after the request
    }
  }
}