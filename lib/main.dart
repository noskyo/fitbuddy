import 'package:flutter/material.dart';
import 'Homepage/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool resultat = true; // false : Initialisation , true : Deja connectee --> VERIFIER SI DEJA CONNECTE


    _FirebaseTestPageState()._testFirebaseConnection();

    if (resultat){

    } else {

    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carrousel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePageWidget(),
    );
  }
}
