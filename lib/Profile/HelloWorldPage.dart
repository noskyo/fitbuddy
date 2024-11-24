import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HelloWorldPage extends StatefulWidget {
  const HelloWorldPage({Key? key}) : super(key: key);

  @override
  _HelloWorldPageState createState() => _HelloWorldPageState();
}

class _HelloWorldPageState extends State<HelloWorldPage> {
  bool isLoading = true;
  bool isEditing = false;

  String? userId;
  String courriel = '';
  String prenom = '';
  String nom = '';

  // Controllers for text editing
  late TextEditingController courrielController;
  late TextEditingController prenomController;
  late TextEditingController nomController;

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the user's ID
        userId = user.uid;

        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            prenom = userDoc.get('prenom') ?? 'N/A';
            nom = userDoc.get('nom') ?? 'N/A';
            courriel = user.email ?? 'No details';

            prenomController.text = prenom;
            nomController.text = nom;
            courrielController.text = courriel;

            isLoading = false;
          });
        } else {
          print("User document not found");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("No user is logged in");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save updated data to Firestore
  Future<void> saveUserData() async {
    try {
      if (userId != null) {
        // Update Firestore with new values
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'prenom': prenomController.text,
          'nom': nomController.text,
        });

        // If email is changed, update it via FirebaseAuth
        if (courrielController.text != courriel) {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await user.updateEmail(courrielController.text); // Update email in FirebaseAuth
            setState(() {
              courriel = courrielController.text;
            });
          }
        }

        setState(() {
          prenom = prenomController.text;
          nom = nomController.text;
          courriel = courrielController.text;
          isEditing = false;
        });
      }
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    prenomController = TextEditingController();
    nomController = TextEditingController();
    courrielController = TextEditingController();
    fetchUserData();
  }

  @override
  void dispose() {
    prenomController.dispose();
    nomController.dispose();
    courrielController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: saveUserData,
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: ${userId ?? "No details"}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            buildEditableField('Courriel', courrielController),
            const SizedBox(height: 8),
            buildEditableField('Prenom', prenomController),
            const SizedBox(height: 8),
            buildEditableField('Nom', nomController),
          ],
        ),
      ),
    );
  }

  // Helper method to create editable fields
  Widget buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        isEditing
            ? TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter $label',
          ),
        )
            : Text(
          controller.text.isEmpty ? 'No details' : controller.text,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
