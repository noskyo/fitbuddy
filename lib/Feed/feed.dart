import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import '../NavBar.dart';

// Page Profile
class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Informations du profil
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Image de profil
            ),
            SizedBox(height: 20),
            Text(
              'Nom: Paul Dupont',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              'Âge: 28 ans',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Profession: Développeur Flutter',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
