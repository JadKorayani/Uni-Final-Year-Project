// Import the required packages
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = "http://192.168.0.115:8080"; // Flask API URL
  // final String urlEndpoint = "login"; // teb3at post , tjeib get,

  //  method to send data to a Flask endpoint
  Future<http.Response> postData(
      String urlEndpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$urlEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return response; // Simply return the response
  }

// Method to handle user signup
  Future<http.Response> signUp(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    if (response.statusCode == 200) {
      // Handle successful signup
      // This could involve navigating to another screen or storing user data
    } else {
      // Handle errors or unsuccessful signup
      // You might throw an exception or return a custom error message
    }
    return response; // You may choose to return a more specific result based on your app's needs
  }

  // Method to fetch allergy information
  Future<List<dynamic>> fetchAllergyInformation() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get_allergens'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Check if the body actually contains the data we expect
      var data = json.decode(response.body);
      print(data);
      if (data is List) {
        return data;
      } else {
        // Log unexpected data format
        print("Unexpected data format: ${response.body}");
        throw Exception('Invalid format of allergy information');
      }
    } else {
      // Log any non-200 responses for further investigation
      print("Failed to fetch with status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception(
          'Failed to load allergy information with status code: ${response.statusCode}');
    }
  }

// Method to handle user signup
  Future<http.Response> saveAllergy(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/save_allergy'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    if (response.statusCode == 200) {
      print('sucess');
      // Handle successful signup
      // This could involve navigating to another screen or storing user data
    } else {
      print("error");
      // Handle errors or unsuccessful signup
      // You might throw an exception or return a custom error message
    }
    return response; // You may choose to return a more specific result based on your app's needs
  }

  // Method to fetch allergy information
  Future<http.Response> userdetails(String data) async {
    final uri = Uri.parse('$_baseUrl/user_details')
        .replace(queryParameters: {'user_id': data});
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  // Method to fetch restaurants from the backend
  Future<http.Response> fetchRestaurants() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/restaurants'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      //final List<dynamic> data = json.decode(response.body);
      // Extract restaurant names from the data
      //final List<String> restaurants = List<String>.from(data);
      //print(data);
      return response;
    } else {
      // If the request fails, throw an exception
      throw Exception('Failed to fetch restaurants');
    }
  }

  // Method to send data to backend re from the backend
  Future<http.Response> fetchRightItem(String restID, String email) async {
    final uri = Uri.parse('$_baseUrl/selected_restaurant')
        .replace(queryParameters: {'restID': restID, 'email': email});
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }
}
