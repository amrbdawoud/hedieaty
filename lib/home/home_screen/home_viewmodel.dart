import 'package:flutter/material.dart';
import 'package:hedieaty/onboarding/managers/user_session_manager.dart';
import 'package:hedieaty/onboarding/managers/users_firestore_manager.dart';
import 'package:hedieaty/onboarding/managers/users_firestore_manager.dart';

class Friend {
  final String id;
  final String name;
  final List<Map<String, dynamic>> upcomingEvents;

  Friend({required this.id, required this.name, required this.upcomingEvents});
}

class HomeViewModel extends ChangeNotifier {
  final UsersFirestoreManager firestoreManager = UsersFirestoreManager();

  bool _isSearching = false;
  bool _isLoading = false;
  final TextEditingController searchController = TextEditingController();

  List<Friend> _friends = [];
  List<Friend> _filteredFriends = [];
  List<Friend> searched_results = [];

  // Getters
  bool get isSearching => _isSearching;
  bool get isLoading => _isLoading;
  List<Friend> get filteredFriends => _filteredFriends;

  HomeViewModel() {
    fetchFriends();
  }

  // Toggle search mode
  void toggleSearchMode() {
    _isSearching = !_isSearching;
    if (!_isSearching) {
      searchController.clear();
      _filteredFriends = _friends; // Reset search results
    }
    notifyListeners();
  }

  // Update search results
  void updateSearchResults(String query) {
    if (query.isEmpty) {
      searched_results = [];
      return;
    }
    searched_results = _friends
        .where((friend) =>
    friend.name.toLowerCase().contains(query.toLowerCase()) ||
        friend.upcomingEvents.any(
                (event) => event["name"].toLowerCase().contains(query.toLowerCase())))
        .toList();
    notifyListeners();
  }

  // Fetch friends data from Firestore
  Future<void> fetchFriends() async {
    _isLoading = true;
    notifyListeners();

    try {

      String userId = (await UserSessionManager.instance.getCurrentUser())!.uid;
      final friendsData = await firestoreManager.fetchFriendsWithUpcomingEvents(userId);

      print(friendsData);
      _friends = friendsData;

      _filteredFriends = _friends;
    } catch (e) {
      debugPrint('Error fetching friends: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}