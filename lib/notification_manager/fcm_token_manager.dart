import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmTokenManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Firestore collection name for storing device tokens
  static const String tokensCollection = "device_tokens";

  /// Registers the device's FCM token to Firestore in an array under a specific user ID
  Future<void> registerToken(String userId) async {
    try {
      // Get the current device token
      String? deviceToken = await _firebaseMessaging.getToken();
      if (deviceToken == null) {
        print("FCM token is null");
        return;
      }

      // Reference to the user's document in Firestore
      DocumentReference userDocRef =
          _firestore.collection(tokensCollection).doc(userId);

      // Update or add the token to the array
      await userDocRef.set({
        "tokens": FieldValue.arrayUnion([deviceToken]),
        "updatedAt": FieldValue.serverTimestamp(),
        "platform": "android", // Change this based on the platform (e.g., iOS)
      }, SetOptions(merge: true));

      print("Token registered successfully for user: $userId");
    } catch (e) {
      print("Error registering FCM token: $e");
    }
  }

  /// Retrieves all tokens for a specific user ID
  Future<List<String>> retrieveTokens(String userId) async {
    try {
      DocumentSnapshot userDocSnapshot =
          await _firestore.collection(tokensCollection).doc(userId).get();

      if (userDocSnapshot.exists) {
        // Extract tokens array from the document
        List<dynamic>? tokens = (userDocSnapshot)["tokens"] as List<dynamic>?;
        return tokens?.map((token) => token as String).toList() ?? [];
      } else {
        print("No tokens found for user: $userId");
        return [];
      }
    } catch (e) {
      print("Error retrieving tokens: $e");
      return [];
    }
  }

  /// Deletes a specific token for a user ID
  Future<void> delete(String userId) async {
    try {
      DocumentReference userDocRef =
          _firestore.collection(tokensCollection).doc(userId);

      // Remove the token from the array
      await userDocRef.delete();

      print("Token deleted successfully for user: $userId");
    } catch (e) {
      print("Error deleting FCM token: $e");
    }
  }
}
