import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:whatsapp/pages/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    Widget example1 = SplashScreenView(
      navigateRoute: const LoginPage(),
      duration: 5000,
      imageSize: 130,
      imageSrc: "lib/images/logo.png",
      text: "WHATS APP",
      textType: TextType.ColorizeAnimationText,
      textStyle: const TextStyle(
        fontSize: 40.0,
      ),
      colors: const [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.black12,
    );

    return Scaffold(
      body: example1,
    );
  }
}
