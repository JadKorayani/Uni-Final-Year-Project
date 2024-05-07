// Import necessary libraries and pages
import 'package:flutter/material.dart';
import 'login.dart';
import 'user_details.dart';
import 'restaurants.dart';
import 'about.dart';
import 'contact.dart';

// Entry point of the application.
void main() => runApp(const MyApp());

// MyApp is a stateless widget that configures the root of your application.
class MyApp extends StatelessWidget {
  // Constructor with optional key parameter for widget identification
  const MyApp({super.key});

  @override
  // Builds the material app with specific themes and named routes for navigation
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeDine', // App title used in task manager and app switcher
      theme: ThemeData(
        primarySwatch: Colors.blue, // Defines the color of the app theme
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Adjusts the density of the UI components based on the platform
      ),
      // Navigation control
      initialRoute: '/', // Setting the initial route for the app.
      routes: {
        '/': (context) =>
            const WelcomeScreen(), // Mapping WelcomeScreen to the root route.
        '/login': (context) => const LoginScreen(), // Route for the LoginScreen
        '/user_details': (context) => const UserDetailsPage(
            data:
                'email'), // Route for UserDetailsPage, passing 'email' as data
        '/restaurants': (context) =>
            const RestaurantsScreen(), // Route for the RestaurantsScreen
        '/about': (context) => AboutPage(), // Route for AboutPage
        '/contact': (context) => ContactScreen(), // Route for ContactScreen
      },
    );
  }
}

// WelcomeScreen widget provides the entry point view with a button to get started.
class WelcomeScreen extends StatelessWidget {
  // Constructor with optional key parameter for widget identification
  const WelcomeScreen({super.key});

  @override
  // Builds the UI components for the WelcomeScreen
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Centers the button vertically and horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // A button that, when pressed, navigates to the LoginScreen using named routing
            ElevatedButton(
              onPressed: () {
                // Uses Navigator to push the '/login' named route onto the stack
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Get started'), // Button text
            ),
          ],
        ),
      ),
    );
  }
}
