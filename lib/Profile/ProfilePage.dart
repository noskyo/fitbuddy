import 'package:flutter/material.dart';
import 'editable_field.dart';




class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  bool isLoading = true;

  // Dummy user data
  Map<String, dynamic> userData = {
    'courriel': 'user@example.com',
    'prenom': 'John',
    'nom': 'Doe',
    'sexe': 'Male',
    'dateNaissance': '01/01/1990',
  };

  // Dummy function to simulate fetching data from Firestore
  void fetchUserData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
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
              // Save button
              if (isEditing)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Save logic here
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
                      isEditing = !isEditing;  // Toggle edit mode
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
