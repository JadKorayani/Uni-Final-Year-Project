import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'nav_options.dart'; // Adjust this import as necessary.

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Contact',
      home: ContactScreen(),
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('Contact Information'),
      ),
      drawer: const AppDrawer(), // Assuming this contains your drawer widget.
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
                  path: 'contact@allergyfriendlyeats.com',
                );
                if (await canLaunchUrl(emailLaunchUri)) {
                  await launchUrl(emailLaunchUri);
                } else {
                  // ignore: use_build_context_synchronously
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
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final Uri url =
                    Uri.parse('https://www.linkedin.com/in/your-profile');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch LinkedIn')),
                  );
                }
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/linkedin-icon.svg',
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text('LinkedIn Profile'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
