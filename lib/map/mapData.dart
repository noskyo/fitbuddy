import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

Future<List<Map<String, dynamic>>> fetchActivityPoints() async {
  final List<Map<String, dynamic>> activityPoints = [];

  try {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('Activity').get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      activityPoints.add({
        'latitude': data['Latitude'],
        'longitude': data['Longitude'],
        'name': data['ActivityName'],
        'description': data['Description'],
      });
    }
  } catch (e) {
    print('Error fetching data: $e');
  }

  return activityPoints;
}
