import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'mapData.dart';

class InteractiveMap extends StatelessWidget {
  const InteractiveMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Carte FlutterMap
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(45.5017, -73.5673), // Coordonnées initiales
              initialZoom: 13.0, // Zoom initial
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

          // Bouton pour ajouter une activité
          Positioned(
            bottom: 100, // Position verticale
            left: 0,
            right: 0, // Centrage horizontal
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Création d'une activité.")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Ajouter une activité"),
              ),
            ),
          ),

          // Bouton pour revenir à la page principale
          Positioned(
            top: 40, // Position en haut
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context); // Retour à la page précédente
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}