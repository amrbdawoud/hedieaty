import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../onboarding/managers/users_firestore_manager.dart';
class AddFriendViewModel extends ChangeNotifier {
  final UsersFirestoreManager _firestoreManager = UsersFirestoreManager();
  bool _isSearching = false;
  bool get isSearching => _isSearching;

  TextEditingController _phoneNumberController = TextEditingController();

  TextEditingController get phoneNumberController => _phoneNumberController;

  // Simulate a phone number search and add a friend
  Future<void> searchAndAddFriend(String phoneNumber, BuildContext context) async {
    try {
      _isSearching = true;
      notifyListeners();

      // Search for the user by phone number in Firestore
      final userDoc = await _firestoreManager.searchUserByPhoneNumber(phoneNumber);

      if (userDoc != null) {
        // If the user is found, add them to the current user's friends collection
        final friendId = userDoc.id; // Get the friend's document ID

        await _addFriendToCurrentUser(friendId);

        // Notify user of successful addition
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend added successfully!')),
        );

        Navigator.of(context).pop(); // Close the dialog
      } else {
        // If no user found, notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found with this phone number.')),
        );
      }
    } catch (e) {
      // Handle errors if any
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add friend: $e')),
      );
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // Add a friend to the current user's friends collection
  Future<void> _addFriendToCurrentUser(String friendId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final currentUserData = await _firestoreManager.getUserData(currentUserId);

      List<dynamic> friends = currentUserData['friends'] ?? [];
      if (!friends.contains(friendId)) {
        friends.add(friendId);
        await _firestoreManager.updateUserData(currentUserId, {'friends': friends});
      }
    } catch (e) {
      throw Exception("Failed to add friend to current user's friends list: $e");
    }
  }
}