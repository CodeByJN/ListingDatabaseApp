import 'package:flutter/material.dart';
import 'package:finalproject/models/customer.dart';

/// Page for adding or editing customer information
class AddCustomerPage extends StatefulWidget {
  /// Customer to edit. If null, creates a new customer.
  final Customer? customer;

  const AddCustomerPage({super.key, this.customer});

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

/// Handles the customer form state and input
class _AddCustomerPageState extends State<AddCustomerPage> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Text controllers for each input field
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fill form with existing customer data if editing
    if (widget.customer != null) {
      _firstNameController.text = widget.customer!.firstName;
      _lastNameController.text = widget.customer!.lastName;
      _addressController.text = widget.customer!.address;
      _birthdayController.text = widget.customer!.birthday;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a first name.'
                    : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a last name.' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter an address.' : null,
              ),
              TextFormField(
                controller: _birthdayController,
                decoration: const InputDecoration(labelText: 'Birthday'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a birthday.' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCustomer,
                child: Text(widget.customer == null ? 'Add Customer' : 'Update Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Saves the customer data if form is valid
  void _saveCustomer() {
    if (_formKey.currentState!.validate()) {
      final customer = Customer(
        id: widget.customer?.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        address: _addressController.text,
        birthday: _birthdayController.text,
      );

      Navigator.pop(context, customer);
    }
  }

  @override
  void dispose() {
    // Clean up the text controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }
}