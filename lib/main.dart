import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/pages/home_page.dart';
import 'package:whatsapp/pages/login_page.dart';
import 'package:whatsapp/pages/register_page.dart';
import 'package:whatsapp/provider/create_user_provider.dart';
import 'package:whatsapp/provider/login_user_provider.dart';
import 'package:whatsapp/utils/app_routes.dart';

void main() {
  final ThemeData theme = ThemeData();

  runApp(
    MultiProvider(
      providers: [
        Provider<CreateUserProvider>(create: (_) => CreateUserProvider()),
        Provider<LoginUserProvider>(create: (_) => LoginUserProvider()),
      ],
      child: MaterialApp(
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
    ),
  );
}
