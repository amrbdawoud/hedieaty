import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/home/data/wishlists/wishlists_fs_manager.dart';
import 'package:hedieaty/onboarding/managers/user_session_manager.dart';
import '../data/wishlists/models/gift.dart';

class MyPledgedGiftsScreen extends StatefulWidget {
  const MyPledgedGiftsScreen({super.key});

  @override
  State<MyPledgedGiftsScreen> createState() => _MyPledgedGiftsScreenState();
}

class _MyPledgedGiftsScreenState extends State<MyPledgedGiftsScreen> {
  final WishlistFirestoreManager _repository = WishlistFirestoreManager();
  List<Gift> pledgedGifts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPledgedGifts();
  }

  Future<void> _loadPledgedGifts() async {
    try {
      User? user = await UserSessionManager.instance.getCurrentUser();
      final gifts = await _repository.fetchPledgedGifts(user!.uid);
      setState(() {
        pledgedGifts = gifts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading pledged gifts: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _removePledge(Gift gift) async {
    try {
      User? user = await UserSessionManager.instance.getCurrentUser();
      await _repository.removePledgeFromGift(gift.id);
      setState(() {
        pledgedGifts.remove(gift);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pledge removed successfully.'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing pledge: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _markAsPurchased(Gift gift) async {
    try {
      await _repository.updateGiftState(gift.id, GiftState.purchased);
      setState(() {
        gift.state = GiftState.purchased;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gift marked as purchased.'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating gift state: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _showGiftOptions(BuildContext context, Gift gift) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Theme.of(context).primaryColor.withOpacity(0.1)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.cancel, color: Theme.of(context).primaryColor),
                title: Text(
                  'Remove Pledge',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _removePledge(gift);
                },
              ),
              ListTile(
                leading: Icon(Icons.check, color: Theme.of(context).primaryColor),
                title: Text(
                  'Mark as Purchased',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _markAsPurchased(gift);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('My Pledged Gifts', style: TextStyle(color: Colors.white)),
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
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        )
            : pledgedGifts.isEmpty
            ? Center(
          child: Text(
            'No pledged gifts yet!',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
          ),
        )
            : ListView.builder(
          itemCount: pledgedGifts.length,
          itemBuilder: (context, index) {
            final gift = pledgedGifts[index];
            Color stateColor;
            String stateLabel;

            switch (gift.state) {
              case GiftState.available:
                stateColor = Theme.of(context).primaryColor;
                stateLabel = 'Available';
                break;
              case GiftState.pledged:
                stateColor = Theme.of(context).colorScheme.secondary;
                stateLabel = 'Pledged';
                break;
              case GiftState.purchased:
                stateColor = Theme.of(context).colorScheme.error;
                stateLabel = 'Purchased';
                break;
            }

            return GestureDetector(
              onTap: () => _showGiftOptions(context, gift),
              child: Card(
                elevation: 3,
                shadowColor: Theme.of(context).primaryColor.withOpacity(0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        stateColor.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gift.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${gift.price}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Description: ${gift.description}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.card_giftcard,
                              size: 32,
                              color: stateColor,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              stateLabel,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: stateColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}