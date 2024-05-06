import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_dine/api_calls.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SelectedRestaurantScreen(
        restaurantName: 'Restaurant Name',
        restaurantID: '',
        email: '',
      ),
    );
  }
}

class SelectedRestaurantScreen extends StatefulWidget {
  final String restaurantName;
  final String restaurantID;
  final String email;

  const SelectedRestaurantScreen({
    Key? key,
    required this.restaurantName,
    required this.restaurantID,
    required this.email,
  }) : super(key: key);

  @override
  _SelectedRestaurantScreenState createState() =>
      _SelectedRestaurantScreenState();
}

class _SelectedRestaurantScreenState extends State<SelectedRestaurantScreen> {
  List<String> menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    ApiService apiService = ApiService();
    try {
      var response =
          await apiService.fetchRightItem(widget.restaurantID, widget.email);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          menuItems = List<String>.from(data['menu_items']);
        });
      } else {
        print("Response error: ${response.body}");
        throw Exception('Failed to load menu items');
      }
    } catch (e) {
      print('Error loading menu items: $e');
      // Consider showing an error message or some UI indication
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.restaurantName),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onSubmitted: (String value) {
                // Implement the search logic here
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
