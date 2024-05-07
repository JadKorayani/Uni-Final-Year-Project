// Import necessary libraries
import 'package:flutter/material.dart';

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
            onTap: () => _navigateTo(context, '/user_details',
                data: 'email'), // Sets up navigation for the Profile item.
          ),
          _createDrawerItem(
            icon: Icons.restaurant,
            text: 'Restaurants',
            onTap: () => _navigateTo(context, '/restaurants',
                data: ''), // Navigation for Restaurants
          ),
          _createDrawerItem(
            icon: Icons.info,
            text: 'About',
            onTap: () => _navigateTo(context, '/about',
                data: ''), // Navigation for About page
          ),
          _createDrawerItem(
            icon: Icons.contact_phone,
            text: 'Contact',
            onTap: () => _navigateTo(context, '/contact',
                data: ''), // Navigation for Contact page
          ),
          _createDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Log out',
            onTap: () => _navigateTo(context, '/logout',
                data: ''), // Navigation for logging out
          ),
        ],
      ),
    );
  }

  // Helper method to create a ListTile for the drawer items
  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon), // Leading icon in the list tile
      title: Text(text), // Text label in the list tile
      onTap: onTap, // Tap handler that triggers navigation
    );
  }

  // Navigation method to handle drawer item taps
  void _navigateTo(BuildContext context, String route, {required String data}) {
    Navigator.pop(context); // Close the drawer before navigating
    Navigator.pushNamed(context, route); // Navigate to the specified route
  }
}
