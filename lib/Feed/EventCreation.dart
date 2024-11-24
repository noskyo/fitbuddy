import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    // Get the UID of the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated! Please log in first.')),
      );
      return;
    }
    String userID = user.uid;

    // Create a new document in the "Activity" collection
    await FirebaseFirestore.instance.collection('Activity').add({
      'ActivityName': activityName,
      'Address': address,
      'Date': eventDateTime,
      'Description': description,
      'Latitude': latitude,
      'Longitude': longitude,
      'UserID': userID, // Add user ID to the Firestore document
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

  // Date picker function (allow only future dates)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), // Only future dates
      lastDate: DateTime(2100), // Arbitrary far future date
    ) ?? _selectedDate;

    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Time picker function (enforce future times for today)
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    ) ?? _selectedTime;

    final now = TimeOfDay.now();

    if (_selectedDate.isAtSameMomentAs(DateTime.now()) &&
        (picked.hour < now.hour || (picked.hour == now.hour && picked.minute <= now.minute))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a future time.')),
      );
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
