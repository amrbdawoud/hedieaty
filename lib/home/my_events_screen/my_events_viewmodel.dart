import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../onboarding/managers/user_session_manager.dart';
import '../data/events/events_fs_manager.dart';
import '../data/events/models/event.dart';

class MyEventViewModel extends ChangeNotifier {
  final EventsFirestoreManager _eventsManager = EventsFirestoreManager();
  late Stream<List<Event>> _eventsStream;
  List<Event> _events = [];
  String _sortBy = 'Name';

  List<Event> get events {
    _sortEvents();
    return _events;
  }

  String get sortBy => _sortBy;

  MyEventViewModel() {
    _configure();
  }

  // Setup the stream to observe events and listen for real-time updates
  Future<void> _configure() async {
    User? user = await UserSessionManager.instance.getCurrentUser();
    if (user != null) {
      _eventsStream = _eventsManager.fetchUserEvents(user.uid);
      // Listen to changes in the stream and update the events list
      _eventsStream.listen((newEvents) {
        _events = newEvents;
        notifyListeners(); // Notify UI to update when events change
      });
    }
  }

  // Sort events based on the selected option
  void sortEvents(String sortBy) {
    _sortBy = sortBy;
    notifyListeners(); // Notify UI to apply new sorting
  }

  // Helper function to sort events based on the selected option
  void _sortEvents() {
    if (_sortBy == 'Category') {
      _events.sort((a, b) => a.category.compareTo(b.category));
    } else if (_sortBy == 'Status') {
      _events.sort((a, b) => a.status.compareTo(b.status)); // Sorting by status
    } else {
      _events.sort((a, b) => a.name.compareTo(b.name)); // Sorting by name
    }
  }

  // Method to delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      // Remove event from Firestore
      await _eventsManager.deleteEvent(eventId);

      // Remove event from the local list
      _events.removeWhere((event) => event.id == eventId);

      // Notify listeners to update UI
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Failed to delete event: $e");
    }
  }

  // Expose the stream of events for the UI to listen to
  Stream<List<Event>> observeEvents() {
    return _eventsStream;
  }
}