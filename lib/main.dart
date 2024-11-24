import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
    return MaterialApp(
      home: HomePageWidget(), // La page d'accueil est définie sur HomePageWidget
      debugShowCheckedModeBanner: false,
      title: 'SuperFitBuddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/feed': (context) => FeedPage(), // Définir la route pour FeedPage
      },
    );
  }
}
