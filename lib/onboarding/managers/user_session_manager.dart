
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/onboarding/managers/users_firestore_manager.dart';

class UserSessionManager {
  // Private constructor to prevent external instantiation
  UserSessionManager._();

  // Static instance of the singleton class
  static final UserSessionManager _instance = UserSessionManager._();

  // Getter to access the singleton instance
  static UserSessionManager get instance => _instance;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UsersFirestoreManager _usersFirestoreManager = UsersFirestoreManager();

  // Sign in the user with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception("Failed to sign in: $e");
    }
  }

  // Sign up a new user
  Future<User?> signUpWithEmailPassword(String email, String password, Map<String, dynamic> userData) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      // Save additional user data to Firestore after signup
      if (user != null) {
        await _usersFirestoreManager.saveUserData(user.uid, userData);
      }
      return user;
    } catch (e) {
      throw Exception("Failed to sign up: $e");
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception("Failed to sign out: $e");
    }
  }

  // Check if a user is logged in
  Future<bool> isUserLoggedIn() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return user != null;
    } catch (e) {
      throw Exception("Failed to check login status: $e");
    }
  }

  // Get the current logged-in user
  Future<User?> getCurrentUser() async {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      throw Exception("Failed to get current user: $e");
    }
  }

  // Fetch the current user's data from Firestore
  Future<DocumentSnapshot> getUserDataFromFirestore() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        return await _usersFirestoreManager.getUserData(user.uid);
      } else {
        throw Exception("No user is logged in");
      }
    } catch (e) {
      throw Exception("Failed to get user data from Firestore: $e");
    }
  }

  // Update current user's data in Firestore
  Future<void> updateUserDataInFirestore(Map<String, dynamic> userData) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await _usersFirestoreManager.updateUserData(user.uid, userData);
      } else {
        throw Exception("No user is logged in");
      }
    } catch (e) {
      throw Exception("Failed to update user data in Firestore: $e");
    }
  }

  // Delete user account from both Firebase Auth and Firestore
  Future<void> deleteUserAccount() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await _usersFirestoreManager.deleteUserData(user.uid);
        await user.delete();
      } else {
        throw Exception("No user is logged in");
      }
    } catch (e) {
      throw Exception("Failed to delete user account: $e");
    }
  }
}