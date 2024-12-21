import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String name;
  final String date; // Keep date as a string (or you can convert it to DateTime)
  final String category;
  final String userId;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.category,
    required this.userId,
  });

  // Computed property to get the status of the event
  String get status {
    DateTime eventDate = DateTime.parse(date);
    DateTime currentDate = DateTime.now();

    // Check if the event is in the future, today, or in the past
    if (eventDate.isAfter(currentDate)) {
      return 'Upcoming';
    } else if (eventDate.year == currentDate.year &&
        eventDate.month == currentDate.month &&
        eventDate.day == currentDate.day) {
      return 'Current';
    } else {
      return 'Past';
    }
  }

  // Convert Event object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'category': category,
      'userId': userId,
    };
  }

  // Create an Event object from a Firestore document
  factory Event.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      name: data['name'],
      date: data['date'],
      category: data['category'],
      userId: data['userId'],
    );
  }
}