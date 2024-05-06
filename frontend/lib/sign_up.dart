import 'package:flutter/material.dart';
import 'package:safe_dine/allergy_information.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_calls.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signupUser() async {
    // Ensure that all text is non-null by providing default empty strings
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    Map<String, dynamic> userData = {
      'first_name': firstName,
      'last_name': lastName,
      'Email': email,
      'password': password,
    };

    ApiService apiService = ApiService(); // Create an instance of ApiService

    try {
      var response = await apiService.signUp(userData);
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Use non-null email from userData with a default fallback
        String emailToSave = userData['Email'] ?? 'default_email@example.com';
        await prefs.setString('Email', emailToSave);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AllergyInformationScreen(data: emailToSave)),
        );
      } else {
        throw Exception(
            'Failed to sign up with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error during signup: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Signup failed! Please try again.'),
      ));
    }
  }

  @override
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
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: signupUser,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow[700], // text color
              ),
              child: const Text('Sign up'),
            ),
            const SizedBox(height: 16.0),
            const Center(child: Text('or')),
            const SizedBox(height: 16.0),
            OutlinedButton(
              onPressed: () {
                // TODO: Implement Google sign-up logic
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
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
