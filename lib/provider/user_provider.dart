// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp/model/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String _userName = '';

  get userName {
    return _userName;
  }

  String? _idLoggedUser;

  get idLoggedUser {
    return _idLoggedUser;
  }

  bool _isLoading = false;

  get isLoading {
    return _isLoading;
  }

  // ignore: prefer_final_fields
  final List<UserModel> _items = [];

  List<UserModel> get items {
    return _items;
  }

  bool _signIn = false;

  bool get isSignIn {
    return _signIn;
  }

  String _errorMessage = '';

  get errorMessage {
    return _errorMessage;
  }

  bool _registered = false;

  get isRegistered {
    return _registered;
  }

  Future login(UserModel user) async {
    _isLoading = true;
    _signIn = false;
    _errorMessage = '';
    notifyListeners();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      if (userCredential.user != null) {
        _signIn = true;
      }

      _idLoggedUser = userCredential.user!.uid;
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
    UserModel user,
  ) async {
    _isLoading = true;

    _registered = false;
    _errorMessage = '';
    user.imageUrl = 'lib/images/avatar.jpeg';
    notifyListeners();

    String? userId;

    try {
      UserCredential userCredencial =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      if (userCredencial.user != null) {
        _registered = true;
      }

      if (isRegistered) {
        await _firestore
            .collection('user')
            .doc(_auth.currentUser!.uid)
            .set(user.toMap());
      }

      userId = userCredencial.user!.uid;

      //quando cria o usu??rio, tamb??m adiciona uma imagem padr??o pra ele
      await _firestore
          .collection('user')
          .doc(userId)
          .update({'imageUrl': user.imageUrl});

      //cria o caminho pra n??o dar erro
      _storage.ref().child('images').child(_auth.currentUser!.uid);
    } catch (e) {
      _changeErrorMessage(e.toString());
      print('erro no cadastro ----------> $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    //adicionando o nome e email no firestore caso d?? certo o cadastro do usu??rio

    _isLoading = false;

    notifyListeners();
  }

  _changeErrorMessage(String error) {
    if (error.contains('badly formatted')) {
      _errorMessage = 'E-mail com formato inv??lido';
    } else if (error.contains('already in use by another account')) {
      _errorMessage = 'Esse e-mail j?? foi cadastrado. Fa??a o login';
    } else if (error.contains('network error')) {
      _errorMessage = 'Verifique a sua internet';
    } else if (error.contains('password is invalid')) {
      _errorMessage = 'A senha est?? inv??lida';
    } else if (error.contains('no user record')) {
      _errorMessage = 'N??o h?? cadastro com esse e-mail';
    } else if (error.contains('have blocked all')) {
      _errorMessage = 'Login temporariamente bloqueado para o usu??rio';
    } else {
      _errorMessage = 'O banco de dados n??o permitiu seu login';
    }
  }

  getIdOfCurrentUser() {
    _idLoggedUser = _auth.currentUser!.uid;
  }

  Future<List<UserModel>> loadUsers() async {
    _isLoading = true;
    _items.clear();
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('user').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.docs;

    print('limpou a lista');
    for (QueryDocumentSnapshot<Map<String, dynamic>> itemsData in data) {
      print('executando o for');
      UserModel userModel = UserModel();

      userModel.name = itemsData.data()['name'];
      userModel.email = itemsData.data()['email'];
      userModel.imageUrl = itemsData.data()['imageUrl'];
      userModel.idUser = itemsData.id;

      DocumentSnapshot<Map<String, dynamic>> dataOfCurrentUser =
          await _firestore.collection('user').doc(_auth.currentUser!.uid).get();

      if (userModel.email == dataOfCurrentUser.data()!['email']) continue;
      //se o e-mail for igual ao do usu??rio logado, n??o adiciona na lista pro
      //usu??rio n??o conseguir abrir uma conversa com ele mesmo

      _items.add(userModel);
    }
    print('terminou de adicionar na lista');

    //se colocar um notifyListeners aqui, fica executando eternamente o for
    // notifyListeners();

    print(_items.length);
    _isLoading = false;
    notifyListeners();
    return _items;
  }

  updateNameOnFirestore(String name) async {
    _isLoading = true;
    notifyListeners();

    await _firestore.collection('user').doc(_auth.currentUser!.uid).update({
      'name': name,
    });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getUserName() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('user').doc(_auth.currentUser!.uid).get();

    Map<String, dynamic> data = snapshot.data()!;

    _userName = data['name'];
  }
}
