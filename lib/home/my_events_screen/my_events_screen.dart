import 'package:flutter/material.dart';
import 'package:hedieaty/home/edit_event_screen/edit_event_screen.dart';
import 'package:provider/provider.dart';
import '../create_event_screen/create_event_screen.dart';
import '../edit_event_screen/edit_event_viewmodel.dart';
import 'my_events_viewmodel.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('My Events', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              context.read<MyEventViewModel>().sortEvents(value);
            },
            itemBuilder: (context) {
              return ['Name', 'Category', 'Status']
                  .map((option) => PopupMenuItem<String>(
                value: option,
                child: Text(option),
              ))
                  .toList();
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
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
          child: Consumer<MyEventViewModel>(
            builder: (context, viewModel, child) {
              final events = viewModel.events;
              return events.isEmpty
                  ? const Center(child: Text('No events available'))
                  : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Dismissible(
                    key: Key(event.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      context.read<MyEventViewModel>().deleteEvent(event.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${event.name} deleted')),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white, size: 40),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => EditEventViewModel(),
                              child: EditEventScreen(event: event),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        shadowColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${event.category} - ${event.date}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              _buildStatusBadge(event.status, context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
              builder: (context) => const CreateEventScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        tooltip: 'Add New Event',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatusBadge(String status, BuildContext context) {
    final color = _getStatusColor(status, context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Color _getStatusColor(String status, BuildContext context) {
    switch (status) {
      case 'Upcoming':
        return Theme.of(context).primaryColor;
      case 'Current':
        return Theme.of(context).colorScheme.secondary;
      case 'Past':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}