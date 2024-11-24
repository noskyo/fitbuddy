import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart'; // For formatting the date

class MoreInfo extends StatefulWidget {
  final Map<String, dynamic> eventDetails;
  final double distance;

  MoreInfo({Key? key, required this.eventDetails, required this.distance}) : super(key: key);

  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  @override
  Widget build(BuildContext context) {
    final eventDetails = widget.eventDetails;
    final String eventName = eventDetails['ActivityName'] ?? 'Unnamed Event';
    final int? eventDateMillis = eventDetails['EventDate'];
    final double? eventLatitude = eventDetails['Latitude'];
    final double? eventLongitude = eventDetails['Longitude'];
    final String description = eventDetails['Description'] ?? 'No description available';

    final String formattedDate = eventDateMillis != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(eventDateMillis).toLocal())
        : 'Unknown Date';

    return Scaffold(
      appBar: AppBar(
        title: Text(eventName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Name
            const Text(
              'Event Name:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(eventName, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            // Event Date
            const Text(
              'Event Date:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(formattedDate, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            // Event Location on OpenStreetMap (if available)
            if (eventLatitude != null && eventLongitude != null) ...[
              const Text(
                'Location:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 250,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(eventLatitude, eventLongitude),
                    zoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: _createMarkers(eventLatitude, eventLongitude),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Event Description
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            // Event Distance
            const Text(
              'Distance from your location:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text('${widget.distance.toStringAsFixed(2)} meters', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Function to create markers with location coordinates displayed
  List<Marker> _createMarkers(double? eventLatitude, double? eventLongitude) {
    List<Marker> markers = [];

    if (eventLatitude != null && eventLongitude != null) {
      markers.add(Marker(
        point: LatLng(eventLatitude, eventLongitude),
        builder: (context) => const Icon(Icons.location_pin, size: 40, color: Colors.blue),
      ));
    }
    return markers;
  }
}
