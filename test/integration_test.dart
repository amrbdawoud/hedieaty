import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty/main.dart';
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('Complete user journey test', (tester) async {
      // Launch app
      await tester.pumpWidget(const HedieatyApp());
      await tester.pumpAndSettle();

      // Login
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'password123');
      await tester.tap(find.byKey(const Key('submitLogin')));
      await tester.pumpAndSettle();

      // Verify login success
      expect(find.text('Welcome'), findsOneWidget);

      // Create Event
      await tester.tap(find.byKey(const Key('createEventButton')));
      await tester.enterText(
          find.byKey(const Key('eventNameField')), 'Birthday Party');
      await tester.enterText(
          find.byKey(const Key('eventDateField')), '2024-12-25');
      await tester.tap(find.byKey(const Key('saveEventButton')));
      await tester.pumpAndSettle();

      // Verify event creation
      expect(find.text('Birthday Party'), findsOneWidget);

      // Create Wishlist
      await tester.tap(find.byKey(const Key('createWishlistButton')));
      await tester.enterText(
          find.byKey(const Key('wishlistNameField')), 'My Wishlist');
      await tester.tap(find.byKey(const Key('saveWishlistButton')));
      await tester.pumpAndSettle();

      // Verify wishlist creation
      expect(find.text('My Wishlist'), findsOneWidget);

      // Add Friend
      await tester.tap(find.byKey(const Key('addFriendButton')));
      await tester.enterText(
          find.byKey(const Key('friendEmailField')), 'friend@example.com');
      await tester.tap(find.byKey(const Key('sendFriendRequest')));
      await tester.pumpAndSettle();

      // Verify friend request sent
      expect(find.text('Friend Request Sent'), findsOneWidget);

      // Logout
      await tester.tap(find.byKey(const Key('menuButton')));
      await tester.tap(find.byKey(const Key('logoutButton')));
      await tester.pumpAndSettle();

      // Verify logout
      expect(find.text('Login'), findsOneWidget);
    });
  });
}