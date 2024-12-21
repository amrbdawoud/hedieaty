import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/wishlists/models/wishlist.dart';
import '../data/wishlists/wishlists_fs_manager.dart';

class FriendDetailsViewModel extends ChangeNotifier {
  final String friendId;
  FriendDetailsViewModel({required this.friendId});

  // State variables
  String friendName = '';
  List<Wishlist> wishlists = [];
  bool isLoading = true;
  String? errorMessage;

  // Method to fetch friend details and wishlists
  Future<void> loadFriendDetails() async {
    try {
      // Fetching friend's details from Firestore (you could implement another method for fetching the friend's name)
      DocumentSnapshot friendDoc = await FirebaseFirestore.instance.collection('users').doc(friendId).get();
      if (friendDoc.exists) {
        friendName = friendDoc['fullName']; // Assuming there's a 'name' field
      } else {
        errorMessage = "Friend not found";
      }

      // Fetching the wishlists of the friend
      await _loadFriendWishlists();

      isLoading = false;
      notifyListeners(); // Notify listeners to rebuild the UI
    } catch (e) {
      errorMessage = "Failed to load data: $e";
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to load the wishlists of the friend
  Future<void> _loadFriendWishlists() async {
    try {
      wishlists = await WishlistFirestoreManager().getUserWishlists(friendId).first;
    } catch (e) {
      errorMessage = "Failed to load wishlists: $e";
    }
  }
}