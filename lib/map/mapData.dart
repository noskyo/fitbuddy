import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Liste des points de données
final List<Map<String, dynamic>> points = [
  {'latitude': 45.4964, 'longitude': -73.5483}, // Montréal
  {'latitude': 46.8139, 'longitude': -71.2082}, // Québec
  {'latitude': 43.65107, 'longitude': -79.347015}, // Toronto
];

// Fonction pour générer les marqueurs
List<Marker> genererMarqueurs(List<Map<String, dynamic>> points) {
  return points.map((point) {
    return Marker(
      point: LatLng(point['latitude'], point['longitude']),
      width: 80,
      height: 80,
      builder: (context) => Icon(
        Icons.location_pin,
        size: 40,
        color: Colors.red,
      ),
    );
  }).toList();
}