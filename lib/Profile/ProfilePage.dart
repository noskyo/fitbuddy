import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superfitbuddy/Auth/AuthPage.dart';
// Replace with actual import path for your page

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  bool isEditing = false;

  String? userId;
  String courriel = '';
  String prenom = '';
  String nom = '';

  late TextEditingController courrielController;
  late TextEditingController prenomController;
  late TextEditingController nomController;

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        userId = user.uid;

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
          setState(() {
            isLoading = false;
          });
          print("User document not found");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print("No user is logged in");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching user data: $e");
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

  // Log out the user and redirect to Auth screen
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()), // Use your custom auth page
    );
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
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
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
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User ID: ${userId ?? "No details"}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              buildEditableField('Email', courrielController, Icons.email),
              const SizedBox(height: 16),
              buildEditableField('First Name', prenomController, Icons.person),
              const SizedBox(height: 16),
              buildEditableField('Last Name', nomController, Icons.person),
              const SizedBox(height: 32),
              if (isEditing)
                Center(
                  child: ElevatedButton(
                    onPressed: saveUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: logOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for logout
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: const Text('Log Out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create editable fields
  Widget buildEditableField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        isEditing
            ? TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.blueAccent),
            border: OutlineInputBorder(),
            hintText: 'Enter your $label',
            filled: true,
            fillColor: Colors.grey[200],
          ),
        )
            : Text(
          controller.text.isEmpty ? 'No details available' : controller.text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
