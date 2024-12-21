import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/events/models/event.dart';
import 'edit_event_viewmodel.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;
  EditEventScreen({required this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.name);
    _dateController = TextEditingController(text: widget.event.date);
    _categoryController = TextEditingController(text: widget.event.category);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Edit Event',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Theme.of(context).primaryColor.withOpacity(0.1)],
          ),
        ),
        child: Consumer<EditEventViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Event Date (YYYY-MM-DD)',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: 'Event Category',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      Event updatedEvent = Event(
                        id: widget.event.id,
                        name: _nameController.text,
                        date: _dateController.text,
                        category: _categoryController.text,
                        userId: widget.event.userId,
                      );
                      await viewModel.updateEvent(updatedEvent);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (viewModel.error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        viewModel.error,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}