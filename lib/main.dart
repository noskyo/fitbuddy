import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:superfitbuddy/Feed/FeedPage.dart';
import 'package:superfitbuddy/Auth/AuthPage.dart';
import 'package:superfitbuddy/Homepage/homepage.dart'; // Chemin vers HomePageWidget
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool resultat = false; // false : Non connecté, true : Connecté

    _FirebaseTestPageState()._testFirebaseConnection();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SuperFitBuddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: resultat ? FeedPage() : AuthPage(), // Page initiale
      routes: {
        '/feed': (context) => FeedPage(), // Route nommée pour FeedPage
      },
    );
  }
}

class _FirebaseTestPageState {
  void _testFirebaseConnection() async {
    try {
      final testDoc =
      FirebaseFirestore.instance.collection('test').doc('testDoc');
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
