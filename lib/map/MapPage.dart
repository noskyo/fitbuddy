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

  double _currentZoom = 13.0;
  LatLng _currentCenter = LatLng(45.5017, -73.5673); // Montréal (par défaut)

  @override
  void initState() {
    super.initState();

    // Écoute des événements de la carte
    _mapController.mapEventStream.listen((event) {
      if (event is MapEventMove) {
        setState(() {
          _currentCenter = event.center; // Met à jour le centre
          _currentZoom = event.zoom;    // Met à jour le zoom
        });
      }
    });
  }

  // Fonction pour changer le zoom
  void _changeZoom(double zoomChange) {
    setState(() {
      _currentZoom += zoomChange;
      if (_currentZoom < 1.0) _currentZoom = 1.0; // Limite minimale
      if (_currentZoom > 18.0) _currentZoom = 18.0; // Limite maximale
      _mapController.move(_currentCenter, _currentZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Carte FlutterMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentCenter, // Définit le centre initial
              zoom: _currentZoom,    // Définit le zoom initial
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.flutter_map',
              ),
              MarkerLayer(
                markers: genererMarqueurs(points),
              ),
            ],
          ),

          // Boutons pour ajuster le zoom
          Positioned(
            bottom: 40,
            right: 20,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => _changeZoom(3.0),
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _changeZoom(-3.0),
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),



          //retour a l'écran précédent
          Positioned(
            top: 40,
            left: 10,
            child: FloatingActionButton(
                onPressed: ()
              {
                Navigator.pop(context);
              },
            backgroundColor:  Colors.black,
            child: const Icon(Icons.arrow_back, color: Colors.white,),)
          ),

          //ajout d'une activité
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Création d'une activité"),
                    ),
                  );
                },
                child: const Text("Ajouter une activité"), // Ajout d'un texte pour le bouton
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
