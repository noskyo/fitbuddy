import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../navbar.dart';
import 'EventCreation.dart';
import 'Moreinfo.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // Griffintown, Montreal coordinates
  final double referenceLatitude = 45.4850;
  final double referenceLongitude = -73.5610;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Haversine formula for distance calculation
  double _calculateDistanceFromCoordinates(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude) {
    const double R = 6371000; // Earth's radius in meters
    double dLat = _degreesToRadians(endLatitude - startLatitude);
    double dLon = _degreesToRadians(endLongitude - startLongitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(startLatitude)) *
            cos(_degreesToRadians(endLatitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in meters
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown Date";
    final dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd – HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('Activity').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No activities found.');
            }

            final events = snapshot.data!.docs;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index].data() as Map<String, dynamic>?;

                if (event == null) {
                  return const ListTile(
                    title: Text('Error loading event'),
                  );
                }

                final eventName = event['ActivityName'] ?? 'Unnamed Event';
                final eventLatitude = event['Latitude'] as double?;
                final eventLongitude = event['Longitude'] as double?;
                final formattedDate = _formatTimestamp(event['Timestamp']);
                final seriousness = event['Seriousness'] ?? 'Unknown';
                final gender = event['Gender'] ?? 'Mix';
                final eventDescription =
                    event['Description'] ?? 'No description available';

                double eventDistance = 0.0;
                if (eventLatitude != null && eventLongitude != null) {
                  eventDistance = _calculateDistanceFromCoordinates(
                    referenceLatitude,
                    referenceLongitude,
                    eventLatitude,
                    eventLongitude,
                  );
                }

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: ListTile(
                    title: Text(eventName),
                    subtitle: Text(
                      'Distance: ${eventDistance.toStringAsFixed(2)} meters\n'
                          'Date: $formattedDate\n'
                          'Seriousness: $seriousness\n'
                          'Gender: $gender\n'
                          'Description: $eventDescription',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoreInfo(
                            eventDetails: event,
                            distance: eventDistance,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const NavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventCreation()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
