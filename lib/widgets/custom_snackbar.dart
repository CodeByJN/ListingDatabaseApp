import 'package:flutter/material.dart';

/// Displays a custom Snackbar with the provided message.
/// [context] is the BuildContext to show the Snackbar.
/// [message] is the text message to display.
/// [isError] (optional) defines if the Snackbar represents an error (red background).
void showCustomSnackbar(BuildContext context, String message, {bool isError = false}) {
  final color = isError ? Colors.red : Colors.green; // Error = red, Success = green
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16.0),
    duration: const Duration(seconds: 3),
  );

  // Use ScaffoldMessenger to display the Snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
