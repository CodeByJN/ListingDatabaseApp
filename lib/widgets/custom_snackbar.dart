import 'package:flutter/material.dart';

/// Displays a custom Snackbar with a message.
///
/// - [context] is the `BuildContext` where the Snackbar will be displayed.
/// - [message] is the text message that will be shown in the Snackbar.
/// - [isError] (optional) determines if the Snackbar represents an error (default is `false`).
///   - If `isError` is `true`, the Snackbar will have a red background.
///   - If `isError` is `false`, the Snackbar will have a green background.
void showCustomSnackbar(BuildContext context, String message, {bool isError = false}) {
  // Determine the background color of the Snackbar based on the isError flag
  final color = isError ? Colors.red : Colors.green; // Red = Error, Green = Success

  // Create a Snackbar with the provided message and visual settings
  final snackBar = SnackBar(
    content: Text(
      message, // The message to display
      style: const TextStyle(color: Colors.white), // White text color for better visibility
    ),
    backgroundColor: color, // Set the background color (red or green)
    behavior: SnackBarBehavior.floating, // The Snackbar floats above the content
    margin: const EdgeInsets.all(16.0), // Adds margin around the Snackbar
    duration: const Duration(seconds: 3), // The Snackbar will stay visible for 3 seconds
  );

  // Use ScaffoldMessenger to display the Snackbar in the current context
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
