// Import necessary libraries and pages
import 'package:flutter/material.dart';
import 'package:safe_dine/sign_up.dart';
import 'package:safe_dine/user_details.dart';
import 'api_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

// Stateless widget MyApp serves as the root of your application.
class MyApp extends StatelessWidget {
  // Constructor with an optional key argument
  const MyApp({super.key});

  // Builds the MaterialApp with a theme and initial route
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeDine', // Application title
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary theme color
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Visual density adapts to platform characteristics
      ),
      home: const LoginScreen(), // Sets LoginScreen as the default home screen
    );
  }
}

// LoginScreen widget handles user authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // Creates the mutable state for the widget LoginScreen
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for text input fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Asynchronous function to handle user login
  Future<void> loginUser() async {
    // Retrieve user input from controllers
    String email = _emailController.text;
    String password = _passwordController.text;

    // User data collected from the input fields.
    Map<String, dynamic> userData = {
      'email': email,
      'password': password,
    };
    // Creates an instance of ApiService to handle API calls
    ApiService apiService = ApiService(); // Create an instance of ApiService

    try {
      // Send login data to the server and wait for a response.
      var response = await apiService.postData('login', userData);
      // Extract email for further processing
      String data_user = userData['email'];

      // If the API call succeeds, navigate to the next screen
      // ignore: use_build_context_synchronously
      //Navigator.pushReplacementNamed(context, '/login');
      if (response.statusCode == 200) {
        // Store the user's email in shared preferences for future sessions
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('Email',
            userData['email']); // Store the value with the specified key
        // Navigate to the UserDetailsPage if login is successful
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserDetailsPage(data: data_user)),
        );
      }
    } catch (e) {
      // Log any errors during the login attempt and display an error message
      print("error $e");

      // If the API call fails, show an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login failed! Please try again.'),
      ));
    }
  }

  @override
  // Builds the user interface for the login screen
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.1), // Provides spacing proportional to the screen size.
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  'https://github.com/JadKorayani/Uni-Final-Year-Project/blob/8194fd1145d79e8e91533f9de0ac442c4c046a5a/app_logo.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              'SafeDine',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold), // App name styling.
            ),
            const SizedBox(height: 8),
            const Text(
              'Discover allergy-friendly restaurants!', // Tagline or description
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Obscures text for security
            ),
            ElevatedButton(
              onPressed: loginUser, // Triggers login process on press
              child: const Text('Log in'),
            ),
            TextButton(
              // Provides an option for new users to register.
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('New User? Register Now'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // Cleans up the controllers when the widget is disposed
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
