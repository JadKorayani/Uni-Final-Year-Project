// Import necessary libraries and pages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'nav_options.dart';
import 'api_calls.dart';

// StatefulWidget UserDetailsPage handles dynamic user data display
class UserDetailsPage extends StatefulWidget {
  final String data; // Identifier for the user, such as email or user ID
  const UserDetailsPage(
      {super.key, required this.data}); // Constructor requires user data

  @override
  // Create state for UserDetailsPage
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

// State class for UserDetailsPage
class _UserDetailsPageState extends State<UserDetailsPage> {
  // Variables to store user data
  String firstName = '';
  String lastName = '';
  List<String> allergies = [];

  @override
  // Initial state setup, fetches user data from the backend
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Asynchronous method to fetch user details from an API
  Future<void> fetchUserData() async {
    ApiService apiService =
        ApiService(); // Initialize ApiService to make HTTP requests
    try {
      // Make a request to fetch user details
      var response = await apiService.userdetails(widget.data);

      // Check if the response is successful.
      if (response.statusCode == 200) {
        var data = json
            .decode(response.body); // Decode JSON data from the response body
        setState(() {
          // Update state with data from the API
          firstName = data['first_name'];
          lastName = data['last_name'];
          allergies = List<String>.from(
              data['allergy']); // Convert dynamic list to a list of strings.
        });
      } else {
        // Handle unsuccessful responses
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      // Error handling, potentially logging or user feedback.
      print("Failed to fetch user data: $e");
    }
  }

  @override
  // Build the user interface for UserDetailsPage
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Welcome $firstName'), // Display user's first name in the app bar
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Placeholder function for navigation to user profile settings
            },
          ),
        ],
      ),
      drawer: const AppDrawer(), // Navigation drawer for additional options
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Static text widget displaying the app logo
            // const CircleAvatar(
            //   radius: 50.0,
            //   backgroundImage: NetworkImage(
            //       'https://github.com/JadKorayani/Uni-Final-Year-Project/blob/main/app_logo.png'),
            // ),
            const Text(
              'SafeDine',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('First Name: $firstName', // Display first name
                      style: const TextStyle(fontSize: 20.0)),
                  Text('Last Name: $lastName', // Display last name
                      style: const TextStyle(fontSize: 20.0)),
                  const SizedBox(height: 10.0),
                  const Text('Allergies:', style: TextStyle(fontSize: 20.0)),
                  // Display list of allergies
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
