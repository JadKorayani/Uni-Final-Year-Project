import 'package:flutter/material.dart';
import 'package:safe_dine/sign_up.dart';
import 'package:safe_dine/user_details.dart';

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
              onPressed: () {
                // Here you would include your login logic and upon successful login, navigate to the ProfileScreen
                Navigator.pushReplacement(
                  // Using pushReplacement to prevent going back to the login screen
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserDetailsScreen()),
                );
              },
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
            OutlinedButton(
              onPressed: () {
                // TODO: Handle Google sign-up process
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
