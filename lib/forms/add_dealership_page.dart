import 'package:flutter/material.dart';

/// A page for adding or editing dealership details.
class AddDealershipPage extends StatefulWidget {
  final Map<String, String>? dealership; // Dealership data (used for editing)

  /// Constructor accepts an optional [dealership] map for editing.
  const AddDealershipPage({super.key, this.dealership});

  @override
  _AddDealershipPageState createState() => _AddDealershipPageState();
}

class _AddDealershipPageState extends State<AddDealershipPage> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  final _nameController = TextEditingController(); // Controller for the Name field
  final _addressController = TextEditingController(); // Controller for the Address field
  final _cityController = TextEditingController(); // Controller for the City field
  final _zipCodeController = TextEditingController(); // Controller for the Zip Code field

  @override
  void initState() {
    super.initState();
    // If dealership data is provided (editing mode), pre-fill the form fields
    if (widget.dealership != null) {
      _nameController.text = widget.dealership!['name']!;
      _addressController.text = widget.dealership!['address']!;
      _cityController.text = widget.dealership!['city']!;
      _zipCodeController.text = widget.dealership!['zipCode']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title changes based on whether we're adding or editing
        title: Text(widget.dealership == null ? 'Add Dealership' : 'Edit Dealership'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Link the form to the [_formKey]
          child: Column(
            children: [
              // Name TextFormField
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name.'; // Validation message for empty fields
                  }
                  return null;
                },
              ),
              // Address TextFormField
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Street Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a street address.';
                  }
                  return null;
                },
              ),
              // City TextFormField
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city.';
                  }
                  return null;
                },
              ),
              // Zip Code TextFormField
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(labelText: 'Zip Code'),
                keyboardType: TextInputType.number, // Ensure numeric keyboard for this field
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a zip code.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20), // Add spacing before the button
              // Save Button
              ElevatedButton(
                onPressed: _saveDealership,
                // Button text changes based on whether we're adding or editing
                child: Text(widget.dealership == null ? 'Add Dealership' : 'Update Dealership'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Called when the Save button is pressed.
  ///
  /// Validates the form, creates a dealership map, and returns it to the previous page.
  void _saveDealership() {
    if (_formKey.currentState!.validate()) {
      // Collect form data into a map
      final dealership = {
        'name': _nameController.text, // Name field value
        'address': _addressController.text, // Address field value
        'city': _cityController.text, // City field value
        'zipCode': _zipCodeController.text, // Zip Code field value
      };

      // Debug print for development purposes
      debugPrint('Saving dealership: $dealership');

      // Navigate back and return the dealership data
      Navigator.pop(context, dealership);
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free resources and avoid memory leaks
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }
}
