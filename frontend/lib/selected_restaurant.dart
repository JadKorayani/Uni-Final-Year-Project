import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_dine/api_calls.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
      ), // Pass your restaurant name here
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
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    ApiService apiService = ApiService(); // Create an instance of ApiService
    try {
      var response =
          await apiService.fetchRightItem(widget.restaurantID, widget.email);

      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        // Extract menu items from the response and update the state
        setState(() {
          menuItems = List<String>.from(data['menu_items']);
        });
      } else {
        print("response is : " + response.body);
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('Failed to load items: $e');
      // Consider showing an error message or some UI indication
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the restaurant list
          },
        ),
        title: Text(widget.restaurantName),
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
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
