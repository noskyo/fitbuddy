import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventCreation(),
    );
  }
}

class EventCreation extends StatefulWidget {
  @override
  _EventCreationState createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreation> {
  final TextEditingController _activityNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Function to save the event to Firestore
  Future<void> _saveEvent() async {
    String activityName = _activityNameController.text;
    String address = _addressController.text;
    String description = _descriptionController.text;

    // Convert address to latitude and longitude
    List<Location> locations = await locationFromAddress(address);
    double latitude = locations.first.latitude;
    double longitude = locations.first.longitude;

    // Combine selected date and time
    DateTime eventDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Create a new document in the "Activity" collection
    await FirebaseFirestore.instance.collection('Activity').add({
      'ActivityName': activityName,
      'Address': address,
      'Date': eventDateTime,
      'Description': description,
      'Latitude': latitude,
      'Longitude': longitude,
    });

    // Clear fields after saving
    _activityNameController.clear();
    _addressController.clear();
    _descriptionController.clear();

    // Show a visual indicator (Snackbar)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event created successfully!')),
    );
  }

  // Date picker function (restrict future dates)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // Restrict future dates
    ) ?? _selectedDate;
    setState(() {
      _selectedDate = picked;
    });
  }

  // Time picker function (cannot select the current time)
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    ) ?? _selectedTime;

    if (picked.hour == TimeOfDay.now().hour && picked.minute == TimeOfDay.now().minute) {
      // Avoid selecting the current time
      return;
    }

    setState(() {
      _selectedTime = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Creation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _activityNameController,
              decoration: InputDecoration(labelText: 'Activity Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date: ${_selectedDate.toLocal()}".split(' ')[0]),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Time: ${_selectedTime.format(context)}"),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Select Time'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _saveEvent,
              child: Text('Save Event'),
            ),
          ],
        ),
      ),
    );
  }
}
