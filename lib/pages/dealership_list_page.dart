import 'package:flutter/material.dart';
import '../forms/add_dealership_page.dart'; // Import for adding/editing dealership forms
import '../services/database_service.dart'; // Import for database management service
import '../widgets/custom_snackbar.dart'; // Import for displaying custom Snackbars

// Main page for managing the list of car dealerships
class DealershipListPage extends StatefulWidget {
  const DealershipListPage({super.key});

  @override
  State<DealershipListPage> createState() => _DealershipListPageState();
}

// State class to handle Dealership List functionalities
class _DealershipListPageState extends State<DealershipListPage> {
  final List<Map<String, String>> _dealerships = []; // Stores dealerships loaded from the database
  final DatabaseService _databaseService = DatabaseService(); // Instance of database service

  @override
  void initState() {
    super.initState();
    _loadDealerships(); // Load the dealerships when the page initializes
  }

  /// Fetch all dealerships from the database and update the UI
  Future<void> _loadDealerships() async {
    try {
      final dealerships = await _databaseService.getAllDealerships();
      setState(() {
        // Clear and reload the dealerships in the UI
        _dealerships.clear();
        _dealerships.addAll(dealerships.map((dealership) {
          return {
            'id': dealership['id'].toString(),
            'name': dealership['name'].toString(),
            'address': dealership['address'].toString(),
            'city': dealership['city'].toString(),
            'zipCode': dealership['zipCode'].toString(),
          };
        }));
      });
    } catch (e) {
      debugPrint('Error loading dealerships: $e'); // Print error for debugging
      showCustomSnackbar(context, 'Failed to load dealerships.', isError: true); // Show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dealership List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help), // Help icon
            onPressed: _showInstructions, // Show instructions dialog
          ),
        ],
      ),
      body: _buildDealershipList(), // Display the list of dealerships
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddDealership, // Navigate to Add Dealership form
        child: const Icon(Icons.add), // Add icon
      ),
    );
  }

  /// Build a list view to display dealerships or show a message if the list is empty
  Widget _buildDealershipList() {
    if (_dealerships.isEmpty) {
      return const Center(
        child: Text('No dealerships added yet. Tap "+" to add one.'), // Placeholder text
      );
    }

    return ListView.builder(
      itemCount: _dealerships.length, // Number of dealerships
      itemBuilder: (context, index) {
        final dealership = _dealerships[index]; // Get dealership at the current index
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            title: Text(dealership['name'] ?? 'Unnamed Dealership'), // Display name
            subtitle: Text(
              '${dealership['address']}, ${dealership['city']} - ${dealership['zipCode']}', // Address and zip code
            ),
            onTap: () => _navigateToEditDealership(dealership, index), // Edit dealership on tap
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red), // Delete icon
              onPressed: () {
                final dealershipId = dealership['id'];
                if (dealershipId != null && dealershipId.isNotEmpty) {
                  _deleteDealership(dealershipId, index); // Delete dealership
                } else {
                  showCustomSnackbar(context, 'Invalid dealership ID.', isError: true); // Show error
                }
              },
            ),
          ),
        );
      },
    );
  }

  /// Navigate to the Add Dealership form and save the new dealership
  Future<void> _navigateToAddDealership() async {
    try {
      FocusScope.of(context).unfocus(); // Remove focus from active fields
      final newDealership = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddDealershipPage(), // Navigate to Add Dealership form
        ),
      );

      if (newDealership != null) {
        await _databaseService.insertDealership(newDealership); // Save to database
        await _loadDealerships(); // Reload the list
        showCustomSnackbar(context, 'Dealership added successfully!'); // Show success message
      }
    } catch (e) {
      debugPrint('Error adding dealership: $e'); // Print error for debugging
      showCustomSnackbar(context, 'Failed to add dealership.', isError: true); // Show error message
    }
  }

  /// Navigate to the Edit Dealership form and update the dealership
  Future<void> _navigateToEditDealership(Map<String, String> dealership, int index) async {
    try {
      final updatedDealership = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddDealershipPage(dealership: dealership), // Navigate to Edit Dealership form
        ),
      );

      if (updatedDealership != null) {
        final formattedData = Map<String, String>.from(updatedDealership); // Ensure correct type
        await _databaseService.updateDealership(formattedData); // Update in database
        setState(() {
          _dealerships[index] = formattedData; // Update the UI
        });
        showCustomSnackbar(context, 'Dealership updated successfully!'); // Show success message
      }
    } catch (e) {
      debugPrint('Error editing dealership: $e'); // Print error for debugging
    }
  }

  /// Delete a dealership from the database and update the UI
  Future<void> _deleteDealership(String id, int index) async {
    try {
      await _databaseService.deleteDealership(id); // Delete from database
      setState(() {
        _dealerships.removeAt(index); // Remove from the list
      });
      showCustomSnackbar(context, 'Dealership deleted successfully!'); // Show success message
    } catch (e) {
      debugPrint('Error deleting dealership: $e'); // Print error for debugging
      showCustomSnackbar(context, 'Failed to delete dealership.', isError: true); // Show error message
    }
  }

  /// Show instructions dialog
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
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
