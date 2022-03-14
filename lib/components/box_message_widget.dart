import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/message.dart';

class BoxMessageWidget {
  _sendMessage({
    required String idLoggedUser,
    required String idRecipientUser,
    required String text,
  }) async {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;

    if (text.isNotEmpty) {
      print('executando');
      Message message = Message();
      message.imageUrl = '';
      message.message = text;
      message.tipo = 'texto';
      message.idLoggedUser = idLoggedUser;

      await _fireStore
          .collection('messages')
          .doc(idLoggedUser)
          .collection(idRecipientUser)
          .add(message.toMap());

      await _fireStore
          .collection('messages')
          .doc(idRecipientUser)
          .collection(idLoggedUser)
          .add(message.toMap());
    }
  }

  Widget boxMessage({
    required BuildContext context,
    required TextEditingController boxMessageController,
    required String idLoggedUser,
    required String idRecipientUser,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextField(
              controller: boxMessageController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: 'Digite uma mensagem...',
                filled: true,
                fillColor: Colors.white,
                focusColor: Theme.of(context).colorScheme.secondary,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            child: const Icon(Icons.send),
            mini: true,
            onPressed: () {
              _sendMessage(
                idLoggedUser: idLoggedUser,
                idRecipientUser: idRecipientUser,
                text: boxMessageController.text,
              );
              boxMessageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
