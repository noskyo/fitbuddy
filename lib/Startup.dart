import 'package:flutter/material.dart';



class DemarragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page de Démarrage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bienvenue ! Vous êtes déjà connecté.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ajouter la logique pour la déconnexion si nécessaire
              },
              child: Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
