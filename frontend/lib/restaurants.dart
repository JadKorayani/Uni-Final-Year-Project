import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_dine/api_calls.dart';
import 'package:safe_dine/selected_restaurant.dart';
//import 'package:safe_dine/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  // This list will be filled with data from your backend
  // Instantiate ApiService
  final ApiService _apiService = ApiService();
  // Create a map to store restaurant names and IDs
  final Map<String, String> restaurantMap = {};

  // This list will be filled with data from your backend
  List<String> restaurants = [];

  @override
  void initState() {
    super.initState();
    // TODO: Load restaurants from your backend and update the state
    _loadRestaurants(); // Load restaurants from backend when the screen initializes
  }

// Method to load restaurants from backend
  void _loadRestaurants() async {
    try {
      // Call your API method to fetch restaurants
      var response = await _apiService.fetchRestaurants();
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);

        // Assuming your response data is a List<List<String>> where the first sublist contains restaurant names
        // Assuming your response data is a List<List<String>> where the first sublist contains restaurant names
        final List<String> restaurantData =
            (data[0] as List<dynamic>).cast<String>();
        final List<int> restaurantIds = (data[1] as List<dynamic>)
            .cast<int>(); // Cast to List<int> instead of List<String>

// Populate the map
        for (int i = 0; i < restaurantData.length; i++) {
          restaurantMap[restaurantData[i]] =
              restaurantIds[i].toString(); // Convert int to string
        }
        print('location 1');

        setState(() {
          // Update the state with the fetched restaurant data
          restaurants = restaurantData;
        });
        print('location 2');
      } else {
        print("response is : " + response.body);
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      // Handle error if any
      print('Error fetching restaurants: $e');
      // You can show a snackbar or handle the error in a different way
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Navigate to profile or settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search restaurants, allergens,...',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (String value) {
                // TODO: Implement search functionality
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: restaurants.length, // The count of restaurants
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.yellow[700],
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(restaurants[index],
                        style: const TextStyle(color: Colors.black)),
                    onTap: () async {
                      // TODO: Navigate to restaurant details or perform other action
                      print(restaurants[index]);
                      String restName = restaurants[index];
                      String restID = restaurantMap[restName]!;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String email = prefs.getString('Email') ?? '';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectedRestaurantScreen(
                                restaurantName: restaurants[index],
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
