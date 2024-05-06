import 'package:flutter/material.dart';
import 'package:safe_dine/sign_up.dart';
// import 'package:safe_dine/profile.dart';
import 'package:safe_dine/user_details.dart';
import 'api_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

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
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    Map<String, dynamic> userData = {
      'email': email,
      'password': password,
    };
    // dependency injection
    ApiService apiService = ApiService(); // Create an instance of ApiService

    try {
      // Call the postData function to send login data to the API endpoint
      var response = await apiService.postData('login',
          userData); // 'login' is the endpoint for login // 'login' is the endpoint for login
      String data_user = userData['email'];

      // If the API call succeeds, navigate to the next screen
      // ignore: use_build_context_synchronously
      //Navigator.pushReplacementNamed(context, '/login');
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('Email',
            userData['email']); // Store the value with the specified key
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserDetailsPage(data: data_user)),
        );
      }
    } catch (e) {
      print("error $e");

      // If the API call fails, show an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login failed! Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              child: const Text('App logo'),
            ),
            const SizedBox(height: 20),
            const Text(
              'AllergenEase',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Discover allergy-friendly restaurants!',
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
              obscureText: true,
            ),
            ElevatedButton(
              onPressed:
                  loginUser, // Call loginUser method when the button is pressed
              child: const Text('Log in'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement third-party authentication, e.g., Google
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
