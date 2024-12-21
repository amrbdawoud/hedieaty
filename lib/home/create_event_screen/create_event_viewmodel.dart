import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/onboarding/managers/user_session_manager.dart';
import 'package:uuid/uuid.dart';

import '../data/events/events_fs_manager.dart';
import '../data/events/models/event.dart';

class EventViewModel {
  final EventsFirestoreManager _eventsFirestoreManager = EventsFirestoreManager();

  Future<void> createEvent({
    required String name,
    required String date,
    required String category,
  }) async {
    try {
      final User? user = await UserSessionManager.instance.getCurrentUser();

      if (user == null) {
        throw Exception("User not logged in");
      }

      final String eventId = const Uuid().v4(); // Generate a unique ID for the event
      final Event event = Event(
        id: eventId,
        name: name,
        date: date,
        category: category,
        userId: user.uid,
      );

      await _eventsFirestoreManager.addEvent(event);
    } catch (e) {
      throw Exception("Failed to create event: $e");
    }
  }
}