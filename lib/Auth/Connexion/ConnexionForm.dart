import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superfitbuddy/Feed/FeedPage.dart';

class ConnexionForm extends StatelessWidget {
  const ConnexionForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // Fonction de Connexion
    Future<void> connexion(BuildContext context) async {
      try {
        // Tentative de Connexion avec Firebase
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Affichage d'un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connexion réussie !')),
        );

        // Naviguer vers la page FeedPage après une Connexion réussie
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FeedPage()),
        );
      } on FirebaseAuthException catch (e) {
        // Gestion des erreurs de Connexion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Erreur de Connexion')),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Adresse courriel',
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
              suffixIcon: const Icon(Icons.visibility_off),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            // Encapsuler l'appel dans une fonction anonyme
            onPressed: () => connexion(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Se connecter",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
