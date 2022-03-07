import 'package:flutter/material.dart';
import 'package:whatsapp/model/conversations.dart';
import 'package:whatsapp/utils/app_routes.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({Key? key}) : super(key: key);

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

List<Conversations> conversations = [
  Conversations(
    imageUrl:
        'https://a2.espncdn.com/combiner/i?img=%2Fphoto%2F2021%2F1201%2Fr944946_1296x729_16%2D9.jpg',
    message: '?Hola, como estas?',
    userName: 'Sergio Ramos',
  ),
];

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor:
                Colors.grey, //aparece essa cor enquanto carrega a imagem
            backgroundImage: NetworkImage(conversations[index].imageUrl),
            radius: 25,
          ),
          title: Text(
            conversations[index].userName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            conversations[index].message!,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          onTap: () {},
        );
      },
    );
  }
}
