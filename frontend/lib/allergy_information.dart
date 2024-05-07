// Import necessary libraries and pages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safe_dine/api_calls.dart';
import 'package:safe_dine/user_details.dart';

// AllergyInformationScreen: A StatefulWidget that displays allergy-related information.
class AllergyInformationScreen extends StatefulWidget {
  // data: A String that holds allergy information to be displayed or processed.
  final String data;
  // Constructor: Initializes the widget with a required 'data' parameter.
  // The 'key' parameter is optional and passed to the base StatefulWidget.
  const AllergyInformationScreen({super.key, required this.data});

  @override
  // Override the createState method to initialize the state for this widget.
  // Returns an instance of _AllergyInformationScreenState.
  // ignore: library_private_types_in_public_api
  _AllergyInformationScreenState createState() =>
      _AllergyInformationScreenState();
}

class _AllergyInformationScreenState extends State<AllergyInformationScreen> {
  // List to hold allergy names fetched from the backend.
  List<String> _allergies = []; // This will now be populated from the backend
  // List to hold allergy data with names and IDs.
  List<Map<String, dynamic>> allergens = [];
  // List to track selected allergies by the user.
  final List<String> _selectedAllergies = [];
  // Boolean to indicate if the widget is in the loading state.
  bool _isLoading = true; // To indicate loading state

  // Asynchronous method to send selected allergy data to the API.
  // ignore: non_constant_identifier_names
  Future<void> sendAllergyToAPI(String UserID, int AllergenID) async {
    // Construct the userAllergy data map.
    Map<String, dynamic> userAllergy = {
      'UserID': UserID,
      'AllergenID': AllergenID,
    };

    // Creating an instance of ApiService to use its methods.
    ApiService apiService = ApiService(); // Create an instance of ApiService

    try {
      // Send user allergy information to the API and await the response.
      var response = await apiService
          .saveAllergy(userAllergy); // 'login' is the endpoint for login

      // If the API call succeeds, navigate to the next screen
      // ignore: use_build_context_synchronously
      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Navigate to UserDetailsPage upon successful response.
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => UserDetailsPage(data: UserID)),
        );
      }
    } catch (e) {
      // Log error and display a message if the API call fails.
      print("error $e");

      // If the API call fails, show an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login failed! Please try again.'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch allergy data when the widget is initialized.
    _fetchAllergies();
  }

  // Function to retrieve the AllergenID based on the allergy name.
  int getAllergenID(String allergenName) {
    for (var allergen in allergens) {
      if (allergen['Name'] == allergenName) {
        return allergen['AllergenID'];
      }
    }
    return 0; // Return null if allergenName is not found
  }

  // Asynchronous method to fetch allergies from the backend.
  Future<void> _fetchAllergies() async {
    try {
      final ApiService apiService = ApiService();
      final List<dynamic> allergies =
          await apiService.fetchAllergyInformation();

      // Convert the dynamic list to a list of strings containing only the names.
      List<String> allergyNames = allergies
          .map<String>((allergy) => allergy['Name'] as String)
          .toList();
      // Store each allergy's name and ID in the allergens list.
      for (var allergy in allergies) {
        String name = allergy['Name'];
        int id = allergy['AllergenID'];
        allergens.add({'Name': name, 'AllergenID': id});
      }

      // Update the state to display the fetched allergies and stop the loading indicator.
      setState(() {
        _allergies = allergyNames;
        _isLoading = false;
      });
    } catch (e) {
      // Log and handle errors, update the loading state.
      print('Failed to load allergies: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allergy Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child:
                    CircularProgressIndicator()) // Show a loading indicator while fetching allergies
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'What allergy do you have: (you can choose more than one)',
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _allergies.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CheckboxListTile(
                          title: Text(_allergies[index]),
                          value: _selectedAllergies.contains(_allergies[index]),
                          onChanged: (bool? value) {
                            setState(() {
                              // Update the list of selected allergies based on user interaction
                              if (value == true) {
                                _selectedAllergies.add(_allergies[index]);
                              } else {
                                _selectedAllergies.remove(_allergies[index]);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement logic to save selected allergies or navigate as required.
                      if (kDebugMode) {}
                      int allergyID = getAllergenID(_selectedAllergies.first);
                      String userEmail = widget.data;
                      sendAllergyToAPI(userEmail, allergyID);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.yellow[700], // text color
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
      ),
    );
  }
}
