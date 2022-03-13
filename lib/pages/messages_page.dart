import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/components/box_message_widget.dart';
import 'package:whatsapp/components/message_widget.dart';
import 'package:whatsapp/model/user_model.dart';
import 'package:whatsapp/provider/login_user_provider.dart';
import 'package:whatsapp/provider/user_data_provider.dart';
import 'package:whatsapp/provider/user_image_provider.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

TextEditingController _textEditingController = TextEditingController();

class _MessagesPageState extends State<MessagesPage> {
  @override
  void initState() {
    super.initState();
    UserImageProvider _userImageProvider = Provider.of(context, listen: false);

    if (_userImageProvider.imageUrl == '' ||
        _userImageProvider.imageUrl == 'http://') {
      _userImageProvider.loadCurrentUserImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;
    UserImageProvider _userImageProvider = Provider.of(context, listen: true);
    LoginUserProvider _loginUserProvider = Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          CircleAvatar(
            backgroundImage: user.imageUrl == 'null'
                ? const AssetImage('lib/images/avatar.jpeg') as ImageProvider
                : NetworkImage(user.imageUrl),
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 10),
          Text(user.name),
        ],
      )),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              _userImageProvider.imageUrl,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MessageWidget().message(),
              // BoxMessageWidget().boxMessage(
              //   boxMessageController: _textEditingController,
              //   context: context,
              //   idLoggedUser: _loginUserProvider.idLoggedUser,
              //   idRecipientUser:
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
