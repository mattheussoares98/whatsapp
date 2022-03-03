import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorMessage {
  showErrorMessage({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
