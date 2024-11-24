import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'editable_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  bool isLoading = true;

  // Store user data that will be fetched from Firestore
  Map<String, dynamic> userData = {
    'courriel': '',
    'prenom': '',
    'nom': '',
    'sexe': '',
    'dateNaissance': '',
  };

  // Function to fetch user data from Firestore using the authenticated user's UID
  void fetchUserData() async {
    try {
      // Get the current user ID from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch data from Firestore using the UID of the logged-in user
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)  // Fetch the document with the same UID as the logged-in user
            .get();

        if (userDoc.exists) {
          // If the document exists, update the state with the user's data
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
            isLoading = false;
          });
        } else {
          // Handle case where the user document doesn't exist in the Firestore database
          setState(() {
            isLoading = false;
          });
          print("User not found in Firestore");
        }
      } else {
        // Handle case when the user is not authenticated
        setState(() {
          isLoading = false;
        });
        print("No user logged in");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();  // Fetch the user data as soon as the profile page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Page')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Editable Field for Email
              EditableField(
                label: 'Email',
                fieldKey: 'courriel',
                userData: userData,
                isEditing: isEditing,
              ),
              // Editable Field for First Name
              EditableField(
                label: 'First Name',
                fieldKey: 'prenom',
                userData: userData,
                isEditing: isEditing,
              ),
              // Editable Field for Last Name
              EditableField(
                label: 'Last Name',
                fieldKey: 'nom',
                userData: userData,
                isEditing: isEditing,
              ),
              // Editable Field for Gender
              EditableField(
                label: 'Gender',
                fieldKey: 'sexe',
                userData: userData,
                isEditing: isEditing,
              ),
              // Editable Field for Date of Birth
              EditableField(
                label: 'Date of Birth',
                fieldKey: 'dateNaissance',
                userData: userData,
                isEditing: isEditing,
              ),
              SizedBox(height: 24),
              // Save button (Only visible when editing)
              if (isEditing)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Save logic to update Firestore can go here
                      print("Save Changes");
                      setState(() {
                        isEditing = false;  // Toggle back to non-edit mode after saving
                      });
                    },
                    child: Text('Save Changes'),
                  ),
                ),
              SizedBox(height: 16),
              // Edit button to toggle edit mode
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing; // Toggle edit mode
                    });
                  },
                  child: Text(isEditing ? 'Cancel' : 'Edit Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditableField extends StatefulWidget {
  final String label;
  final String fieldKey;
  final Map<String, dynamic> userData;
  final bool isEditing;

  const EditableField({
    Key? key,
    required this.label,
    required this.fieldKey,
    required this.userData,
    required this.isEditing,
  }) : super(key: key);

  @override
  _EditableFieldState createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.userData[widget.fieldKey]?.toString());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        widget.isEditing
            ? TextField(
          controller: controller,
          decoration: InputDecoration(border: OutlineInputBorder()),
        )
            : Text(widget.userData[widget.fieldKey]?.toString() ?? 'N/A'),
        SizedBox(height: 16),
      ],
    );
  }
}
