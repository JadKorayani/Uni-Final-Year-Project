// Import necessary libraries and HTTP packages
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for the backend server; typically points to a local network during development.
  // the baseURL needs to be changed based on the generated URL from the backend
  final String _baseUrl = "http://192.168.0.115:8080";

  // set static IP address

  // Method to post data to a specified Flask API endpoint.
  Future<http.Response> postData(
      String urlEndpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$urlEndpoint'), // Construct URL with endpoint
      headers: {'Content-Type': 'application/json'}, // Set content type to JSON
      body: json.encode(data), // Convert data map to JSON string
    );
    return response; // Return HTTP response to caller
  }

  // Method to handle user signup operations by sending user data to the signup API endpoint.
  Future<http.Response> signUp(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signup'), // Construct URL for the signup endpoint
      headers: {'Content-Type': 'application/json'}, // Set content type to JSON
      body: json.encode(userData), // Encode user data as JSON string
    );
    if (response.statusCode == 200) {
      // Handle successful signup (handled in the signup page)
    } else {
      // Handle failed signup, by returning an error message on the sign up page
    }
    return response; // Return the HTTP response
  }

  // Method to fetch allergy information from the backend API.
  Future<List<dynamic>> fetchAllergyInformation() async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/get_allergens'), // Construct URL for the allergens endpoint
      headers: {'Content-Type': 'application/json'}, // Set content type to JSON
    );
    //
    if (response.statusCode == 200) {
      // Decode JSON response body and return if it is a list
      // Check if the body actually contains the data we expect
      var data = json.decode(response.body);
      if (data is List) {
        return data;
      } else {
        // Log and throw an error if data format is not as expected
        print("Unexpected data format: ${response.body}");
        throw Exception('Invalid format of allergy information');
      }
    } else {
      // Log error details and throw exception for non-200 HTTP status
      print("Failed to fetch with status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception(
          'Failed to load allergy information with status code: ${response.statusCode}');
    }
  }

  // Method to save allergy data to the backend.
  Future<http.Response> saveAllergy(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse(
          '$_baseUrl/save_allergy'), // Construct URL for the save_allergy endpoint
      headers: {'Content-Type': 'application/json'}, // Set content type to JSON
      body: json.encode(userData), // Encode allergy data as JSON string
    );
    if (response.statusCode == 200) {
      // Handle successful data saving by redirection in the signup page
    } else {
      // Handle failed operation by returning an error in the signup page
    }
    return response; // Return the HTTP response
  }

  // Method to fetch user details by user ID through a GET request
  Future<http.Response> userdetails(String data) async {
    final uri = Uri.parse(
            '$_baseUrl/user_details') // Construct URL for the user_details endpoint
        .replace(queryParameters: {
      'user_id': data
    }); // Add query parameter for user ID
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'}, // Set content type to JSON
    );
    return response; // Return the HTTP response
  }

  // Method to fetch restaurant data from the backend.
  Future<http.Response> fetchRestaurants() async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/restaurants'), // Construct URL for the restaurants endpoint
      headers: {'Content-Type': 'application/json'}, // Set content type to JSON
    );

    if (response.statusCode == 200) {
      return response; // Return the HTTP response
    } else {
      // If the request fails, throw an exception
      throw Exception('Failed to fetch restaurants');
    }
  }

  // Method to send restaurant selection and user details to the backend and fetch relevant data.
  Future<http.Response> fetchRightItem(String restID, String email) async {
    final uri = Uri.parse(
            '$_baseUrl/selected_restaurant') // Construct URL for the selected_restaurant endpoint
        .replace(queryParameters: {
      'restID': restID,
      'email': email
    }); // Add query parameters for restaurant ID and user email
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'}, // Set content type to JSON
    );
    return response; // Return the HTTP response
  }
}
