import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/home/data/wishlists/wishlists_fs_manager.dart';
import 'package:hedieaty/home/data/wishlists/wishlists_fs_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../onboarding/managers/user_session_manager.dart';
import '../data/wishlists/models/gift.dart';
import '../data/wishlists/models/wishlist.dart';

class WishlistViewModel {
  final WishlistFirestoreManager firestoreManager = WishlistFirestoreManager();
  final ImagePicker _picker = ImagePicker();

  // Encode an image as Base64
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

  Future<void> createWishlist(String name, List<Gift> gifts) async {
    if (name.isEmpty || gifts.isEmpty) {
      throw Exception('Wishlist name and at least one gift are required.');
    }
    User? user = await UserSessionManager.instance.getCurrentUser();
    String userId = user!.uid;

    final wishlist = Wishlist(name: name, userId: userId, gifts: gifts, id: const Uuid().v4());
    await firestoreManager.addWishlist(wishlist);
  }
}