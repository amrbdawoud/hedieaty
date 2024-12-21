import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hedieaty/home/data/wishlists/models/wishlist.dart';
import '../create_wishlist_screen/create_wishlist_screen.dart';
import '../edit_wishlist_screen/edit_wishlist_screen.dart';
import 'my_wishlists_viewmodel.dart';

class MyWishlistScreen extends StatelessWidget {
  const MyWishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyWishlistViewModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'My Wishlist',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Theme.of(context).primaryColor.withOpacity(0.1),
              ],
            ),
          ),
          child: SafeArea(
            child: Consumer<MyWishlistViewModel>(
              builder: (context, viewModel, child) {
                final wishlists = viewModel.wishlists;

                return wishlists.isEmpty
                    ? Center(
                  child: Text(
                    'No wishlists available',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                )
                    : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final wishlist = wishlists[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditWishlistScreen(
                                        wishlist: wishlist),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                shadowColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.2),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ],
                                        ),
                                        borderRadius:
                                        const BorderRadius.vertical(
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
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              wishlist.name,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              '${wishlist.gifts.length} Items',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
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
                          childCount: wishlists.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateNewWishlistScreen(),
              ),
            );
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
          tooltip: 'Add New Wishlist',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}