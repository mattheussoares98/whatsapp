import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoxMessageWidget {
  _sendMessage({
    required String idLoggedUser,
    required String idRecipientUser,
    required Map<String, dynamic> message,
  }) {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;

    _fireStore
        .collection('messages')
        .doc(idLoggedUser)
        .collection(idRecipientUser)
        .doc()
        .set(message);
  }

  Widget boxMessage({
    required BuildContext context,
    required TextEditingController boxMessageController,
    required String idLoggedUser,
    required String idRecipientUser,
    required Map<String, dynamic> message,
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
                message: message,
              );
              boxMessageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
