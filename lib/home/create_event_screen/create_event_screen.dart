import 'package:flutter/material.dart';
import 'create_event_viewmodel.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final EventViewModel _eventViewModel = EventViewModel();
  String _eventName = '';
  String _eventDate = '';
  String _eventCategory = 'Social';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _eventDate = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _eventViewModel.createEvent(
          name: _eventName,
          date: _eventDate,
          category: _eventCategory,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Event successfully created!'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create event: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Create New Event', style: TextStyle(color: Colors.white)),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Event Name',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  onChanged: (value) => setState(() => _eventName = value),
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter the event name' : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Event Date',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    hintText: 'Select Event Date',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    suffixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                  ),
                  controller: TextEditingController(text: _eventDate),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) => value?.isEmpty ?? true ? 'Please select the event date' : null,
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: _eventCategory,
                  decoration: InputDecoration(
                    labelText: 'Event Category',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                  ),
                  items: <String>['Social', 'Business', 'Entertainment', 'Charity']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => _eventCategory = newValue!);
                  },
                  validator: (value) => value?.isEmpty ?? true ? 'Please select an event category' : null,
                ),
                const SizedBox(height: 40),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _saveEvent,
                  child: const Text(
                    'Save Event',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}