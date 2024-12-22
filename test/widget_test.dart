import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty/main.dart';
import 'package:hedieaty/home/data/wishlists/models/wishlist.dart';
import 'package:hedieaty/home/data/wishlists/models/gift.dart';

void main() {
  group('Hedieaty App Tests', () {
    testWidgets('App should render welcome screen initially', (tester) async {
      await tester.pumpWidget(const HedieatyApp());
      expect(find.text('Welcome to Hedieaty'), findsOneWidget);
    });

    test('Wishlist model validation', () {
      final wishlist = Wishlist(
          id: 'test-id',
          userId: 'user-id',
          name: 'Test Wishlist',
          gifts: [
            Gift(
                id: 'gift-id',
                name: 'Test Gift',
                description: 'Test Description',
                price: 100,
                category: 'Electronics'
            )
          ]
      );

      expect(wishlist.name, equals('Test Wishlist'));
      expect(wishlist.gifts.length, equals(1));
    });
  });
}