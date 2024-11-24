import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class MoreInfo extends StatelessWidget {
  final Map<String, dynamic> eventDetails;

  const MoreInfo({Key? key, required this.eventDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extracting event details with fallback values
    final String eventName = eventDetails['ActivityName'] ?? 'Unnamed Event';
    final int? eventDateMillis = eventDetails['EventDate'];
    final double? eventLatitude = eventDetails['Latitude'];
    final double? eventLongitude = eventDetails['Longitude'];
    final String description = eventDetails['Description'] ?? 'No description available';

    // Format date if available
    final String formattedDate = eventDateMillis != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(
        DateTime.fromMillisecondsSinceEpoch(eventDateMillis).toLocal())
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

            // Event Location (if available)
            if (eventLatitude != null && eventLongitude != null) ...[
              const Text(
                'Location:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Latitude: $eventLatitude\nLongitude: $eventLongitude',
                style: const TextStyle(fontSize: 16),
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

            // Go Back Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
