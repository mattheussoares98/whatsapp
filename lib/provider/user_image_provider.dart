// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UserImageProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isLoadingImage = false;

  bool get isLoadingImage {
    return _isLoadingImage;
  }

  String _imageUrl = '';

  String get imageUrl {
    return _imageUrl;
  }

  String _errorMessage = '';

  String get errorMessage {
    return _errorMessage;
  }

  File? _selectedImage;

  File get selectedImage {
    return _selectedImage!;
  }

  Future<String> loadCurrentUserImage() async {
    _imageUrl = 'lib/images/avatar.jpeg';
    try {
      _imageUrl = await _storage
          .ref()
          .child('images')
          .child(_auth.currentUser!.uid)
          .getDownloadURL();
    } catch (e) {
      print('erro pra carregar a imagem ======== $e');
      _imageUrl = 'lib/images/avatar.jpeg';
      notifyListeners();
    }

    notifyListeners();

    return _imageUrl;
  }

  Future takeAndUploadPicture({
    required bool isCamera,
  }) async {
    _errorMessage = '';

    notifyListeners();

    final ImagePicker _picker = ImagePicker();

    XFile? imageFile;

    if (isCamera) {
      imageFile = await _picker.pickImage(
        source: ImageSource.camera,
        //a forma como vai capturar a imagem. Nesse caso, a partir da câmera
        maxWidth: 600,
      );
    } else {
      imageFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
      );
    }

    if (imageFile == null) {
      return;
    }

    _selectedImage = File(imageFile.path);

    _isLoadingImage = true;
    notifyListeners();

    await _uploadImageToStorage(
      selectedImage: _selectedImage!,
    );

    await updateImageOnFirestore();

    _isLoadingImage = false;
    notifyListeners();
  }

  updateImageOnFirestore() async {
    await _firestore.collection('user').doc(_auth.currentUser!.uid).update(
      {
        'imageUrl': _imageUrl,
      },
    );
  }

  _uploadImageToStorage({
    required File selectedImage,
  }) async {
    //aqui ele faz o upload do arquivo. Antes de fazer o upload, faça o login
    UploadTask task = _storage
        .ref()
        .child('images')
        .child(_auth.currentUser!.uid)
        .putFile(selectedImage);

    print(selectedImage.toString());

//verificar o status do upload
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');

      String progress =
          '${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}';
      print(progress);
    }, onError: (e) {
      print('task.snapshot ==== ${task.snapshot}');

      _errorMessage = e.toString();
    });

    try {
      print('task.snapshot ========= ${task.snapshot}');

      await task;

      print('Upload complete.');
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
      print('ERRO NO UPLOAD DA FOTO. USER_IMAGE_PROVIDER.DART ===== $e');

      _isLoadingImage = false;
    } finally {
      _imageUrl = await loadCurrentUserImage();
    }

    _isLoadingImage = false;
    notifyListeners();
  }
}
