import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp/model/user.dart';

class CreateUserProvider extends ChangeNotifier {
  bool _registered = false;

  get isRegistered {
    return _registered;
  }

  String _errorMessage = '';

  get errorMessage {
    return _errorMessage;
  }

  bool _isLoading = false;

  get isLoading {
    return _isLoading;
  }

  Future<void> createUser(
    Usuario usuario,
  ) async {
    _isLoading = true;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    _registered = false;
    _errorMessage = '';
    notifyListeners();

    try {
      UserCredential userCredencial = await auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.password,
      );

      if (userCredencial.user != null) {
        _registered = true;
      }
    } catch (e) {
      _changeErrorMessage(e.toString());
      print('erro no cadastro ----------> $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    //adicionando o nome e email no firestore caso dê certo o cadastro do usuário
    if (isRegistered) {
      await firestore
          .collection('user')
          .doc(auth.currentUser!.uid)
          .set(usuario.toMap());
    }

    _isLoading = false;

    notifyListeners();
  }

  _changeErrorMessage(String error) {
    if (error.contains('badly formatted')) {
      _errorMessage = 'E-mail com formato inválido';
    } else if (error.contains('already in use by another account')) {
      _errorMessage = 'Esse e-mail já foi cadastrado. Faça o login';
    } else if (error.contains('network error')) {
      _errorMessage = 'Verifique a sua internet';
    } else {
      _errorMessage = 'O banco de dados não permitiu o cadastro';
    }
  }
}
