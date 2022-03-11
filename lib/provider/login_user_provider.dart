// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp/model/user.dart';

class LoginUserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _signIn = false;

  bool get isSignIn {
    return _signIn;
  }

  String _errorMessage = '';

  get errorMessage {
    return _errorMessage;
  }

  bool _isLoading = false;

  get isLoading {
    return _isLoading;
  }

  bool _registered = false;

  get isRegistered {
    return _registered;
  }

  Future login(Usuario usuario) async {
    _isLoading = true;
    _signIn = false;
    _errorMessage = '';
    notifyListeners();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.password,
      );

      if (userCredential.user != null) {
        _signIn = true;
      }
    } catch (e) {
      _changeErrorMessage(e.toString());
      print('erro no login -----> $e');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<void> createUser(
    Usuario usuario,
  ) async {
    _isLoading = true;

    _registered = false;
    _errorMessage = '';
    notifyListeners();

    try {
      UserCredential userCredencial =
          await _auth.createUserWithEmailAndPassword(
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
      await _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
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
    } else if (error.contains('password is invalid')) {
      _errorMessage = 'A senha está inválida';
    } else if (error.contains('no user record')) {
      _errorMessage = 'Não há cadastro com esse e-mail';
    } else if (error.contains('have blocked all')) {
      _errorMessage = 'Login temporariamente bloqueado para o usuário';
    } else {
      _errorMessage = 'O banco de dados não permitiu seu login';
    }
  }
}
