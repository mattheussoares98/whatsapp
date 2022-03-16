import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/components/box_message_widget.dart';
import 'package:whatsapp/components/message_widget.dart';
import 'package:whatsapp/model/user_model.dart';
import 'package:whatsapp/provider/message_provider.dart';
import 'package:whatsapp/provider/user_provider.dart';
import 'package:whatsapp/provider/user_image_provider.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

TextEditingController _textEditingController = TextEditingController();

class _MessagesPageState extends State<MessagesPage> {
  final StreamController<QuerySnapshot<Map<String, dynamic>>> _controller =
      StreamController();

  _addListener() {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;
    UserProvider _userProvider = Provider.of(context, listen: false);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var stream = firestore
        .collection('messages')
        .doc(_userProvider.idLoggedUser)
        .collection(user.idUser)
        .orderBy('dateTime', descending: true)
        .snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    UserProvider _userProvider = Provider.of(context, listen: false);

    _userProvider.getIdOfCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addListener();
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;
    UserImageProvider _userImageProvider = Provider.of(context, listen: true);
    UserProvider _userProvider = Provider.of(context, listen: true);
    MessageProvider _messageProvider = Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: user.imageUrl == 'lib/images/avatar.jpeg'
                    ? const AssetImage('lib/images/avatar.jpeg')
                        as ImageProvider
                    : NetworkImage(user.imageUrl),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(width: 10),
              Text(user.name),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: _userImageProvider.imageUrl == 'lib/images/avatar.jpeg'
                ? const AssetImage(
                    'lib/images/background_conversation_image.jpg',
                  ) as ImageProvider
                : NetworkImage(
                    _userImageProvider.imageUrl,
                  ),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MessageWidget().message(
                idLoggedUser: _userProvider.idLoggedUser,
                idRecipientUser: user.idUser,
                controller: _controller,
                scrollController: _scrollController,
              ),
              BoxMessageWidget().boxMessage(
                scrollController: _scrollController,
                boxMessageController: _textEditingController,
                context: context,
                idLoggedUser: _userProvider.idLoggedUser,
                idRecipientUser: user.idUser,
                message: _textEditingController.text,
                messageProvider: _messageProvider,
                user: user,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
