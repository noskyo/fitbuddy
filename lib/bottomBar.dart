import 'package:flutter/material.dart';
import 'package:superfitbuddy/main.dart';
import 'profile/profilePage.dart';
import 'carte/carte.dart';
import 'Feed/feed.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void setIndexState(int index) {
    _selectedIndex = index;
  }

  void _onItemTapped(int index, BuildContext context) {
    setIndexState(index);

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Feed()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Carte()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex, // The current selected index
      onTap: (index) => _onItemTapped(index, context), // Handle item tap
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.blue,
      showUnselectedLabels: true, // Afficher les titres des autres icones
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.ad_units),
            label: 'Feed'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Carte',
            backgroundColor: Colors.blue),

        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil'),
      ],

    );
  }
}
