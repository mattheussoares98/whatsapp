import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/utils/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  saveInfo() async {
    FirebaseFirestore storage = FirebaseFirestore.instance;

    await storage.collection('x').add(
      {'nome': 'Mattheus Soares Barbosa'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('WhatsApp'),
      ),
      body: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              saveInfo();
            },
            child: const Text('Salvar'),
          ),
          ElevatedButton(
            onPressed: () async {
              FirebaseAuth auth = FirebaseAuth.instance;
              await auth.signOut();
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
