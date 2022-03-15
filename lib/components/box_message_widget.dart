import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/model/message.dart';
import 'package:whatsapp/provider/message_provider.dart';

class BoxMessageWidget {
  Widget boxMessage({
    required BuildContext context,
    required TextEditingController boxMessageController,
    required String idLoggedUser,
    required String idRecipientUser,
    required String message,
    required MessageProvider messageProvider,
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
                  onPressed: () {
                    messageProvider.sendPhoto(
                      idLoggedUser: idLoggedUser,
                      idRecipientUser: idRecipientUser,
                    );
                  },
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
              messageProvider.sendMessage(
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
