import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FormulaireConnexion extends StatelessWidget {
  const FormulaireConnexion({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> connexion() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connexion réussie !')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Erreur de connexion')),
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
            onPressed: connexion,
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
