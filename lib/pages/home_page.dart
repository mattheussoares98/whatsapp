import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/pages/contacts_page.dart';
import 'package:whatsapp/pages/conversations_page.dart';
import 'package:whatsapp/provider/user_image_provider.dart';
import 'package:whatsapp/utils/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> popUpMenuItems = const ['Configurações', 'Logout'];

  _actionsToPopUpMenuItems(String value) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (value == 'Logout') {
      await auth.signOut();
      await Future.delayed(const Duration(milliseconds: 100));
      //se não colocar a navegação pra ser executada depois de um Future.delayed,
      //não funciona a navegação
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } else if (value == 'Configurações') {
      await Future.delayed(const Duration(milliseconds: 100));
      //se não colocar a navegação pra ser executada depois de um Future.delayed,
      //não funciona a navegação
      Navigator.of(context).pushNamed(AppRoutes.configurations);
    }
  }

  @override
  void initState() {
    super.initState();
    UserImageProvider _userImageProvider = Provider.of(context, listen: false);
    _userImageProvider.loadCurrentUserImage();
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
            PopupMenuButton(
              itemBuilder: (context) {
                return popUpMenuItems
                    .map(
                      (item) => PopupMenuItem(
                        child: Text(item),
                        onTap: () => _actionsToPopUpMenuItems(item),
                      ),
                    )
                    .toList();
              },
            )
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
