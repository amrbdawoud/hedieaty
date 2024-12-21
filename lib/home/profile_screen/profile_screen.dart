import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/home/my_pledged_gifts_screen/my_pledged_gifts_screen.dart';
import 'package:hedieaty/home/profile_settings_screen/profile_settings_screen.dart';
import 'package:hedieaty/onboarding/managers/user_session_manager.dart';
import 'package:hedieaty/onboarding/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "You";

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    String id = (await UserSessionManager.instance.getCurrentUser())!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(id).get();
    setState(() {
      username = userDoc['fullName'];
    });
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Confirm Logout',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await UserSessionManager.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Theme.of(context).primaryColor.withOpacity(0.2),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.account_circle,
                          size: 60,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.settings, color: Theme.of(context).primaryColor),
                      title: Text(
                        'Settings',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.card_giftcard, color: Theme.of(context).primaryColor),
                      title: Text(
                        'My Pledged Gifts',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyPledgedGiftsScreen()),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
                      title: Text(
                        'Logout',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onTap: _showLogoutDialog,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}