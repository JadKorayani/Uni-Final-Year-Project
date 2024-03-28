import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AllergyInformationScreen extends StatefulWidget {
  const AllergyInformationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllergyInformationScreenState createState() =>
      _AllergyInformationScreenState();
}

class _AllergyInformationScreenState extends State<AllergyInformationScreen> {
  // Replace with your list of allergies
  final List<String> _allergies = ['Peanuts', 'Shellfish', 'Gluten', 'Dairy'];
  // Keeps track of selected allergies
  final List<String> _selectedAllergies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allergy Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                // TODO: Save the selected allergies and navigate to the next screen or back to profile
                // For now, we just print the selected allergies to the console
                if (kDebugMode) {
                  print(_selectedAllergies);
                }
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
