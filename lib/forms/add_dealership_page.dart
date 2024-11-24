import 'package:flutter/material.dart';

class AddDealershipPage extends StatefulWidget {
  final Map<String, String>? dealership; // Dealership data (used for editing)

  const AddDealershipPage({super.key, this.dealership});

  @override
  _AddDealershipPageState createState() => _AddDealershipPageState();
}

class _AddDealershipPageState extends State<AddDealershipPage> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.dealership != null) {
      // If editing, pre-fill the fields with dealership data
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
        title: Text(widget.dealership == null ? 'Add Dealership' : 'Edit Dealership'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name.';
                  }
                  return null;
                },
              ),
              // Street Address field
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
              // City field
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
              // Zip Code field
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(labelText: 'Zip Code'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a zip code.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Save button
              ElevatedButton(
                onPressed: _saveDealership,
                child: Text(widget.dealership == null ? 'Add Dealership' : 'Update Dealership'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveDealership() {
    if (_formKey.currentState!.validate()) {
      // Create a map with dealership data
      final dealership = {
        'name': _nameController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'zipCode': _zipCodeController.text,
      };

      // Return the data to the previous page
      Navigator.pop(context, dealership);
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }
}
