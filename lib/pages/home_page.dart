import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
  }

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
      body: ElevatedButton(
        onPressed: () {
          saveInfo();
        },
        child: const Text('Salvar'),
      ),
    );
  }
}
