import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UserImageProvider with ChangeNotifier {
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
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseStorage storage = FirebaseStorage.instance;

    _imageUrl = await storage
        .ref()
        .child('images')
        .child(auth.currentUser!.uid)
        .getDownloadURL();

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

    await uploadImage(
      selectedImage: _selectedImage!,
    );
  }

  uploadImage({
    required File selectedImage,
  }) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    _isLoadingImage = true;

    notifyListeners();

    //aqui ele faz o upload do arquivo. Antes de fazer o upload, faça o login
    UploadTask task = storage
        .ref()
        .child('images')
        .child(auth.currentUser!.uid)
        .putFile(selectedImage);

//verificar o status do upload
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');

      String progress =
          '${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %';
      print(progress);

      // Future.delayed(
      //   const Duration(seconds: 15),
      //   () {
      //     if (snapshot.state == TaskState.running) {
      //       print('retornou');
      //       return;
      //     }
      //   },
      // );
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print('task.snapshot ==== ${task.snapshot}');

      _errorMessage = e.toString();
    });

    try {
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
