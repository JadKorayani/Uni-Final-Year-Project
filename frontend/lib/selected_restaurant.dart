import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SelectedRestaurantScreen(
          restaurantName: 'Restaurant Name'), // Pass your restaurant name here
    );
  }
}

class SelectedRestaurantScreen extends StatelessWidget {
  final String restaurantName;

  const SelectedRestaurantScreen({super.key, required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    // Dummy list of menu items, replace with your actual data
    final List<String> menuItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the restaurant list
          },
        ),
        title: Text(restaurantName),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onSubmitted: (String value) {
                // Implement the search logic
              },
              decoration: const InputDecoration(
                hintText: 'Find menu item',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'What you can eat:',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(menuItems[index]),
                  onTap: () {
                    // Navigate to the item menu or handle the action when tapping on an item
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
