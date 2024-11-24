import 'package:flutter/material.dart';
import 'package:superfitbuddy/Feed/FeedPage.dart';
import 'package:superfitbuddy/main.dart';
import 'Profile/ProfilePage.dart';
import 'Map/MapPage.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.PageName});
  final String PageName;

  @override
  State<NavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  late List<BottomNavigationBarItem> _navBarItems;

  late final Color _iconColor = Colors.blueAccent;
  late final Color _selectedIconColor = Colors.pink;

  final List<String> _labelNames = ['Activité', 'Carte', 'Profil'];

  // Define the corresponding pages
  final List<Widget> _pages = [
    FeedPage(),
    InteractiveMap(),
    ProfilePage(),
  ];

  final List<IconData> _icons = [
    Icons.import_contacts,
    Icons.map,
    Icons.supervised_user_circle
  ];

  @override
  void initState() {
    // #2 (#1 lorsque ouverture)
    super.initState();
    print("initState");

    _updateNavBarItems();
  }

  void _updateNavBarItems() {
    print("_updateNavBarItems");
    // Update the navigation items based on the colors
    _navBarItems = List.generate(
      _labelNames.length,
      (index) => BottomNavigationBarItem(
        icon: Icon(_icons[index],
            color: ((_labelNames[index] == widget.PageName)
                ? _selectedIconColor
                : _iconColor)),
        // Colors.cyan),
        label: _labelNames[index], // Labels for each item
      ),
    );
  }

  void _onItemTapped(int index) {
    // #1
    _selectedIndex = index;
    _updateNavBarItems();

    print("_onItemTapped");

    print(widget.PageName);

    // Navigate to the corresponding page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // #2
    print("Build");
    return BottomNavigationBar(
      currentIndex: _selectedIndex, // The current selected index
      onTap: _onItemTapped, // Handle item tap
      showUnselectedLabels: true, // Show labels for unselected items
      items: _navBarItems, // Use the updated navigation items
    );
  }
}