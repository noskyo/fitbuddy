import 'package:flutter/material.dart';
import 'editable_field.dart';




class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  bool isEditing = false;

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
              EditableField(
                label: 'Email',
                fieldKey: 'courriel',
                userData: userData,
                isEditing: isEditing,
                onEditToggle: (bool newState) {
                  setState(() {
                    isEditing = newState;
                  });
                },
              ),
              EditableField(
                label: 'First Name',
                fieldKey: 'prenom',
                userData: userData,
                isEditing: isEditing,
                onEditToggle: (bool newState) {
                  setState(() {
                    isEditing = newState;
                  });
                },
              ),
              EditableField(
                label: 'Last Name',
                fieldKey: 'nom',
                userData: userData,
                isEditing: isEditing,
                onEditToggle: (bool newState) {
                  setState(() {
                    isEditing = newState;
                  });
                },
              ),
              EditableField(
                label: 'Gender',
                fieldKey: 'sexe',
                userData: userData,
                isEditing: isEditing,
                onEditToggle: (bool newState) {
                  setState(() {
                    isEditing = newState;
                  });
                },
              ),
              EditableField(
                label: 'Date of Birth',
                fieldKey: 'dateNaissance',
                userData: userData,
                isEditing: isEditing,
                onEditToggle: (bool newState) {
                  setState(() {
                    isEditing = newState;
                  });
                },
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement save logic here
                  },
                  child: Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
