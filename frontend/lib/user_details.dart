import 'package:flutter/material.dart';
import 'nav_options.dart'; // Assuming you saved the AppDrawer in a separate file named app_drawer.dart

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return UserDetailsPage();
  }
}

class UserDetailsPage extends StatelessWidget {
  // Dummy data for user profile
  final String firstName = 'John';
  final String lastName = 'Smith';
  final List<String> allergies = [
    'Allergy 1',
    'Allergy 2',
    'Allergy 3',
    'Allergy 4'
  ];

  UserDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $firstName'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to user profile settings
            },
          ),
        ],
      ),
      drawer: const AppDrawer(), // Use the AppDrawer widget here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage('path_to_user_image.jpg'),
            ),
            const Text(
              'SafeDine',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('First Name: $firstName',
                      style: const TextStyle(fontSize: 20.0)),
                  Text('Last Name: $lastName',
                      style: const TextStyle(fontSize: 20.0)),
                  const SizedBox(height: 10.0),
                  const Text('Allergies:', style: TextStyle(fontSize: 20.0)),
                  ...allergies.map((allergy) => Text(allergy)).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
