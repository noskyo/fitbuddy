import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart'; // For getting the user's current location
import '../Feed/MoreInfo.dart';
import '../Feed/EventCreation.dart'; // Import EventCreation page
import '../NavBar.dart';
import 'MapData.dart'; // Import MoreInfo page

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({super.key});

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  double _currentZoom = 13.0;
  LatLng _currentCenter = LatLng(45.5017, -73.5673); // Default to Montreal
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadMarkers(); // Load markers from Firestore
    _getCurrentLocation(); // Get the current location
  }

  // Get the user's current location
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _currentCenter = LatLng(position.latitude, position.longitude); // Update map center to user's location
    });
  }

  // Function to load markers (for demonstration, replace with real data)
  Future<void> _loadMarkers() async {
    List<Map<String, dynamic>> activityPoints = await fetchActivityPoints(); // Fetch activity points from Firebase
    setState(() {
      _markers = activityPoints.map((point) {
        return Marker(
          point: LatLng(point['latitude'], point['longitude']),
          width: 80,
          height: 80,
          builder: (context) => GestureDetector(
            onTap: () {
              _showMarkerDetails(point); // Show details when a marker is clicked
            },
            child: const Icon(
              Icons.location_pin,
              size: 40,
              color: Colors.red,
            ),
          ),
        );
      }).toList();
    });
  }

  // Show marker details and navigate to MoreInfo page
  void _showMarkerDetails(Map<String, dynamic> point) async {
    if (_currentPosition != null) {
      double distance = await _calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          point['latitude'],
          point['longitude']
      );

      // Navigate to MoreInfo page and pass event details and distance
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoreInfo(
            eventDetails: point,
            distance: distance,
          ),
        ),
      );
    }
  }

  // Function to calculate the distance between the user's current location and the event
  Future<double> _calculateDistance(double userLat, double userLng, double eventLat, double eventLng) async {
    var distance = Geolocator.distanceBetween(userLat, userLng, eventLat, eventLng);
    return distance; // Returns the distance in meters
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentCenter,
              zoom: _currentZoom,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.flutter_map',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() => _currentZoom = _currentZoom + 1);
                    _mapController.move(_currentCenter, _currentZoom);
                  },
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _currentZoom = _currentZoom - 1);
                    _mapController.move(_currentCenter, _currentZoom);
                  },
                  child: const Icon(Icons.zoom_out),
                ),
                const SizedBox(height: 10),  // Add spacing between zoom buttons and the '+' button
                FloatingActionButton(
                  onPressed: () {
                    // Navigate to EventCreation page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  EventCreation()), // Assuming EventCreation is in 'Feed' directory
                    );
                  },
                  backgroundColor: Colors.grey[200], // Match color with zoom buttons
                  child: const Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
