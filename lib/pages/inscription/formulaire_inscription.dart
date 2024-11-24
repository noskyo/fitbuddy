import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormulaireInscription extends StatefulWidget {
  const FormulaireInscription({super.key});

  @override
  State<FormulaireInscription> createState() => _FormulaireInscriptionState();
}

class _FormulaireInscriptionState extends State<FormulaireInscription> {
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  String sexe = "Homme";
  DateTime? dateNaissance;

  Future<void> _selectDateNaissance() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateNaissance = picked;
        dateNaissanceController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> inscrire() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas !')),
      );
      return;
    }
    if (dateNaissance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner votre date de naissance.')),
      );
      return;
    }
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'prenom': prenomController.text.trim(),
          'nom': nomController.text.trim(),
          'courriel': user.email,
          'sexe': sexe,
          'dateNaissance': dateNaissance!.toIso8601String(),
          'createdAt': DateTime.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compte créé avec succès !')),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Erreur lors de la création du compte')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: prenomController,
            decoration: InputDecoration(
              labelText: 'Prénom',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nomController,
            decoration: InputDecoration(
              labelText: 'Nom',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Adresse courriel',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: sexe,
            onChanged: (value) => setState(() {
              sexe = value!;
            }),
            items: const [
              DropdownMenuItem(value: "Homme", child: Text("Homme")),
              DropdownMenuItem(value: "Femme", child: Text("Femme")),
              DropdownMenuItem(value: "Autre", child: Text("Autre")),
            ],
            decoration: const InputDecoration(labelText: 'Sexe'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: dateNaissanceController,
            readOnly: true,
            onTap: _selectDateNaissance,
            decoration: InputDecoration(
              labelText: 'Date de naissance',
              hintText: "JJ/MM/AAAA",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirmer le mot de passe',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: inscrire,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Créer un compte",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
