// Import necessary libraries
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// AppDrawer is a stateless widget, which means its properties can't change over time.
class AppDrawer extends StatelessWidget {
  // Constructor with key to identify widget in the tree
  const AppDrawer({super.key});

  @override
  // Builds the drawer widget structure
  Widget build(BuildContext context) {
    return Drawer(
      // Drawer provides a slide-in menu from the edge of the screen
      child: ListView(
        padding:
            EdgeInsets.zero, // Removes any default padding from the ListView.
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue, // Background color of the drawer header
            ),
            child: Text('Menu'), // Text displayed in the drawer header
          ),
          // Each drawer item is created by calling _createDrawerItem method
          _createDrawerItem(
            icon: Icons.person,
            text: 'Profile',
            onTap: () => Navigator.pushNamed(context,
                '/user_details'), // Sets up navigation for the Profile item.
          ),
          _createDrawerItem(
            icon: Icons.restaurant,
            text: 'Restaurants',
            onTap: () => Navigator.pushNamed(
                context, '/restaurants'), // Navigation for Restaurants
          ),
          _createDrawerItem(
            icon: Icons.info,
            text: 'About',
            onTap: () => Navigator.pushNamed(
                context, '/about'), // Navigation for About page
          ),
          _createDrawerItem(
            icon: Icons.contact_phone,
            text: 'Contact',
            onTap: () => Navigator.pushNamed(
                context, '/contact'), // Navigation for Contact page
          ),
          _createDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Log out',
            onTap: () => _logout(context), // Navigation for logging out
          ),
        ],
      ),
    );
  }

  // Helper method to create a ListTile for the drawer items
  Widget _createDrawerItem(
      {required IconData icon, required String text, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon), // Leading icon in the list tile
      title: Text(text), // Text label in the list tile
      onTap: onTap, // Tap handler that triggers navigation
    );
  }

  void _logout(BuildContext context) async {
    // Clear user data from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('Email'); // Assume 'Email' is the key for user's email

    // Navigate to the login screen and remove all routes behind
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}
