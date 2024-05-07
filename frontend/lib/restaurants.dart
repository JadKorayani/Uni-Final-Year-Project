// Import necessary libraries and pages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_dine/api_calls.dart';
import 'package:safe_dine/selected_restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'nav_options.dart';

// StatefulWidget for managing and displaying a list of restaurants
class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen(
      {super.key}); // Constructor with key for widget tree identification.

  @override
  // Creates mutable state for this widget
  // ignore: library_private_types_in_public_api
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

// State class for RestaurantsScreen
class _RestaurantsScreenState extends State<RestaurantsScreen> {
  // GlobalKey to access and control Scaffold behavior across the app
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ApiService instance for making API calls
  final ApiService _apiService = ApiService();
  // Mapping of restaurant names to their IDs
  final Map<String, String> restaurantMap = {};
  // List to store restaurant names.
  List<String> restaurants = [];

  @override
  // Initialize state and load restaurant data
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  // Asynchronously load restaurants from the backend API
  void _loadRestaurants() async {
    try {
      // Call your API method to fetch restaurants
      var response = await _apiService
          .fetchRestaurants(); // Fetch restaurants using the ApiService
      if (response.statusCode == 200) {
        // Check for successful response.
        var data = json.decode(response.body); // Decode the JSON response

        // Convert data into lists of names and IDs
        final List<String> restaurantData =
            (data[0] as List<dynamic>).cast<String>();
        final List<int> restaurantIds = (data[1] as List<dynamic>).cast<int>();

        // Populate the restaurantMap with names and IDs
        for (int i = 0; i < restaurantData.length; i++) {
          restaurantMap[restaurantData[i]] = restaurantIds[i].toString();
        }

        // Update the UI by setting the restaurant list
        setState(() {
          restaurants = restaurantData;
        });
      } else {
        print("Failed to load data: " + response.body);
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      print('Error fetching restaurants: $e');
    }
  }

  @override
  // Build the UI for the RestaurantsScreen
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () =>
              _scaffoldKey.currentState?.openDrawer(), // Open navigation drawer
        ),
        title: const Text('Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Placeholder for navigation to profile or settingss
            },
          ),
        ],
      ),
      drawer: const AppDrawer(), // Draw navigation options
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search restaurants, allergens, ...',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (String value) {
                // Implement search functionality here
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.yellow[700], // Styling for restaurant cards
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(restaurants[index],
                        style: const TextStyle(color: Colors.black)),
                    onTap: () async {
                      // Handle tap on a restaurant.
                      String restName = restaurants[index];
                      String restID = restaurantMap[restName]!;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String email = prefs.getString('Email') ?? '';
                      // Navigate to the selected restaurant details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectedRestaurantScreen(
                                restaurantName: restName,
                                restaurantID: restID,
                                email: email)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
