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
  List<Conversations> conversations = [
    Conversations(
      imageUrl:
          'https://a2.espncdn.com/combiner/i?img=%2Fphoto%2F2021%2F1201%2Fr944946_1296x729_16%2D9.jpg',
      userName: 'Sergio Ramos',
    ),
  ];

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
              itemCount: _userDataProvider.items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors
                          .grey, //aparece essa cor enquanto carrega a imagem
                      backgroundImage:
                          NetworkImage(conversations[index].imageUrl),
                      radius: 25,
                    ),
                    title: Text(
                      conversations[index].userName,
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
