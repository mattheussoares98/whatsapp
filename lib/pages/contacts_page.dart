// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/provider/user_data_provider.dart';
import 'package:whatsapp/utils/app_routes.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  _loadUsers() async {
    UserDataProvider _userDataProvider = Provider.of(context, listen: false);
    await _userDataProvider.loadUsers();
  }

  @override
  void initState() {
    super.initState();

    _loadUsers();
    print('executou a atualização dos uauários');
  }

  @override
  Widget build(BuildContext context) {
    UserDataProvider _userDataProvider = Provider.of(context, listen: true);

    return _userDataProvider.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: _userDataProvider.items.length,
            itemBuilder: (context, index) {
              Usuario usuario = _userDataProvider.items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.messages,
                      arguments: usuario,
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors
                        .grey, //aparece essa cor enquanto carrega a imagem
                    backgroundImage: _userDataProvider.items[index].imageUrl ==
                                '' ||
                            _userDataProvider.items[index].imageUrl == 'http://'
                        ? null
                        : NetworkImage(_userDataProvider.items[index].imageUrl),
                    radius: 25,
                  ),
                  title: Text(
                    _userDataProvider.items[index].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          );
  }
}
