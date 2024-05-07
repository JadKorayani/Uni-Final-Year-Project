// Import necessary libraries and pages
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'nav_options.dart';

// Entry point of the application, running the MyApp widget.
void main() => runApp(const MyApp());

// MyApp is a stateless widget, meaning it has no mutable state.
class MyApp extends StatelessWidget {
  // Constructor accepts a key for widget identification.
  const MyApp({super.key});

  @override
  // Build method describes the part of the user interface represented by the widget.
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'Contact', // Title for the app used by the device to identify the app.
      home:
          ContactScreen(), // The home page of the app initialized as ContactScreen widget.
    );
  }
}

// ContactScreen is a stateless widget for displaying contact information.
class ContactScreen extends StatelessWidget {
  ContactScreen({super.key});
  // GlobalKey used to access the Scaffold state from anywhere in the app.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  // Build method describes the UI structure of the ContactScreen.
  Widget build(BuildContext context) {
    return Scaffold(
      key:
          _scaffoldKey, // Use the global key for Scaffold to manage drawer and snack bar.
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu), // Icon for the drawer menu button.
          onPressed: () => _scaffoldKey.currentState
              ?.openDrawer(), // Opens the drawer when the icon is tapped.
        ),
        title: const Text('Contact Information'), // Title for the AppBar
      ),
      drawer:
          const AppDrawer(), // Drawer containing navigation options, implemented in nav_options.dart
      body: Padding(
        padding:
            const EdgeInsets.all(16.0), // Padding inside the body for spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16), // Spacer for better visual separation.
            InkWell(
              onTap: () async {
                // Gesture detector for taps on the email row.
                final Uri emailLaunchUri = Uri(
                  scheme:
                      'mailto', // URI scheme for launching an email application.
                  path: 'korayanj@roehampton.ac.uk', // Email address to be used
                );
                if (await canLaunchUrl(emailLaunchUri)) {
                  // Check if the email URL can be launched
                  await launchUrl(
                      emailLaunchUri); // Launches the email application if possible
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    // Show an error snackbar if the email app can't be launched.
                    const SnackBar(content: Text('Could not launch email app')),
                  );
                }
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/email-icon.svg', // SVG image representing an email icon
                    height: 24, // Height for the icon for uniformity
                  ),
                  const SizedBox(
                      width: 8), // Spacer between the icon and the text
                  const Text(
                      'contact@allergyfriendlyeats.com'), // Display email address text
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
