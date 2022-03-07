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

List<String> popUpMenuItems = ['Configurações', 'Logout'];

class _HomePageState extends State<HomePage> {
  _actionsToPopUpMenuItems(String value) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);

    Navigator.of(context).pushNamed(AppRoutes.configurations);
    print('teste');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.configurations);
              },
              icon: Icon(Icons.manage_accounts),
            ),
            IconButton(
              onPressed: () async {
                // FirebaseAuth auth = FirebaseAuth.instance;

                // await auth.signOut();
                // Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            ConversationsPage(),
            ContactsPage(),
          ],
        ),
      ),
    );
  }
}
