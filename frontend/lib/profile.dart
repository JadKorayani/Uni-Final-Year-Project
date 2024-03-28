import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile - SafeDine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserProfilePage(),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  // Dummy data for user profile
  final String firstName = 'John';
  final String lastName = 'Smith';
  final List<String> allergies = [
    'Allergy 1',
    'Allergy 2',
    'Allergy 3',
    'Allergy 4'
  ];

  UserProfilePage({super.key});

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
      drawer: Drawer(
        // Populate the Drawer with navigation options
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Option 1'),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            // Add more options here
          ],
        ),
      ),
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
                  ...allergies.map((allergy) => Text(allergy)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
