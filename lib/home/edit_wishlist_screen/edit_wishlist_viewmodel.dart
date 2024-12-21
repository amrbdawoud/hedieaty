import 'dart:convert';
import 'dart:io';

import 'package:hedieaty/home/data/wishlists/models/gift.dart';
import 'package:hedieaty/home/data/wishlists/models/wishlist.dart';
import 'package:hedieaty/home/data/wishlists/wishlists_fs_manager.dart';
import 'package:image_picker/image_picker.dart';

class EditWishlistViewModel {
  final WishlistFirestoreManager firestoreManager = WishlistFirestoreManager();
  final ImagePicker _picker = ImagePicker();

  // Function to pick and encode image
  Future<String?> pickAndEncodeImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await File(pickedFile.path).readAsBytes();
        return base64Encode(bytes);
      }
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
    return null;
  }

  // Function to update the wishlist in Firestore
  Future<void> updateWishlist(String wishlistId, Wishlist wishlist) async {
    if (wishlist.name.isEmpty || wishlist.gifts.isEmpty) {
      throw Exception('Wishlist name and at least one gift are required.');
    }
    await firestoreManager.updateWishlist(wishlistId, wishlist);
  }
}