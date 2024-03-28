import 'package:flutter/material.dart';
import 'login.dart';
import 'user_details.dart'; // Ensure you have this screen
import 'restaurants.dart'; // Ensure you have this screen
import 'about.dart'; // Ensure you have this screen
import 'contact.dart'; // Ensure you have this screen
// Import other screens you need for navigation

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AllergenEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Removed 'home' and replaced it with 'initialRoute' and 'routes'
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/user_details': (context) => const UserDetailsScreen(),
        '/restaurants': (context) => const RestaurantsScreen(),
        '/about': (context) => AboutPage(),
        '/contact': (context) => ContactScreen(),
        // Add more routes as needed
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Your widget code remains the same
            ElevatedButton(
              onPressed: () {
                // Updated to use named route for navigation
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Get started'),
            ),
          ],
        ),
      ),
    );
  }
}
