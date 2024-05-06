import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_dine/api_calls.dart';
import 'package:safe_dine/selected_restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'nav_options.dart'; // Assuming this is where your AppDrawer is defined

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();
  final Map<String, String> restaurantMap = {};
  List<String> restaurants = [];

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  void _loadRestaurants() async {
    try {
      // Call your API method to fetch restaurants
      var response = await _apiService.fetchRestaurants();
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        final List<String> restaurantData =
            (data[0] as List<dynamic>).cast<String>();
        final List<int> restaurantIds = (data[1] as List<dynamic>).cast<int>();

        for (int i = 0; i < restaurantData.length; i++) {
          restaurantMap[restaurantData[i]] = restaurantIds[i].toString();
        }

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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to profile or settings
            },
          ),
        ],
      ),
      drawer:
          const AppDrawer(), // Assuming this contains your navigation drawer
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
                  color: Colors.yellow[700],
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(restaurants[index],
                        style: const TextStyle(color: Colors.black)),
                    onTap: () async {
                      String restName = restaurants[index];
                      String restID = restaurantMap[restName]!;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String email = prefs.getString('Email') ?? '';
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
