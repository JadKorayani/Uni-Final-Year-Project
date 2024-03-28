import 'package:flutter/material.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  // This list will be filled with data from your backend
  List<String> restaurants = [];

  @override
  void initState() {
    super.initState();
    // TODO: Load restaurants from your backend and update the state
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
                    onTap: () {
                      // TODO: Navigate to restaurant details or perform other action
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
