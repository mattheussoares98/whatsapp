import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/pages/configurations_page.dart';
import 'package:whatsapp/pages/home_page.dart';
import 'package:whatsapp/pages/login_page.dart';
import 'package:whatsapp/pages/messages_page.dart';
import 'package:whatsapp/pages/register_page.dart';
import 'package:whatsapp/pages/splash_screen.dart';
import 'package:whatsapp/provider/message_provider.dart';
import 'package:whatsapp/provider/user_provider.dart';
import 'package:whatsapp/provider/user_image_provider.dart';
import 'package:whatsapp/utils/app_routes.dart';

void main() {
  final ThemeData theme = ThemeData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserImageProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
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
        initialRoute: AppRoutes.splashScreen,
        routes: {
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.register: (context) => const RegisterPage(),
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.configurations: (context) => const ConfigurationsPage(),
          AppRoutes.splashScreen: (context) => const SplashScreen(),
          AppRoutes.messages: (context) => const MessagesPage(),
        },
      ),
    ),
  );
}
