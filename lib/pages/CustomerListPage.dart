import 'package:flutter/material.dart';
import '../models/customer.dart';
import 'package:finalproject/services/CustomerDatabase.dart';
import 'package:finalproject/forms/AddCustomerPage.dart';
import 'package:finalproject/widgets/custom_snackbar.dart';

/// Page that displays and manages the list of customers
class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

/// Handles the state and operations for the customer list
class _CustomerListPageState extends State<CustomerListPage> {
  /// List of customers to display
  final List<Customer> _customers = [];

  /// Database service for customer data operations
  final Customerdatabase _databaseService = Customerdatabase();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  /// Loads customers from database and updates the display
  Future<void> _loadCustomers() async {
    try {
      final customers = await _databaseService.getAllCustomers();
      setState(() {
        _customers.clear();
        _customers.addAll(customers.map((row) => Customer.fromMap(row)).toList());
      });
    } catch (e) {
      print('Error loading customers: $e');
      if (mounted) {
        //custom snack bar
        showCustomSnackbar(
            context,
            'Error loading customers: $e',
            isError: true
        );
      }
    }
  }

  /// Opens form to add new customer or edit existing one
  Future<void> _addOrEditCustomer({Customer? customer}) async {
    try {
      final result = await Navigator.push<Customer>(
        context,
        MaterialPageRoute(
          builder: (context) => AddCustomerPage(customer: customer),
        ),
      );

      if (result != null) {
        if (customer == null) {
          await _databaseService.insertCustomer(result.toMap());
          //custom added customer snackbar
          showCustomSnackbar(context, 'Customer added successfully');
        } else {
          await _databaseService.updateCustomer(result.toMap());
          //custom updated customer snackbar
          showCustomSnackbar(context, 'Customer updated successfully');
      }
        _loadCustomers();
      }
    } catch (e) {
      print('Error adding/editing customer: $e');
      if (mounted)  {
        showCustomSnackbar(
            context,
            'Error saving customer: $e',
            isError: true
        );
      }
    }
  }

  /// Shows confirmation dialog and deletes customer if confirmed
  Future<void> _deleteCustomer(Customer customer) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Customer'),
          content: const Text('Are you sure you want to delete this customer?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );


    if (confirm == true) {
      try {
        await _databaseService.deleteCustomer(customer.id!.toString());
        _loadCustomers();
        //successful Customer deletion
        showCustomSnackbar(context, 'Customer deleted successfully');
      } catch (e) {
        print('Error deleting customer: $e');
        if (mounted) {
          showCustomSnackbar(
              context,
              'Error deleting customer: $e',
              isError: true
          );
        }
      }
    }
  }

  /// Builds the main UI of the customer list page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Instructions'),
                    content: const Text(
                      'This page allows you to manage customers. You can add, update, or delete customers.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _buildCustomerList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue.shade100,
        onPressed: () => _addOrEditCustomer(),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  /// Builds list of customers or shows empty state message
  Widget _buildCustomerList() {
    if (_customers.isEmpty) {
      return const Center(
        child: Text('Click "+" in the bottom right to add Customers'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _customers.length,
      itemBuilder: (context, index) {
        final customer = _customers[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            title: Text('${customer.firstName} ${customer.lastName}'),
            subtitle: Text('${customer.address}, ${customer.birthday}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteCustomer(customer),
            ),
            onTap: () => _addOrEditCustomer(customer: customer),
          ),
        );
      },
    );
  }
}