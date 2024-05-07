// Import necessary libraries and pages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_dine/api_calls.dart';

// Main entry point for the Flutter application.
void main() => runApp(const MyApp());

// MyApp is the root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // Build the main MaterialApp, setting theme, title, and home page widget
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Menu', // Application's title used by the device
      theme: ThemeData(
        primarySwatch: Colors.blue, // Main color theme of the app
      ),
      // Home page widget showing selected restaurant details
      home: const SelectedRestaurantScreen(
        restaurantName:
            'Restaurant Name', // Static placeholder for restaurant name
        restaurantID: '', // Placeholder for restaurant ID
        email: '', // Placeholder for user email
      ),
    );
  }
}

// StatefulWidget for displaying a specific restaurant's menu
class SelectedRestaurantScreen extends StatefulWidget {
  final String restaurantName;
  final String restaurantID;
  final String email;
  // Constructor with required parameters and optional key
  const SelectedRestaurantScreen({
    Key? key,
    required this.restaurantName,
    required this.restaurantID,
    required this.email,
  }) : super(key: key);

  @override
  // Create state for this StatefulWidget.
  _SelectedRestaurantScreenState createState() =>
      _SelectedRestaurantScreenState();
}

// State class for managing and displaying the restaurant's menu
class _SelectedRestaurantScreenState extends State<SelectedRestaurantScreen> {
  // List to store menu items fetched from the API
  List<String> menuItems = [];

  @override
  // Initial state lifecycle method, used here to fetch menu items
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  // Asynchronous method to fetch menu items from the API
  Future<void> fetchMenuItems() async {
    ApiService apiService =
        ApiService(); // Instance of ApiService to make HTTP requests
    try {
      // Make an API request to fetch items based on restaurant ID and user email
      var response =
          await apiService.fetchRightItem(widget.restaurantID, widget.email);
      // Check if the request was successful
      if (response.statusCode == 200) {
        var data = json.decode(response.body); // Decode the JSON response
        setState(() {
          // Update the state with menu items, triggering a UI rebuild
          menuItems = List<String>.from(data['menu_items']);
        });
      } else {
        // Log and handle HTTP errors
        print("Response error: ${response.body}");
        throw Exception('Failed to load menu items');
      }
    } catch (e) {
      // Catch and log any errors encountered during the API call
      print('Error loading menu items: $e');
    }
  }

  @override
  // Build the UI of the SelectedRestaurantScreen
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(
              context), // Button to go back to the previous screen.
        ),
        title: Text(widget
            .restaurantName), // Display the name of the restaurant in the AppBar
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onSubmitted: (String value) {
                // Placeholder for implementing search within menu items
              },
              decoration: const InputDecoration(
                hintText: 'Find menu item', // Hint text for the search field
                suffixIcon: Icon(Icons.search), // Search icon in the TextField
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'What you can eat:', // Title for the list of menu items
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length, // Number of items in the list
              itemBuilder: (BuildContext context, int index) {
                // Building a list item for each menu item
                return ListTile(
                  title: Text(menuItems[index]),
                  onTap: () {
                    // Action when a menu item is tapped
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
