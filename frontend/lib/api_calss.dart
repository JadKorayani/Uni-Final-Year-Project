// Import the required packages
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = "http://127.0.0.1:5000"; // Flask API URL

  // Example method to fetch data from a Flask endpoint
  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('$_baseUrl/your-endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Example method to send data to a Flask endpoint
  Future<void> postData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/your-endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to post data');
    }
  }
}
