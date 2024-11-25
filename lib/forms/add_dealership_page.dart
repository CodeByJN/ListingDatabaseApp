import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// AddDealershipPage allows users to add or edit dealership information.
/// If a dealership is provided, the fields are pre-filled for editing.
/// Otherwise, users can start with a blank form or copy the last dealership's data.
class AddDealershipPage extends StatefulWidget {
  final Map<String, String>? dealership; // Dealership data passed for editing

  const AddDealershipPage({super.key, this.dealership});

  @override
  _AddDealershipPageState createState() => _AddDealershipPageState();
}

class _AddDealershipPageState extends State<AddDealershipPage> {
  // Key for form validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // If editing an existing dealership, pre-fill the form fields
    if (widget.dealership != null) {
      _nameController.text = widget.dealership!['name']!;
      _addressController.text = widget.dealership!['address']!;
      _cityController.text = widget.dealership!['city']!;
      _zipCodeController.text = widget.dealership!['zipCode']!;
    } else {
      // If adding a new dealership, load the last saved dealership data
      _loadPreviousDealership();
    }
  }

  /// Load the last saved dealership data from SharedPreferences.
  Future<void> _loadPreviousDealership() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('previous_name');
    final address = prefs.getString('previous_address');
    final city = prefs.getString('previous_city');
    final zipCode = prefs.getString('previous_zipCode');

    // If all fields exist, ask the user if they want to copy the previous data
    if (name != null && address != null && city != null && zipCode != null) {
      final copyPrevious = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Copy Previous Dealership?'),
            content: const Text(
                'Do you want to copy the information from the last dealership you added?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'), // Start with blank fields
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'), // Copy the previous dealership data
              ),
            ],
          );
        },
      );

      // If the user chooses to copy, pre-fill the fields with the saved data
      if (copyPrevious == true) {
        setState(() {
          _nameController.text = name;
          _addressController.text = address;
          _cityController.text = city;
          _zipCodeController.text = zipCode;
        });
      }
    }
  }

  /// Save the current dealership data to SharedPreferences for future use.
  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('previous_name', _nameController.text);
    await prefs.setString('previous_address', _addressController.text);
    await prefs.setString('previous_city', _cityController.text);
    await prefs.setString('previous_zipCode', _zipCodeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Show "Add Dealership" or "Edit Dealership" based on the context
        title: Text(widget.dealership == null ? 'Add Dealership' : 'Edit Dealership'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Input field for dealership name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name.'; // Validation error
                  }
                  return null; // Validation success
                },
              ),
              // Input field for dealership address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address.'; // Validation error
                  }
                  return null; // Validation success
                },
              ),
              // Input field for dealership city
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city.'; // Validation error
                  }
                  return null; // Validation success
                },
              ),
              // Input field for dealership zip code
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(labelText: 'Zip Code'),
                keyboardType: TextInputType.number, // Numeric input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a zip code.'; // Validation error
                  }
                  return null; // Validation success
                },
              ),
              const SizedBox(height: 20), // Space before the button
              // Button to save or update the dealership
              ElevatedButton(
                onPressed: _saveDealership,
                child: Text(widget.dealership == null
                    ? 'Add Dealership' // Button label for adding
                    : 'Update Dealership'), // Button label for editing
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Save the dealership data and return it to the previous screen.
  void _saveDealership() async {
    if (_formKey.currentState!.validate()) {
      // Collect dealership data into a map
      final dealership = {
        'name': _nameController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'zipCode': _zipCodeController.text,
      };

      // Save the data to SharedPreferences for future use
      await _saveToPreferences();

      // Return the dealership data to the previous screen
      Navigator.pop(context, dealership);
    }
  }

  @override
  void dispose() {
    // Dispose of the text controllers to free resources
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }
}
