import 'package:flutter/material.dart';

import '../data/events/events_fs_manager.dart';
import '../data/events/models/event.dart';

class EditEventViewModel extends ChangeNotifier {
  final EventsFirestoreManager _eventsFirestoreManager = EventsFirestoreManager();

  // Error handling
  String _error = '';
  String get error => _error;

  // Update an existing event
  Future<void> updateEvent(Event event) async {
    try {
      await _eventsFirestoreManager.addEvent(event);  // reuse addEvent function for updating
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update event: $e';
      notifyListeners();
    }
  }
}