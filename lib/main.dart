import 'package:flutter/material.dart';

// Main entry point of the application
void main() {
  // Runs the MyApp widget
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  // Constructor with an optional key
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sets up the MaterialApp with a theme and home page
    return MaterialApp(
      // App title (used in device settings)
      title: 'Flutter Navigation',
      // Creates a color scheme based on deep purple
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Enables Material 3 design
        useMaterial3: true,
      ),
      // Sets the initial home page
      home: const MyHomePage(title: 'Navigation Home Page'),
    );
  }
}

// Home page of the application with navigation buttons
class MyHomePage extends StatelessWidget {
  // Constructor requiring a title
  const MyHomePage({super.key, required this.title});

  // Title of the home page
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with dynamic background color
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      // Centered column of navigation buttons
      body: Center(
        child: Column(
          // Centers buttons vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Button to navigate to Customer List page
            ElevatedButton(
              onPressed: () {
                // Uses Navigator to push a new route/page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomerListPage()),
                );
              },
              child: const Text('Customer List'),
            ),
            // Button to navigate to Car List page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CarListPage()),
                );
              },
              child: const Text('Car List'),
            ),
            // Button to navigate to Car Dealership List page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CarDealershipListPage()),
                );
              },
              child: const Text('Car-Dealership List'),
            ),
            // Button to navigate to Sales List page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SalesListPage()),
                );
              },
              child: const Text('Sales List'),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder page for Customer List
class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar for the Customer List page
      appBar: AppBar(
        title: const Text('Customer List'),
      ),
      // Placeholder center text
      body: const Center(
        child: Text('Customer List Page'),
      ),
    );
  }
}

// Placeholder page for Car List
class CarListPage extends StatelessWidget {
  const CarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar for the Car List page
      appBar: AppBar(
        title: const Text('Car List'),
      ),
      // Placeholder center text
      body: const Center(
        child: Text('Car List Page'),
      ),
    );
  }
}

// Placeholder page for Car Dealership List
class CarDealershipListPage extends StatelessWidget {
  const CarDealershipListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar for the Car Dealership List page
      appBar: AppBar(
        title: const Text('Car-Dealership List'),
      ),
      // Placeholder center text
      body: const Center(
        child: Text('Car-Dealership List Page'),
      ),
    );
  }
}

// Placeholder page for Sales List
class SalesListPage extends StatelessWidget {
  const SalesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar for the Sales List page
      appBar: AppBar(
        title: const Text('Sales List'),
      ),
      // Placeholder center text
      body: const Center(
        child: Text('Sales List Page'),
      ),
    );
  }
}