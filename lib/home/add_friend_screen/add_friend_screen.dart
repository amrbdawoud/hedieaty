import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add provider package for state management
import 'add_friend_viewmodel.dart'; // Adjust the import path for AddFriendViewModel

class AddFriendScreen extends StatelessWidget {
  const AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddFriendViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Friend by Phone Number"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AddFriendViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter phone number to add a friend:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: viewModel.phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: viewModel.isSearching
                        ? null
                        : () async {
                      final phoneNumber = viewModel.phoneNumberController.text;
                      if (phoneNumber.isNotEmpty) {
                        await viewModel.searchAndAddFriend(phoneNumber, context);
                      }
                    },
                    child: Text('Add Friend'),
                  ),
                  if (viewModel.isSearching)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}