import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/home/edit_event_screen/edit_event_screen.dart';
import 'package:hedieaty/home/edit_event_screen/edit_event_viewmodel.dart';
import 'package:hedieaty/home/home_screen/home_screen.dart';
import 'package:hedieaty/home/my_wishlists_screen/my_wishlists_screen.dart';
import 'package:hedieaty/home/profile_screen/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:hedieaty/notification_manager/notification_manager.dart';

import 'my_events_screen/my_events_screen.dart';
import 'my_events_screen/my_events_viewmodel.dart';

class BaseTabScreen extends StatefulWidget {
  const BaseTabScreen({super.key});

  @override
  _BaseTabScreenState createState() => _BaseTabScreenState();
}

class _BaseTabScreenState extends State<BaseTabScreen> {
  // Initial index for the bottom navigation
  int _selectedIndex = 0;

  // Function to update the selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    NotificationManager.instance.configure().then((_) {
      _requestNotificationPermission();
    });
  }

  @override
  void dispose() {
    super.dispose();
    NotificationManager.instance.dispose();
  }

  void _requestNotificationPermission() async {
    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );}

  // List of pages corresponding to the bottom navigation items
  final List<Widget> _pages = [
    const HomeScreen(),
    MyEventsScreen(),
    const MyWishlistScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MyEventViewModel>(
            create: (context) => MyEventViewModel(),
          ),
        ],
        child: Scaffold(
          body: _pages[_selectedIndex], // Display page based on the selected index
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex, // Current selected index
            onDestinationSelected: _onItemTapped, // Handle tab item tap
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.event),
                label: 'My Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.card_giftcard),
                label: 'My Wishlists',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      );
  }
}