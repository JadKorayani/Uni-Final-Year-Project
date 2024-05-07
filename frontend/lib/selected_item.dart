// Import necessary libraries and pages
import 'package:flutter/material.dart';

// Main entry point of the application that executes the app widget.
void main() => runApp(const MyApp());

// MyApp is a stateless widget which does not require mutable state.
class MyApp extends StatelessWidget {
  // Constructor for MyApp, optionally taking a key for widget identification.
  const MyApp({super.key});

  @override
  // Builds the main MaterialApp widget for the application
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Details', // Title of the app used in the task switcher
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary theme color
      ),
      // Sets the home property to display the SelectedItemScreen as the initial screen
      home: const SelectedItemScreen(
        menuItemName: 'Menu Item Name', // Placeholder for a menu item name
        menuItemDescription:
            'This is a delicious menu item.', // Placeholder description
        menuItemPrice: '9.99', // Placeholder for price
      ),
    );
  }
}

// SelectedItemScreen displays details about a specific menu item
class SelectedItemScreen extends StatelessWidget {
  // Fields to store menu item details
  final String menuItemName;
  final String menuItemDescription;
  final String menuItemPrice;

  // Constructor for SelectedItemScreen with required fields
  const SelectedItemScreen({
    super.key,
    required this.menuItemName,
    required this.menuItemDescription,
    required this.menuItemPrice,
  });

  @override
  // Builds the UI elements of the SelectedItemScreen
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // Returns to the previous screen when the back button is pressed
          },
        ),
        title: Text(menuItemName), // Displays the menu item name in the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Description:', // Label for the description section
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Styling for the description label
            ),
            Text(
              menuItemDescription, // Displays the description of the menu item
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium, // Styling for the description text
            ),
            Text(
              'Price: $menuItemPrice', // Displays the price of the menu item
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge, // Styling for the price text
            ),
          ],
        ),
      ),
    );
  }
}
