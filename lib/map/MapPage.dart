import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'MapData.dart';
import '../NavBar.dart';

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({super.key});

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  double _currentZoom = 13.0;
  LatLng _currentCenter = LatLng(45.5017, -73.5673); // Montréal (par défaut)

  @override
  void initState() {
    super.initState();
    _loadMarkers(); // Charger les marqueurs depuis Firestore
  }

  Future<void> _loadMarkers() async {
    List<Map<String, dynamic>> activityPoints = await fetchActivityPoints();
    setState(() {
      _markers = activityPoints.map((point) {
        return Marker(
          point: LatLng(point['latitude'], point['longitude']),
          width: 80,
          height: 80,
          builder: (context) => GestureDetector(
            onTap: () {
              _showMarkerDetails(point);
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

  void _showMarkerDetails(Map<String, dynamic> point) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(point['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Description: ${point['description']}"),
              const SizedBox(height: 10),
              Text("Latitude: ${point['latitude']}"),
              Text("Longitude: ${point['longitude']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
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
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Colors.black,
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
