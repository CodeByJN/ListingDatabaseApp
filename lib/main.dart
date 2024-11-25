import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../pages/dealership_list_page.dart';

void main() {
  // Initialize the FFI (Foreign Function Interface) database for compatibility with desktop platforms.
  sqfliteFfiInit();

  // Set the database factory to use the FFI implementation.
  databaseFactory = databaseFactoryFfi;

  // Launch the Flutter application.
  runApp(const MyApp());
}

// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title
      title: 'Automotive Car Sale',

      // Define the app theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true, // Use Material 3 design system
      ),

      // Set the home page of the app
      home: const MyHomePage(title: 'Automotive Car Sale'),
    );
  }
}

// Home page of the app
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner section
            AspectRatio(
              aspectRatio: 16 / 9, // Define the banner's aspect ratio
              child: Image.asset(
                'images/banner.png', // Load a banner image from assets
                fit: BoxFit.cover, // Make the image cover the entire space
              ),
            ),
            const SizedBox(height: 20),

            // Buttons grid for navigation
            Container(
              color: Colors.blueGrey.shade50, // Background color of the grid
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2, // Two buttons per row
                shrinkWrap: true, // Adjust grid height dynamically
                physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
                mainAxisSpacing: 16, // Vertical spacing
                crossAxisSpacing: 16, // Horizontal spacing
                children: [
                  // Button for navigating to the Customer List page
                  _buildMenuButton(
                    context,
                    'Customer List',
                    Icons.people,
                    const CustomerListPage(),
                  ),
                  // Button for navigating to the Car List page
                  _buildMenuButton(
                    context,
                    'Car List',
                    Icons.directions_car,
                    const CarListPage(),
                  ),
                  // Button for navigating to the Dealership List page
                  _buildMenuButton(
                    context,
                    'Dealership List',
                    Icons.store,
                    const DealershipListPage(),
                  ),
                  // Button for navigating to the Sales List page
                  _buildMenuButton(
                    context,
                    'Sales List',
                    Icons.attach_money,
                    const SalesListPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a menu button
  Widget _buildMenuButton(
      BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      // Navigate to the corresponding page when tapped
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 5, // Shadow elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding inside the button
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueGrey), // Icon
              const SizedBox(height: 10), // Spacing
              Text(
                title, // Button title
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder for the Customer List page
class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer List')), // App bar title
      body: const Center(child: Text('Customer List Page')), // Placeholder content
    );
  }
}

// Placeholder for the Car List page
class CarListPage extends StatelessWidget {
  const CarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car List')), // App bar title
      body: const Center(child: Text('Car List Page')), // Placeholder content
    );
  }
}

// Placeholder for the Sales List page
class SalesListPage extends StatelessWidget {
  const SalesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales List')), // App bar title
      body: const Center(child: Text('Sales List Page')), // Placeholder content
    );
  }
}
