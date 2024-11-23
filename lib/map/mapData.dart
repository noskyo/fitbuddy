import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

final List<Map<String, dynamic>> points = [
  {'latitude': 45.5017, 'longitude': -73.5673},
  {'latitude': 45.49641563298726, 'longitude': -73.54834667425904},// Montréal
  {'latitude': 46.8139, 'longitude': -71.2082}, // Québec
  {'latitude': 43.65107, 'longitude': -79.347015}, // Toronto
];

List<Marker> genererMarqueurs(List<Map<String, dynamic>> points) {
  return points.map((point) {
    return Marker(
      point: LatLng(point['latitude'], point['longitude']),
      width: 80,
      height: 80,
      child: Icon(
        Icons.location_pin,
        size: 40,
        color: Colors.red,
      ),
    );
  }).toList();
}