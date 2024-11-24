import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // Import geocoding package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Événements Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FirebaseCalls(), // Set FirebaseCalls as the home
    );
  }
}

Future<void> addEvent({
  required String activityName,
  required DateTime date,
  required String address,
  required String description,
  required TimeOfDay time,
}) async {
  try {
    // Convert address to latitude and longitude
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      double latitude = locations.first.latitude;
      double longitude = locations.first.longitude;

      // Combine date and time into a single DateTime object
      DateTime eventDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      // Write event to Firestore
      await FirebaseFirestore.instance.collection('Activity').add({
        'NomDeLactivité': activityName,
        'Date': eventDateTime,
        'Adresse': address,
        'Latitude': latitude,
        'Longitude': longitude,
        'Description': description,
        'Timestamp': FieldValue.serverTimestamp(), // Adding a timestamp
      });

      print("Événement ajouté avec succès!");
    } else {
      print("Aucune localisation trouvée pour l'adresse fournie.");
    }
  } catch (e) {
    print("Erreur lors de l'ajout de l'événement: $e");
  }
}

class FirebaseCalls extends StatefulWidget {
  const FirebaseCalls({super.key});

  @override
  _FirebaseCallsState createState() => _FirebaseCallsState();
}

class _FirebaseCallsState extends State<FirebaseCalls> {
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isEventAdded = false; // Flag to track if event is added

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), // Prevent selecting past dates
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to show time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appels Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            if (!_isEventAdded) ...[
              // Champ de texte pour le nom de l'activité
              TextField(
                controller: _activityController,
                decoration: InputDecoration(
                  labelText: 'Entrez le nom de l\'activité',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              // Sélecteur de date pour l'événement
              Row(
                children: [
                  Text('Date de l\'événement: ${_selectedDate.toLocal()}'
                      .split(' ')[0]),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Sélecteur de l'heure pour l'événement
              Row(
                children: [
                  Text(
                      'Heure de l\'événement: ${_selectedTime.format(context)}'),
                  IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _selectTime(context),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Champ de texte pour l'adresse
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Entrez l\'adresse',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              // Champ de texte pour la description
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Entrez la description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Bouton pour ajouter l'événement
              ElevatedButton(
                onPressed: () {
                  final activityName = _activityController.text.trim();
                  final address = _addressController.text.trim();
                  final description = _descriptionController.text.trim();

                  if (activityName.isNotEmpty &&
                      address.isNotEmpty &&
                      description.isNotEmpty) {
                    addEvent(
                      activityName: activityName,
                      date: _selectedDate,
                      address: address,
                      description: description,
                      time: _selectedTime,
                    );

                    // Masquer le formulaire et afficher la confirmation
                    setState(() {
                      _isEventAdded = true;
                    });
                  } else {
                    print("Veuillez remplir tous les champs.");
                  }
                },
                child: const Text('Ajouter l\'événement'),
              ),
            ] else ...[
              // Afficher le message de confirmation après l'ajout de l'événement
              Text(
                'Événement ajouté avec succès!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Réinitialiser le formulaire pour ajouter un autre événement
                    _isEventAdded = false;
                    _activityController.clear();
                    _addressController.clear();
                    _descriptionController.clear();
                    _selectedDate = DateTime.now();
                    _selectedTime = TimeOfDay.now();
                  });
                },
                child: const Text('Ajouter un autre événement'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
