import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/event.dart';

class EventsFirestoreManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEvent(Event event) async {
    try {
      await _firestore.collection('events').doc(event.id).set(event.toMap());
    } catch (e) {
      throw Exception("Failed to add event: $e");
    }
  }

  Stream<List<Event>> fetchUserEvents(String userId) {
    try {
      // Use a snapshot listener to observe real-time changes
      return _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        // Convert snapshot to List<Event>
        return snapshot.docs
            .map((doc) => Event.fromDocument(doc))
            .toList();
      });
    } catch (e) {
      throw Exception("Failed to fetch events: $e");
    }
  }


  // Delete an event from Firestore
  Future<void> deleteEvent(String eventId) async {
    try {
      // Delete the event document by ID
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception("Failed to delete event: $e");
    }
  }
}