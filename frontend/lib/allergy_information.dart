import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safe_dine/api_calls.dart';
//import 'package:safe_dine/sign_up.dart';
import 'package:safe_dine/user_details.dart';

class AllergyInformationScreen extends StatefulWidget {
  //final UserData userData;
  final String data;
  const AllergyInformationScreen({super.key, required this.data});

  @override
  _AllergyInformationScreenState createState() =>
      _AllergyInformationScreenState();
}

class _AllergyInformationScreenState extends State<AllergyInformationScreen> {
  List<String> _allergies = []; // This will now be populated from the backend
  List<Map<String, dynamic>> allergens = [];
  final List<String> _selectedAllergies = [];
  bool _isLoading = true; // To indicate loading state
  Future<void> sendAllergyToAPI(String UserID, int AllergenID) async {
    Map<String, dynamic> userAllergy = {
      'UserID': UserID,
      'AllergenID': AllergenID,
    };
    // dependency injection
    ApiService apiService = ApiService(); // Create an instance of ApiService

    try {
      // Call the signUp function
      var response = await apiService.saveAllergy(
          userAllergy); // 'login' is the endpoint for login // 'login' is the endpoint for login
      // String data_user = userData['email'];

      // If the API call succeeds, navigate to the next screen
      // ignore: use_build_context_synchronously
      //Navigator.pushReplacementNamed(context, '/login');
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserDetailsPage(data: UserID)),
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
  void initState() {
    super.initState();
    _fetchAllergies();
  }

// Function to get AllergenID based on Name
  int getAllergenID(String allergenName) {
    for (var allergen in allergens) {
      if (allergen['Name'] == allergenName) {
        return allergen['AllergenID'];
      }
    }
    return 0; // Return null if allergenName is not found
  }

// Fetch allergies from the backend
  Future<void> _fetchAllergies() async {
    try {
      final ApiService apiService = ApiService();
      final List<dynamic> allergies =
          await apiService.fetchAllergyInformation();

      // Extract names from the list of maps and convert them to strings
      List<String> allergyNames = allergies
          .map<String>((allergy) => allergy['Name'] as String)
          .toList();
      for (var allergy in allergies) {
        String name = allergy['Name'];
        int id = allergy['AllergenID'];
        allergens.add({'Name': name, 'AllergenID': id});
      }

      setState(() {
        _allergies = allergyNames;
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors
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
            ? Center(
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
                      if (kDebugMode) {}
                      // TODO: Implement the logic to save selected allergies to the backend or navigate as required
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
