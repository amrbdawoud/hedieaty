import 'package:flutter/material.dart';
import 'package:hedieaty/home/data/wishlists/models/gift.dart';
import 'package:hedieaty/onboarding/managers/user_session_manager.dart';

import '../../data/wishlists/models/wishlist.dart';
import '../../data/wishlists/wishlists_fs_manager.dart';
import '../../data/events/events_fs_manager.dart';
import '../../data/events/models/event.dart';

class WishlistViewModel extends ChangeNotifier {
  final WishlistFirestoreManager _wishlistManager = WishlistFirestoreManager();
  final EventsFirestoreManager _eventsManager = EventsFirestoreManager();
  late Wishlist _wishlist;
  List<Event> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  Wishlist get wishlist => _wishlist;
  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch the wishlist for a specific wishlist ID
  Future<void> fetchWishlist(String wishlistId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _wishlist = await _wishlistManager.getWishlistById(wishlistId) ?? Wishlist(id: wishlistId, userId: "", name: "", gifts: []);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to load wishlist";
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch events for the current user
  Future<void> fetchUserEvents(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _events = await _eventsManager.fetchUserEvents(userId).first;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to fetch events";
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pledge to buy a specific gift in the wishlist
  Future<void> pledgeGift(String giftId, String eventId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await UserSessionManager.instance.getCurrentUser();
      final pledgedGift = _wishlist.gifts.firstWhere((gift) => gift.id == giftId);

      pledgedGift.state = GiftState.pledged;
      pledgedGift.pledgedUserId = user?.uid;
      pledgedGift.eventId = eventId;

      await _wishlistManager.updateGiftInWishlist(_wishlist.id, _wishlist.gifts.indexOf(pledgedGift), pledgedGift);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to pledge gift";
      _isLoading = false;
      notifyListeners();
    }
  }
}