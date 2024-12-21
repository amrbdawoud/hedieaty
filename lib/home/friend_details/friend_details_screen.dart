import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/home/friend_details/wishlist_screen/wishlist_screen.dart';
import 'package:provider/provider.dart';
import '../data/wishlists/models/wishlist.dart';
import '../data/wishlists/wishlists_fs_manager.dart';
import 'friend_details_viewmodel.dart';

class FriendDetailsScreen extends StatelessWidget {
  final String friendId;

  const FriendDetailsScreen({super.key, required this.friendId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FriendDetailsViewModel(friendId: friendId)..loadFriendDetails(),
      child: Consumer<FriendDetailsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: const Text('Friend Details', style: TextStyle(color: Colors.white)),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Theme.of(context).primaryColor.withOpacity(0.1)],
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                viewModel.friendName,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
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
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(Icons.person, size: 40, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              viewModel.friendName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            Wishlist wishlist = viewModel.wishlists[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WishlistScreen(wishlistId: wishlist.id),
                                ),
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                shadowColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            Theme.of(context).colorScheme.secondary,
                                          ],
                                        ),
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.card_giftcard,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              wishlist.name,
                                              style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              '${wishlist.gifts.length} Items',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.secondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: viewModel.wishlists.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}