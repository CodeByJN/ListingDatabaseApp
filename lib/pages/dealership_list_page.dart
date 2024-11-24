import 'package:flutter/material.dart';
import '../forms/add_dealership_page.dart'; // Form for adding/editing dealerships
import '../services/database_service.dart'; // Service for database management
import '../widgets/custom_snackbar.dart'; // Widget for showing Snackbar notifications

class DealershipListPage extends StatefulWidget {
  const DealershipListPage({super.key});

  @override
  _DealershipListPageState createState() => _DealershipListPageState();
}

class _DealershipListPageState extends State<DealershipListPage> {
  final List<Map<String, String>> _dealerships = []; // List of dealerships
  final DatabaseService _databaseService = DatabaseService(); // Database service instance

  @override
  void initState() {
    super.initState();
    _loadDealerships(); // Load dealerships from the database when the page initializes
  }

  // Load dealerships from the database
  Future<void> _loadDealerships() async {
    final dealerships = await _databaseService.getAllDealerships();
    setState(() {
      _dealerships.clear();
      _dealerships.addAll(dealerships);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dealership List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: _showInstructions, // Show instructions
          ),
        ],
      ),
      body: _buildDealershipList(), // Build the list of dealerships
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddDealership, // Navigate to add dealership page
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build the dealership list widget
  Widget _buildDealershipList() {
    if (_dealerships.isEmpty) {
      return const Center(
        child: Text('No dealerships added yet. Tap "+" to add one.'), // Message when no dealerships exist
      );
    }

    return ListView.builder(
      itemCount: _dealerships.length,
      itemBuilder: (context, index) {
        final dealership = _dealerships[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            title: Text(dealership['name'] ?? ''), // Display dealership name
            subtitle: Text(
              '${dealership['address']}, ${dealership['city']} - ${dealership['zipCode']}', // Display dealership details
            ),
            onTap: () => _navigateToEditDealership(dealership, index), // Edit dealership
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteDealership(dealership['id']!, index), // Delete dealership
            ),
          ),
        );
      },
    );
  }

  // Navigate to the add dealership page
  Future<void> _navigateToAddDealership() async {
    final newDealership = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDealershipPage(),
      ),
    );

    if (newDealership != null) {
      await _databaseService.insertDealership(newDealership); // Save dealership to the database
      setState(() {
        _dealerships.add(newDealership);
      });
      showCustomSnackbar(context, 'Dealership added successfully!'); // Show success message
    }
  }

  // Navigate to the edit dealership page
  Future<void> _navigateToEditDealership(Map<String, String> dealership, int index) async {
    final updatedDealership = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDealershipPage(dealership: dealership), // Pass existing dealership to edit
      ),
    );

    if (updatedDealership != null) {
      await _databaseService.updateDealership(updatedDealership); // Update dealership in the database
      setState(() {
        _dealerships[index] = updatedDealership;
      });
      showCustomSnackbar(context, 'Dealership updated successfully!'); // Show success message
    }
  }

  // Delete a dealership
  Future<void> _deleteDealership(String id, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Dealership'),
          content: const Text('Are you sure you want to delete this dealership?'), // Confirmation message
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
      await _databaseService.deleteDealership(id); // Remove dealership from the database
      setState(() {
        _dealerships.removeAt(index); // Remove dealership from the list
      });
      showCustomSnackbar(context, 'Dealership deleted successfully!'); // Show success message
    }
  }

  // Show instructions about the page
  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text(
            'This page allows you to manage car dealerships. You can add, update, or delete dealerships.',
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
  }
}
