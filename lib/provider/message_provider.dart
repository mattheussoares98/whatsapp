import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/model/message.dart';

class MessageProvider with ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  sendPhoto({
    required String idLoggedUser,
    required String idRecipientUser,
  }) async {
    ImagePicker imagePicker = ImagePicker();

    XFile? _imagePicked = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (_imagePicked!.path.isEmpty) {
      return;
    }

    File selectedImage = File(_imagePicked.path);

    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

    await _firebaseStorage
        .ref('images')
        .child(idLoggedUser)
        .child(dateTime)
        .putFile(selectedImage);

    await _firebaseStorage
        .ref('images')
        .child(idRecipientUser)
        .child(dateTime)
        .putFile(selectedImage);

    Message message = Message();
    message.message = 'null';
    message.tipe = 'image';
    message.idLoggedUser = idLoggedUser;
    message.dateTime = dateTime;
    message.idRecipientUser = idRecipientUser;
    message.userName = '';
    message.imageUrl = await _firebaseStorage
        .ref('images')
        .child(idLoggedUser)
        .child(dateTime)
        .getDownloadURL();

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

    saveConversation(message: message);
  }

  sendMessage({
    required String idLoggedUser,
    required String idRecipientUser,
    required String text,
    required String imageUrl,
    required String userName,
  }) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

    Message message = Message();
    if (text.isNotEmpty) {
      message.imageUrl = imageUrl;
      message.message = text;
      message.tipe = 'text';
      message.dateTime = dateTime;
      message.idLoggedUser = idLoggedUser;
      message.idRecipientUser = idRecipientUser;
      message.userName = userName;

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

    saveConversation(
      message: message,
    );

    saveConversation(
      message: message,
    );
  }

  saveConversation({
    required Message message,
  }) async {
    await _fireStore
        .collection('conversations')
        .doc(message.idLoggedUser)
        .collection('lastConversation')
        .doc(message.idRecipientUser)
        .set(message.toMap());

    await _fireStore
        .collection('conversations')
        .doc(message.idLoggedUser)
        .collection('lastConversation')
        .doc(message.idRecipientUser)
        .set(message.toMap());
  }

  List _items = [];

  List get items {
    return _items;
  }
}
