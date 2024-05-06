import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'nav_options.dart'; // Assuming this is where your AppDrawer is defined.

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact',
      home: ContactScreen(),
    );
  }
}

class ContactScreen extends StatelessWidget {
  ContactScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Use the global key here
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Contact Information'),
      ),
      drawer: const AppDrawer(), // Assuming this contains your drawer widget
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'korayanj@roehampton.ac.uk',
                );
                if (await canLaunchUrl(emailLaunchUri)) {
                  await launchUrl(emailLaunchUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch email app')),
                  );
                }
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/email-icon.svg',
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text('contact@allergyfriendlyeats.com'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
