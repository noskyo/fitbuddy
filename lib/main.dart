import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superfitbuddy/Feed/FeedPage.dart';
import 'package:superfitbuddy/Auth/AuthPage.dart';
import 'package:superfitbuddy/Homepage/homepage.dart'; // Chemin vers votre HomePageWidget
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Vérification dynamique de l'état de connexion Firebase
    User? currentUser = FirebaseAuth.instance.currentUser;
    bool isUserConnected = currentUser == null;

    // Page initiale en fonction de l'état de connexion
    Widget initialPage = isUserConnected ? HomePageWidget() : AuthPage();

    return MaterialApp(
      home: initialPage, // Définir la page initiale
      debugShowCheckedModeBanner: false,
      title: 'SuperFitBuddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/feed': (context) => FeedPage(), // Route nommée pour FeedPage
      },
    );
  }
}

// Classe pour tester la connexion Firebase
class _FirebaseTestPageState {
  void _testFirebaseConnection() async {
    try {
      // Test Firestore connection
      final testDoc = FirebaseFirestore.instance.collection('test').doc('testDoc');
      await testDoc.set({'timestamp': DateTime.now()});
      final snapshot = await testDoc.get();
      if (snapshot.exists) {
        print("Firebase connection successful!");
      } else {
        print("Firebase connection failed: No document found.");
      }
    } catch (e) {
      print("Firebase connection failed: $e");
    }
  }
}
