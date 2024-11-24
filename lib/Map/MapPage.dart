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
  Map<String, dynamic>? _selectedMarkerPoint; // Track the selected marker
  bool _isPopupOpen = false; // Track if the popup is open

  @override
  void initState() {
    super.initState();
    _loadMarkers(); // Load markers from Firestore
    _getCurrentLocation(); // Get the current location
  }

  // Get the user's current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _currentCenter = LatLng(position.latitude, position.longitude); // Update map center to user's location
      });
    } catch (e) {
      print("Error fetching location: $e");
      // Handle location error by setting a default value or showing a message
      setState(() {
        _currentPosition = null;
        _currentCenter = LatLng(45.5017, -73.5673); // Default to Montreal if location isn't available
      });
    }
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
    setState(() {
      _selectedMarkerPoint = point;
      _isPopupOpen = true;
    });
  }

  // Function to calculate the distance between the user's current location and the event
  Future<double> _calculateDistance(double userLat, double userLng, double eventLat, double eventLng) async {
    if (_currentPosition == null) {
      return 0; // If the current location is not available, return 0 distance
    }
    var distance = Geolocator.distanceBetween(userLat, userLng, eventLat, eventLng);
    return distance; // Returns the distance in meters
  }

  // Zoom in functionality, zooming at the current center of the map
  void _zoomIn() {
    setState(() {
      if (_currentZoom < 18.0) {
        _currentZoom += 1.0;
        _mapController.move(_currentCenter, _currentZoom); // Move the map to the current center with new zoom
      }
    });
  }

  // Zoom out functionality, zooming at the current center of the map
  void _zoomOut() {
    setState(() {
      if (_currentZoom > 4.0) {
        _currentZoom -= 1.0;
        _mapController.move(_currentCenter, _currentZoom); // Move the map to the current center with new zoom
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Close the popup if tapped outside
          if (_isPopupOpen) {
            setState(() {
              _isPopupOpen = false;
            });
          }
        },
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentCenter,
                zoom: _currentZoom,
                onPositionChanged: (MapPosition position, bool hasGesture) {
                  // Update current center when user pans the map
                  setState(() {
                    _currentCenter = position.center!;
                  });
                },
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
            // Zoom in/out buttons at the bottom right corner
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.zoom_in),
                    onPressed: _zoomIn,
                    iconSize: 40,
                    color: Colors.blue,
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_out),
                    onPressed: _zoomOut,
                    iconSize: 40,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            if (_isPopupOpen && _selectedMarkerPoint != null)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.2, // Position based on screen height, adjust as needed
                left: MediaQuery.of(context).size.width * 0.3, // Position based on screen width, adjust as needed
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      // Prevent the popup from closing if the user taps inside it
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: FutureBuilder<double>(
                        future: _calculateDistance(
                          _currentPosition?.latitude ?? 0, // Ensure we don't call null
                          _currentPosition?.longitude ?? 0,
                          _selectedMarkerPoint!['latitude'] ?? 0,
                          _selectedMarkerPoint!['longitude'] ?? 0,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          double distance = snapshot.data ?? 0;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Close button positioned at the top-right
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    size: 20, // Smaller close button
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPopupOpen = false; // Close the popup
                                    });
                                  },
                                ),
                              ),
                              Text(
                                _selectedMarkerPoint!['name'] ?? 'Event Name',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(_selectedMarkerPoint!['description'] ?? 'Description of the event'),
                              const SizedBox(height: 8),
                              Text(
                                'Type: ${_selectedMarkerPoint!['type'] ?? 'Unknown'}', // Show type of activity
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Location: ${_selectedMarkerPoint!['location'] ?? 'Location not available'}', // Show location or default text
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Distance: ${distance.toStringAsFixed(2)} meters', // Show calculated distance
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  _showMarkerDetails(_selectedMarkerPoint!);
                                },
                                child: const Text('More Info'),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(PageName: "Carte"),
    );
  }
}
