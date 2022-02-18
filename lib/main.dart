import 'package:flutter/material.dart';
import 'package:whatsapp/pages/home_page.dart';
import 'package:whatsapp/pages/login_page.dart';
import 'package:whatsapp/pages/register_page.dart';
import 'package:whatsapp/utils/app_routes.dart';

void main() {
  final ThemeData theme = ThemeData();

  runApp(
    MaterialApp(
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.green[900],
          primary: Colors.green,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.green[900],
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.home: (context) => const HomePage(),
      },
    ),
  );
}
