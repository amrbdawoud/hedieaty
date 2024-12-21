import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hedieaty/home/data/wishlists/models/gift.dart';
import 'package:hedieaty/home/data/wishlists/models/wishlist.dart';
import 'package:hedieaty/home/data/wishlists/wishlists_fs_manager.dart';
import 'package:uuid/uuid.dart';
import 'edit_wishlist_viewmodel.dart';

class EditWishlistScreen extends StatefulWidget {
  final Wishlist wishlist;
  const EditWishlistScreen({super.key, required this.wishlist});
  @override
  _EditWishlistScreenState createState() => _EditWishlistScreenState();
}

class _EditWishlistScreenState extends State<EditWishlistScreen> {
  final _wishlistNameController = TextEditingController();
  final _giftControllers = <GiftController>[];
  final ImagePicker _picker = ImagePicker();
  final List<String> categories = [
    'Electronics',
    'Books',
    'Toys',
    'Clothing',
    'Home Decor',
    'Sports',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _wishlistNameController.text = widget.wishlist.name;
    for (var gift in widget.wishlist.gifts) {
      _giftControllers.add(GiftController.fromGift(gift));
    }
  }

  void _addGift() {
    setState(() {
      _giftControllers.add(GiftController());
    });
  }

  void _removeGift(int index) {
    setState(() {
      _giftControllers.removeAt(index);
    });
  }

  Widget _buildGiftForm(int index) {
    final giftController = _giftControllers[index];

    return Card(
      elevation: 3,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gift ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                if (_giftControllers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () => _removeGift(index),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: giftController.nameController,
                  decoration: InputDecoration(
                    labelText: 'Gift Name',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      final bytes = await File(pickedFile.path).readAsBytes();
                      setState(() {
                        giftController.imageBase64 = base64Encode(bytes);
                      });
                    }
                  },
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: giftController.imageBase64 == null
                        ? Center(
                      child: Text(
                        'Tap to upload image',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        base64Decode(giftController.imageBase64!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: giftController.descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Gift Description',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: giftController.priceController,
                  decoration: InputDecoration(
                    labelText: 'Gift Price',
                    prefixText: '\$',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: giftController.selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Gift Category',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      giftController.selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateWishlist() {
    final wishlistName = _wishlistNameController.text;

    if (wishlistName.isEmpty || _giftControllers.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Error',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('Please provide a wishlist name and at least one gift.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      );
      return;
    }

    final gifts = _giftControllers.map((controller) {
      return Gift(
        id: const Uuid().v4(),
        name: controller.nameController.text,
        description: controller.descriptionController.text,
        price: int.tryParse(controller.priceController.text) ?? 0,
        category: controller.selectedCategory,
        imageBase64: controller.imageBase64,
      );
    }).toList();

    final updatedWishlist = Wishlist(
      id: const Uuid().v4(),
      userId: widget.wishlist.userId,
      name: wishlistName,
      gifts: gifts,
    );

    final viewModel = EditWishlistViewModel();
    viewModel.updateWishlist(widget.wishlist.id, updatedWishlist);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Wishlist Updated Successfully!'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Edit Wishlist', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Theme.of(context).primaryColor.withOpacity(0.1)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _wishlistNameController,
                decoration: InputDecoration(
                  labelText: 'Wishlist Name',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Edit Gifts in Wishlist',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < _giftControllers.length; i++) _buildGiftForm(i),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _addGift,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add New Gift',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _updateWishlist,
                child: const Text(
                  'Update Wishlist',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class GiftController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  String? imageBase64;
  String selectedCategory = 'Electronics';

  GiftController();

  GiftController.fromGift(Gift gift) {
    nameController.text = gift.name;
    descriptionController.text = gift.description;
    priceController.text = gift.price.toString();
    imageBase64 = gift.imageBase64;
    selectedCategory = gift.category;
  }
}