import 'package:flutter/material.dart';
import 'package:whatsapp/pages/login_page.dart';

void main() {
  final ThemeData theme = ThemeData();
  runApp(
    MaterialApp(
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.green[900],
          primary: Colors.green,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    ),
  );
}
