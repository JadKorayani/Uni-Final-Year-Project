// Import necessary libraries and pages
import 'package:flutter/material.dart';
import 'nav_options.dart';

// AboutPage: A stateless widget to display information about this application.
class AboutPage extends StatelessWidget {
  // Constructor: Accepts a key for this widget and forwards it to the base StatelessWidget.
  AboutPage({super.key});

  // A GlobalKey for the Scaffold widget, allowing for interaction with the Scaffold
  // from other parts of the widget tree, such as opening a drawer or showing a Snackbar.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  // The build method: Describes the part of the user interface represented by this widget.
  // Here, it creates a Scaffold, which provides a standard page layout structure.
  Widget build(BuildContext context) {
    return Scaffold(
      // The GlobalKey is passed to the Scaffold, enabling advanced control
      // over the Scaffold's behavior from anywhere in the app.
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
      drawer: const AppDrawer(),
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
              '''Welcome to SafeDine, the intuitive allergy management app designed to make dining out safe and enjoyable for everyone. 
  At SafeDine, we understand the challenges faced by those with dietary restrictions. 
  Our app provides tailored restaurant recommendations, detailed menu insights, and allergen alerts to ensure you can enjoy your meals without worry. 
  Whether you’re allergic to nuts, gluten, dairy, or any other ingredients, SafeDine helps you find safe dining options that cater to your specific needs.
  Join us on this journey towards safer dining experiences. SafeDine: Eat safely, live fully.''',
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
