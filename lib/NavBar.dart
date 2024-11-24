import 'package:flutter/material.dart';
import 'package:superfitbuddy/Feed/FeedPage.dart';
import 'package:superfitbuddy/main.dart';
import 'Map/MapPage.dart';
import 'Profile/ProfilePage.dart';
import 'Profile/HelloWorldPage.dart'; // Import the new page

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void setIndexState(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index, BuildContext context) {
    setIndexState(index);

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FeedPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InteractiveMap()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 4: // Add the HelloWorldPage as a new index
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HelloWorldPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => _onItemTapped(index, context),
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.blue,
      showUnselectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.ad_units), label: 'Activité'),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Carte',
          backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        BottomNavigationBarItem(
          icon: Icon(Icons.code),
          label: 'Hello',
          backgroundColor: Colors.green,
        ), // New item for HelloWorldPage
      ],
    );
  }
}
