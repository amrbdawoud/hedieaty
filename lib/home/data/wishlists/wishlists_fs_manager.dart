import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/onboarding/managers/user_session_manager.dart';

import 'models/gift.dart';
import 'models/wishlist.dart';

class WishlistFirestoreManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Fetch all wishlists for a user
  Stream<List<Wishlist>> getUserWishlists(String userId) {
    return _firestore
        .collection('wishlists')
        .where('userId', isEqualTo: userId)  // Query by user ID
        .snapshots() // Real-time updates
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Wishlist.fromDocument(doc);
      }).toList();
    });
  }

  Future<void> addWishlist(Wishlist wishlist) async {
    try {
      Map<String, dynamic> map = wishlist.toMap();
      User? user = await UserSessionManager.instance.getCurrentUser();
      map.addAll({"userId": user!.uid});
      await _firestore.collection('wishlists').doc(wishlist.id).set(map);
    } catch (e) {
      throw Exception("Failed to add event: $e");
    }
  }


  // Function to update the wishlist in Firestore (including gifts)
  Future<void> updateWishlist(String wishlistId, Wishlist updatedWishlist) async {
    try {
      final wishlistRef = _firestore.collection('wishlists').doc(wishlistId);

      // Update the entire wishlist document, including its gifts
      await wishlistRef.update(updatedWishlist.toMap());
    } catch (e) {
      throw Exception('Failed to update wishlist: $e');
    }
  }

  // Function to fetch a wishlist by ID
  Future<Wishlist?> getWishlistById(String wishlistId) async {
    try {
      final wishlistDoc = await _firestore.collection('wishlists').doc(wishlistId).get();
      if (wishlistDoc.exists) {
        return Wishlist.fromDocument(wishlistDoc);
      }
      return null;  // Return null if wishlist doesn't exist
    } catch (e) {
      throw Exception('Failed to fetch wishlist: $e');
    }
  }

  // Function to add a new gift to an existing wishlist
  Future<void> addGiftToWishlist(String wishlistId, Gift newGift) async {
    try {
      final wishlistRef = _firestore.collection('wishlists').doc(wishlistId);

      // Get the current wishlist data
      final wishlistDoc = await wishlistRef.get();
      if (wishlistDoc.exists) {
        Wishlist wishlist = Wishlist.fromDocument(wishlistDoc);

        // Add the new gift to the wishlist's gift list
        wishlist.gifts.add(newGift);

        // Update the wishlist document with the new list of gifts
        await wishlistRef.update(wishlist.toMap());
      }
    } catch (e) {
      throw Exception('Failed to add gift to wishlist: $e');
    }
  }

  // Function to update a specific gift within a wishlist
  Future<void> updateGiftInWishlist(String wishlistId, int giftIndex, Gift updatedGift) async {
    try {
      final wishlistRef = _firestore.collection('wishlists').doc(wishlistId);

      // Get the current wishlist data
      final wishlistDoc = await wishlistRef.get();
      if (wishlistDoc.exists) {
        Wishlist wishlist = Wishlist.fromDocument(wishlistDoc);

        // Replace the gift at the specified index
        wishlist.gifts[giftIndex] = updatedGift;

        // Update the wishlist document with the modified gift list
        await wishlistRef.update(wishlist.toMap());
      }
    } catch (e) {
      throw Exception('Failed to update gift in wishlist: $e');
    }
  }

  Future<List<Gift>> fetchPledgedGifts(String userId) async {
    try {
      // Query all wishlists from Firestore
      final querySnapshot = await _firestore.collection('wishlists').get();

      // Parse wishlists and filter pledged gifts
      List<Gift> pledgedGifts = [];
      for (var doc in querySnapshot.docs) {
        Wishlist wishlist = Wishlist.fromDocument(doc);

        // Check each gift in the wishlist
        for (Gift gift in wishlist.gifts) {
          if (gift.pledgedUserId == userId) {
            pledgedGifts.add(gift);
          }
        }
      }

      return pledgedGifts;
    } catch (e) {
      throw Exception('Failed to fetch pledged gifts: $e');
    }
  }

  // Function to remove the pledge for a gift
  Future<void> removePledgeFromGift(String giftId) async {
    try {
      // Query all wishlists from Firestore
      final querySnapshot = await _firestore.collection('wishlists').get();

      // Iterate over each wishlist to find the gift by ID
      for (var doc in querySnapshot.docs) {
        Wishlist wishlist = Wishlist.fromDocument(doc);

        // Find the gift and remove the pledge
        for (Gift gift in wishlist.gifts) {
          if (gift.id == giftId) {
            gift.pledgedUserId = null; // Remove the user ID
            gift.eventId = null; // Remove the event ID if applicable

            // Update the wishlist document
            await _firestore.collection('wishlists').doc(wishlist.id).update(wishlist.toMap());
            return;
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to remove pledge from gift: $e');
    }
  }

// Function to update the state of a gift, given only the giftId
  Future<void> updateGiftState(String giftId, GiftState newState) async {
    try {
      // Query all wishlists from Firestore
      final querySnapshot = await _firestore.collection('wishlists').get();

      // Iterate over each wishlist to find the gift by ID
      for (var doc in querySnapshot.docs) {
        Wishlist wishlist = Wishlist.fromDocument(doc);

        // Find the gift and update its state
        for (Gift gift in wishlist.gifts) {
          if (gift.id == giftId) {
            gift.state = newState; // Update the gift state

            // Update the wishlist document
            await _firestore.collection('wishlists').doc(wishlist.id).update(wishlist.toMap());
            return;
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to update gift state: $e');
    }
  }
}