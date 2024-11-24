import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:superfitbuddy/Feed/FeedPage.dart';
import 'package:superfitbuddy/Auth/AuthPage.dart';
import 'firebase_options.dart';
import 'NavBar.dart';
import 'Map/MapPage.dart';
import 'Startup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool resultat = true; // This might have been dynamically determined in the actual code.
    return MaterialApp(
      home: resultat ? FeedPage() : AuthPage(), // La page qui s'affiche au démarrage
      debugShowCheckedModeBanner: false,
      title: 'Carrousel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

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
