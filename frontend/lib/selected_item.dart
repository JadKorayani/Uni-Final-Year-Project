import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SelectedItemScreen(
        menuItemName:
            'Menu Item Name', // Replace with your actual menu item name
        menuItemDescription:
            'This is a delicious menu item.', // Replace with your actual menu item description
        menuItemPrice: '9.99', // Replace with your actual menu item price
      ),
    );
  }
}

class SelectedItemScreen extends StatelessWidget {
  final String menuItemName;
  final String menuItemDescription;
  final String menuItemPrice;

  const SelectedItemScreen({
    super.key,
    required this.menuItemName,
    required this.menuItemDescription,
    required this.menuItemPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text(menuItemName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              menuItemDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Price: $menuItemPrice',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
