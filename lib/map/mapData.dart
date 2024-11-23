import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Liste des points de données
final List<Map<String, dynamic>> points = [
  {'latitude': 45.5017, 'longitude': -73.5673, 'name': 'Montréal'},
  {'latitude': 46.8139, 'longitude': -71.2082, 'name': 'Québec'},
  {'latitude': 43.65107, 'longitude': -79.347015, 'name': 'Toronto'},
];

// Fonction pour générer les marqueurs
List<Marker> genererMarqueurs(List<Map<String, dynamic>> points) {
  return points.map((point) {
    return Marker(
      point: LatLng(point['latitude'], point['longitude']),
      width: 80,
      height: 80,
      builder: (context) => GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Détails du Marqueur'),
                content: Column(
                  mainAxisSize: MainAxisSize.min, // Ajuste la taille de la boîte de dialogue au contenu
                  children: [
                    const Text(
                      "Date de l'activité : 2024-11-23",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8), // Espacement entre les lignes
                    const Text(
                      "Sport : Football",
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Lieu : Stade Olympique",
                    ),
                    const SizedBox(height: 16), // Espacement avant le bouton

                    // Bouton dans le contenu
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Action réalisée !")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40), // Largeur étendue
                      ),
                      child: const Text('Action'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Ferme la boîte de dialogue
                    },
                    child: const Text('Fermer'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.location_pin,
          size: 40,
          color: Colors.red,
        ),
      ),
    );
  }).toList();
}