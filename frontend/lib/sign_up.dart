// Import necessary libraries and pages
import 'package:flutter/material.dart';
import 'package:safe_dine/allergy_information.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_calls.dart';

// StatefulWidget SignUpScreen allows for a mutable state to handle user input and response
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key}); // Constructor takes a key for the widget

  @override
  // Create state for this widget
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

// State class for SignUpScreen to handle user registration
class _SignUpScreenState extends State<SignUpScreen> {
  // Text controllers to manage form inputs
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Asynchronously sign up the user using input data
  Future<void> signupUser() async {
    // Retrieve text from controllers, ensuring it's not null by defaulting to an empty string
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // Construct data map for API call
    Map<String, dynamic> userData = {
      'first_name': firstName,
      'last_name': lastName,
      'Email': email,
      'password': password,
    };

    // Instantiate ApiService to use for the signup request
    ApiService apiService = ApiService();

    try {
      // Perform the signup via API
      var response = await apiService.signUp(userData);
      if (response.statusCode == 200) {
        // On success, store the email in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Use non-null email from userData with a default fallback
        String emailToSave = userData['Email'] ?? 'default_email@example.com';
        await prefs.setString('Email', emailToSave);
        // Navigate to the AllergyInformationScreen with the user's email.
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AllergyInformationScreen(data: emailToSave)),
        );
      } else {
        // If the server responds with an error, throw an exception.
        throw Exception(
            'Failed to sign up with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions from API call or response handling
      print("Error during signup: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Signup failed! Please try again.'),
      ));
    }
  }

  @override
  // Build the widget tree for the signup screen
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true, // Obfuscate text for password input
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: signupUser, // Trigger signup on button press
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow[700], // Text color
              ),
              child: const Text('Sign up'),
            ),
            const SizedBox(height: 16.0),
            const Center(
                child: Text('or')), // Stylistic text for alternative options.
            const SizedBox(height: 16.0),
            OutlinedButton(
              onPressed: () {
                // Placeholder for Google signup logic
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('Continue with Google'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // Clean up the controllers when the widget is disposed to avoid memory leaks
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
