import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:superfitbuddy/Feed/FeedPage.dart';
import 'package:superfitbuddy/pages/page_authentification.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool resultat =
        true; // false : Initialisation , true : Deja connectee --> VERIFIER SI DEJA CONNECTE

    _FirebaseTestPageState()._testFirebaseConnection();

    if (resultat) {
    } else {}

    // Compte enregistré
    // Connexion ou creation de compte

    return MaterialApp(
      home: resultat
          ? FeedPage()
          : PageAuthentification(), // La page qui s'affiche au démarrage
    );
  }
}

class _FirebaseTestPageState {
  String _status = "Testing Firebase connection...";

  // @override
  // void initState() {
  //   super.initState();
  //   _testFirebaseConnection();
  // }

  void _testFirebaseConnection() async {
    try {
      // Test Firestore connection
      final testDoc =
          FirebaseFirestore.instance.collection('test').doc('testDoc');
      await testDoc.set({'timestamp': DateTime.now()});
      final snapshot = await testDoc.get();
      if (snapshot.exists) {
        // setState(() {
        print("Firebase connection successful!");
        //   _status = "Firebase connection successful!";
        // });
      } else {
        // setState(() {
        print("Firebase connection failed: No document found.");
        // });
      }
    } catch (e) {
      print("Firebase connection failed: $e");
      // setState(() {
      //   _status = ;
      // });
    }
  }
}
//   if (snapshot.exists) {
//     setState(() {
//       _status = "Firebase connection successful!";
//     });
//   } else {
//     setState(() {
//       _status = "Firebase connection failed: No document found.";
//     });
//   }
// } catch (e) {
//   setState(() {
//     _status = "Firebase connection failed: $e";
//   });
// }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
//           children: [
//             Text(
//               _status,
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             const SizedBox(height: 16),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => InteractiveMap()),
//                 );
//               },
//               child: const Text('on test la map'),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const NavBar(),
//     );
//   }
// }
