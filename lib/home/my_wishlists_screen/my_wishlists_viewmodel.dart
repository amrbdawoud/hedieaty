import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/home/data/wishlists/models/wishlist.dart';
import 'package:hedieaty/home/data/wishlists/wishlists_fs_manager.dart';
import 'package:hedieaty/onboarding/managers/user_session_manager.dart';

class MyWishlistViewModel extends ChangeNotifier {
  final WishlistFirestoreManager _wishlistsFSManager = WishlistFirestoreManager();
  late Stream<List<Wishlist>> _wishlistsStream;
  List<Wishlist> _wishlists = [];

  List<Wishlist> get wishlists => _wishlists;

  MyWishlistViewModel() {
    // Listen to real-time updates for the user's wishlists
    _configure();
  }

  Future<void> _configure() async {
    User? user = await UserSessionManager.instance.getCurrentUser();
    _wishlistsStream = _wishlistsFSManager.getUserWishlists(user!.uid);
    _wishlistsStream.listen((newWishlists) {
      _wishlists = newWishlists;
      notifyListeners(); // Notify listeners (UI) to update
    });
  }
}