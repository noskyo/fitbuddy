import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../NavBar.dart';
import 'EventCreation.dart';
import 'Moreinfo.dart'; // Import Moreinfo.dart

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Position? _currentPosition;
  String? _currentAddress;

  double referenceLatitude = 40.748817;
  double referenceLongitude = -73.985428;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchInitialLocation();
  }

  Future<void> _fetchInitialLocation() async {
    try {
      await _getCurrentLocation();
    } catch (e) {
      print("Error fetching initial location: $e");
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      referenceLatitude = position.latitude;
      referenceLongitude = position.longitude;
    });

    await _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    setState(() {
      _currentAddress =
      'Mock Address for (${position.latitude}, ${position.longitude})';
    });
  }

  double _calculateDistanceFromCoordinates(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                      final eventAddress = event['Address'] ?? 'Unknown Address';
                      final eventLatitude = event['Latitude'] as double?;
                      final eventLongitude = event['Longitude'] as double?;
                      final eventDescription =
                          event['Description'] ?? 'No description available';
                      final eventTimestamp = event['Timestamp'] as Timestamp?;
                      final formattedDate = eventTimestamp != null
                          ? _formatTimestamp(eventTimestamp)
                          : 'Unknown Date';

                      double eventDistance = 0.0;
                      if (_currentPosition != null &&
                          eventLatitude != null &&
                          eventLongitude != null) {
                        eventDistance = _calculateDistanceFromCoordinates(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
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
                            'Address: $eventAddress\n'
                                'Date: $formattedDate\n'
                                'Distance: ${eventDistance.toStringAsFixed(2)} meters\n'
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
          ],
        ),
      ),
      bottomNavigationBar:  const NavBar(PageName : "Activité") ,
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
