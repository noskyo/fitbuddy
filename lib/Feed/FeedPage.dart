import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart'; // Add the intl package for date formatting
import '../NavBar.dart';
import 'EventCreation.dart'; // Import the EventCreation file

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Position? _currentPosition;
  String? _currentAddress;

  // Reference location (latitude, longitude)
  double referenceLatitude = 40.748817;
  double referenceLongitude = -73.985428; // Example: Empire State Building (New York)

  // Firestore reference to 'Activity' collection
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null)
              Text(
                "LAT: ${_currentPosition!.latitude}, LNG: ${_currentPosition!.longitude}",
                style: const TextStyle(fontSize: 18),
              ),
            if (_currentAddress != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _currentAddress!,
                  style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text("Get location"),
            ),
            const SizedBox(height: 20),
            if (_currentPosition != null)
              Text(
                "Distance from reference: ${_calculateDistance()} meters",
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),
            // Display events from Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Activity').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final events = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index].data() as Map<String, dynamic>;
                      final eventName = event['ActivityName'] ?? 'Unnamed Event';
                      final eventLatitude = event['Latitude']; // Assuming the latitude is stored
                      final eventLongitude = event['Longitude']; // Assuming the longitude is stored
                      final eventDate = event['EventDate']; // Timestamp field
                      final formattedDate = _formatTimestamp(eventDate);

                      // Calculate the distance between the event and the user's location
                      double eventDistance = 0.0;
                      if (_currentPosition != null && eventLatitude != null && eventLongitude != null) {
                        eventDistance = _calculateDistanceFromCoordinates(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                            eventLatitude,
                            eventLongitude
                        );
                      }

                      return ListTile(
                        title: Text(eventName),
                        subtitle: Text('Date: $formattedDate\nDistance: ${eventDistance.toStringAsFixed(2)} meters'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to EventCreation page when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventCreation()),  // Navigate to EventCreation
          );
        },
        child: const Icon(Icons.add),  // Plus icon
        backgroundColor: Colors.blue,  // You can change the color
      ),
    );
  }

  // Function to format the timestamp into a readable date string
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return 'No date available'; // Return a default message if no date is available
    }

    try {
      print('EventDate: $timestamp'); // Print the timestamp to debug

      if (timestamp is String) {
        // If the date is a string in the format "29 novembre 2024 à 15:10:00 UTC-5"
        try {
          // Parse the string into a DateTime object
          final dateFormatter = DateFormat("d MMMM yyyy 'à' HH:mm:ss 'UTC'Z");
          final date = dateFormatter.parse(timestamp, true); // Parse with timezone handling
          return DateFormat('yyyy-MM-dd HH:mm').format(date); // Reformat the DateTime as needed
        } catch (e) {
          print('Error parsing date string: $e');
          return 'Invalid date format'; // Return a fallback message in case of any error
        }
      } else if (timestamp is Timestamp) {
        // If the timestamp is a Firestore Timestamp
        DateTime date = timestamp.toDate(); // Convert Timestamp to DateTime
        return DateFormat('yyyy-MM-dd HH:mm').format(date); // Format the DateTime as a string
      } else if (timestamp is DateTime) {
        // If the date is already a DateTime
        return DateFormat('yyyy-MM-dd HH:mm').format(timestamp);
      } else {
        return 'Invalid date format'; // Handle cases where the timestamp is not recognized
      }
    } catch (e) {
      print('Error formatting date: $e');
      return 'Error formatting date'; // Return a fallback message in case of any error
    }
  }

  // Function to calculate distance between the user's current position and the event's position using Haversine formula
  double _calculateDistanceFromCoordinates(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radius of the Earth in kilometers
    double dLat = _degToRad(lat2 - lat1); // Difference in latitude
    double dLon = _degToRad(lon2 - lon1); // Difference in longitude

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c; // Distance in kilometers

    return distance * 1000; // Return distance in meters
  }

  // Function to convert degrees to radians
  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng(position);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  // Function to calculate the distance from the reference point in meters
  double _calculateDistance() {
    if (_currentPosition != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        referenceLatitude,
        referenceLongitude,
      );
      return distanceInMeters;
    }
    return 0.0;
  }
}
