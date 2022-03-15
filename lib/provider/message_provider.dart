import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/model/message.dart';

class MessageProvider with ChangeNotifier {
  sendPhoto({
    required String idLoggedUser,
    required String idRecipientUser,
  }) async {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    ImagePicker imagePicker = ImagePicker();

    XFile? _imagePicked = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (_imagePicked!.path.isEmpty) {
      return;
    }

    File selectedImage = File(_imagePicked.path);

    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

    await firebaseStorage
        .ref('images')
        .child(idLoggedUser)
        .child(dateTime)
        .putFile(selectedImage);

    await firebaseStorage
        .ref('images')
        .child(idRecipientUser)
        .child(dateTime)
        .putFile(selectedImage);

    Message message = Message();
    message.message = '';
    message.tipo = 'image';
    message.idLoggedUser = idLoggedUser;
    message.dateTime = dateTime;
    message.imageUrl = await firebaseStorage
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
  }

  sendMessage({
    required String idLoggedUser,
    required String idRecipientUser,
    required String text,
  }) async {
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

    if (text.isNotEmpty) {
      Message message = Message();
      message.imageUrl = '';
      message.message = text;
      message.tipo = 'text';
      message.dateTime = dateTime;
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
      print('foi tudo');
    }
  }
}
