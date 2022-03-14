import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/model/conversations.dart';
import 'package:whatsapp/provider/user_image_provider.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({Key? key}) : super(key: key);

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  List<Conversations> conversations = [
    Conversations(
      imageUrl: '',
      message: '?Hola, como estas?',
      userName: 'Sergio Ramos',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    UserImageProvider _userImageProvider = Provider.of(context, listen: true);

    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor:
                Colors.grey, //aparece essa cor enquanto carrega a imagem
            backgroundImage: _userImageProvider.imageUrl ==
                    'lib/images/avatar.jpeg'
                ? const AssetImage('lib/images/avatar.jpeg') as ImageProvider
                : NetworkImage(_userImageProvider.imageUrl),
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
