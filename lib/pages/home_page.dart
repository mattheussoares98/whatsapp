import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/pages/contacts_page.dart';
import 'package:whatsapp/pages/conversations_page.dart';
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
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('WhatsApp'),
          bottom: const TabBar(
            //onde serão colocados os "tabs", qual será o título deles e o ícone
            tabs: [
              Tab(
                child: Text(
                  'Conversas',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Contatos',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(children: [
          ConversationsPage(),
          ContactsPage(),
        ]),
      ),
    );
  }
}
