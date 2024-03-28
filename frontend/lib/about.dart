import 'package:flutter/material.dart';
import 'nav_options.dart'; // Assuming this is where your AppDrawer is defined.

class AboutPage extends StatelessWidget {
  // Remove 'const' from here
  AboutPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Use the global key here
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Use the global key to open the drawer
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text('About'),
      ),
      drawer:
          const AppDrawer(), // Assuming AppDrawer is defined elsewhere and correctly
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'About',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'This is the About Page. Here you can add information about the app, its purpose, how to use it, or any other relevant information you wish to share with your app users.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
