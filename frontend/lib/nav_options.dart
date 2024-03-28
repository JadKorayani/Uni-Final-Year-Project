import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          _createDrawerItem(
            icon: Icons.person,
            text: 'Profile',
            onTap: () => _navigateTo(context, '/user_details'),
          ),
          _createDrawerItem(
            icon: Icons.restaurant,
            text: 'Restaurants',
            onTap: () => _navigateTo(context, '/restaurants'),
          ),
          _createDrawerItem(
            icon: Icons.info,
            text: 'About',
            onTap: () => _navigateTo(context, '/about'),
          ),
          _createDrawerItem(
            icon: Icons.contact_phone,
            text: 'Contact',
            onTap: () => _navigateTo(context, '/contact'),
          ),
          _createDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Log out',
            onTap: () => _navigateTo(context, '/logout'),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context); // Close the drawer
    Navigator.pushNamed(context, route); // Navigate to the route
  }
}
