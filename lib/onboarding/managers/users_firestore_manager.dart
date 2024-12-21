import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../home/home_screen/home_viewmodel.dart';

class UsersFirestoreManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save or update user data in Firestore
  Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
    try {
      Map<String, dynamic> userData1 = userData;
      userData1.addAll({"friends": []});

      await _firestore.collection('users').doc(uid).set(userData1, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Failed to save user data: $e");
    }
  }

  // Fetch user data from Firestore
  Future<DocumentSnapshot> getUserData(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      throw Exception("Failed to fetch user data: $e");
    }
  }

  // Delete user data from Firestore
  Future<void> deleteUserData(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      throw Exception("Failed to delete user data: $e");
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(String uid, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(uid).update(userData);
    } catch (e) {
      throw Exception("Failed to update user data: $e");
    }
  }

  Future<DocumentSnapshot?> searchUserByPhoneNumber(String phoneNumber) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }
      return null; // No user found
    } catch (e) {
      throw Exception("Failed to search for user by phone number: $e");
    }
  }

  Future<List<String>> fetchUserFriendIds(String userId) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userId).get();
      final data = snapshot.data();
      return List<String>.from(data?['friends'] ?? []);
    } catch (e) {
      throw Exception('Failed to fetch user friend IDs: $e');
    }
  }

  /// Fetch friends and attach the count of their associated events
  Future<List<Friend>> fetchFriendsWithUpcomingEvents(String userId) async {
    try {
      // Step 1: Fetch friend IDs
      final friendIds = await fetchUserFriendIds(userId);

      if (friendIds.isEmpty) return [];

      // Step 2: Fetch friend details
      final friendsSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: friendIds)
          .get();

      final friends = friendsSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['fullName'],
        };
      }).toList();

      // Step 3: Fetch events for each friend and filter upcoming events
      final List<Friend> friendsWithUpcomingEvents = [];

      for (final friend in friends) {
        final eventsSnapshot = await _firestore
            .collection('events')
            .where('userId', isEqualTo: friend['id'])
            .get();

        final List<Map<String, dynamic>> upcomingEvents = eventsSnapshot.docs
            .where((doc) {
          final eventDate = DateTime.parse(doc['date']);
          final currentDate = DateTime.now();
          return eventDate.isAfter(currentDate);  // Filter for upcoming events
        })
            .map((doc) {
          return {
            'id': doc.id,
            'name': doc['name'],
            'date': doc['date'],
            'category': doc['category'],
          };
        }).toList();

        friendsWithUpcomingEvents.add(
          Friend(
            id: friend['id'],
            name: friend['name'],
            upcomingEvents: upcomingEvents,  // Attach the upcoming events
          ),
        );
      }

      return friendsWithUpcomingEvents;
    } catch (e) {
      throw Exception('Failed to fetch friends with upcoming events: $e');
    }
  }
}