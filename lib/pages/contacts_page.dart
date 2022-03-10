import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/model/conversations.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/provider/user_data_provider.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    UserDataProvider _userDataProvider = Provider.of(context, listen: true);

    return FutureBuilder<List<Usuario>>(
        future: _userDataProvider.loadUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors
                          .grey, //aparece essa cor enquanto carrega a imagem
                      backgroundImage:
                          NetworkImage(_userDataProvider.items[index].imageUrl),
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
        });
  }
}
