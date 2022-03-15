import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/model/user_model.dart';
import 'package:whatsapp/provider/user_provider.dart';
import 'package:whatsapp/utils/app_routes.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({Key? key}) : super(key: key);

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  _loadUsers() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.loadUsers();
  }

  @override
  void initState() {
    super.initState();
    UserProvider _userProvider = Provider.of(context, listen: false);

    _loadUsers();
    _userProvider.getIdOfCurrentUser();
    _addStream();
  }

  final StreamController<QuerySnapshot> _controller =
      //controller que será usado no stream
      StreamController<QuerySnapshot>();

  Stream _addStream() {
    //essa função precisa ser chamada no initstate pra adicionar um listen pro stream
    UserProvider _userProvider = Provider.of(context, listen: false);
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final stream = _firestore
        .collection('conversations')
        .doc(_userProvider.idLoggedUser)
        .collection('lastConversation')
        .snapshots();
    //caminho da coleção de onde quer 'escutar' as mudanças

    stream.listen(
      (QuerySnapshot<Map<String, dynamic>> data) {
        _controller.add(data);
      },
    );

    return stream;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider = Provider.of(context, listen: true);

    return StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List listItems = snapshot.hasData ? snapshot.data!.docs.toList() : [];

          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Erro');
          } else if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;

            if (querySnapshot.docs.isEmpty) {
              return const Center(
                child: Text('Não há conversas'),
              );
            }

            return ListView.builder(
              itemCount: listItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors
                        .grey, //aparece essa cor enquanto carrega a imagem
                    backgroundImage: listItems[index]['imageUrl'] == '' ||
                            listItems[index]['imageUrl'] ==
                                'lib/images/avatar.jpeg'
                        ? const AssetImage('lib/images/avatar.jpeg')
                            as ImageProvider
                        : NetworkImage(listItems[index]['imageUrl']),
                    radius: 25,
                  ),
                  title: Text(
                    listItems[index]['userName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    listItems[index]['message'],
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    UserModel user = _userProvider
                        .items[index]; //já carregou os usuários no initState
                    Navigator.of(context).pushNamed(
                      AppRoutes.messages,
                      arguments: user,
                    );
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text('Não há conversas'),
            );
          }
        });
  }
}
