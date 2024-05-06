import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'nav_options.dart'; // Ensure this import is correct based on your project structure
import 'api_calls.dart';

class UserDetailsPage extends StatefulWidget {
  final String data;
  const UserDetailsPage({super.key, required this.data});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  String firstName = '';
  String lastName = '';
  List<String> allergies = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    ApiService apiService = ApiService(); // Create an instance of ApiService
    try {
      // Assume 'data' from the widget is used as a parameter in the API call
      // var response = await apiService.userdetails(widget.data);

      var response = await apiService.userdetails(widget.data);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          firstName = data['first_name'];
          lastName = data['last_name'];
          allergies = List<String>.from(data['allergy']);
        });
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      // Consider showing an error message or some UI indication
    }
  }

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
      drawer: const AppDrawer(), // Ensure this is correctly imported
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_VTsTN947wxfPvR6azPju20BotT7BNvh_VZLnjduuNQ&s'),
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
