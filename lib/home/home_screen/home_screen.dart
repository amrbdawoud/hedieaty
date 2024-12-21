import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../add_friend_screen/add_friend_screen.dart';
import '../create_event_screen/create_event_screen.dart';
import '../create_wishlist_screen/create_wishlist_screen.dart';
import '../friend_details/friend_details_screen.dart';
import 'home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: viewModel.isSearching
                  ? TextField(
                      controller: viewModel.searchController,
                      autofocus: true,
                      onChanged: viewModel.updateSearchResults,
                      decoration: const InputDecoration(
                        hintText: 'Search friend gifts...',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                    )
                  : const Text('Home', style: TextStyle(color: Colors.white)),
              actions: [
                IconButton(
                  icon: Icon(
                    viewModel.isSearching ? Icons.close : Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: viewModel.toggleSearchMode,
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Theme.of(context).primaryColor.withOpacity(0.1)
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    if (viewModel.isLoading)
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (viewModel.isSearching)
                      Expanded(
                        child: ListView.builder(
                          itemCount: viewModel.searched_results.length,
                          itemBuilder: (context, index) {
                            final friend = viewModel.filteredFriends[index];
                            return ListTile(
                              leading: const Icon(Icons.card_giftcard),
                              title: Text(friend.name),
                              subtitle: Text(
                                'Upcoming events: ${friend.upcomingEvents.length}',
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FriendDetailsScreen(
                                        friendId: friend.id),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    else
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 12.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _buildBigButton(
                                      context,
                                      icon: Icons.event,
                                      label: 'Add Event',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CreateEventScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    _buildBigButton(
                                      context,
                                      icon: Icons.card_giftcard,
                                      label: 'Add Wishlist',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CreateNewWishlistScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    _buildBigButton(
                                      context,
                                      icon: Icons.person_add,
                                      label: 'Add Friend',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AddFriendScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final friend =
                                      viewModel.filteredFriends[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: const Icon(Icons.person,
                                            color: Colors.white),
                                      ),
                                      title: Text(
                                        friend.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        'Upcoming events: ${friend.upcomingEvents.length}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      trailing: Icon(
                                        Icons.chevron_right,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FriendDetailsScreen(
                                                    friendId: friend.id),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                childCount: viewModel.filteredFriends.length,
                              ),
                            ),
                          ],
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

  Widget _buildBigButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
