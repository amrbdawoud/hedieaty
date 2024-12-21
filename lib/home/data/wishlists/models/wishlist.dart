import 'package:cloud_firestore/cloud_firestore.dart';
import 'gift.dart';

class Wishlist {
  final String id;  // Adding the id field for Firestore document ID
  final String userId;
  final String name;
  final List<Gift> gifts;

  Wishlist({
    required this.id,
    required this.userId,
    required this.name,
    required this.gifts,
  });

  // Convert Wishlist object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gifts': gifts.map((gift) => gift.toMap()).toList(),
    };
  }

  // Create a Wishlist object from a Firestore document
  factory Wishlist.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Wishlist(
      id: doc.id,  // Firestore assigns the document ID automatically
      userId: data['userId'],
      name: data['name'],
      gifts: (data['gifts'] as List)
          .map((giftMap) => Gift.fromMap(giftMap))
          .toList(),
    );
  }
}