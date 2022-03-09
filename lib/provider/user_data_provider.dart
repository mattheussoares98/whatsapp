// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp/model/user.dart';

class UserDataProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _registered = false;

  get isRegistered {
    return _registered;
  }

  String _errorMessage = '';

  get errorMessage {
    return _errorMessage;
  }

  String _userName = '';

  get userName {
    return _userName;
  }

  bool _isLoading = false;

  get isLoading {
    return _isLoading;
  }

  List<Usuario> _items = [];

  List<Usuario> get items {
    return _items;
  }

  Future<List<Usuario>> loadUsers(
      // Usuario usuario
      ) async {
    items.clear();

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('user').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.docs;

    // print('data ========== ${data[0].data()}');

    for (QueryDocumentSnapshot<Map<String, dynamic>> x in data) {
      _items.add(x.data()['user']);
    }

    print(items);

    notifyListeners();
    return items;
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
    } else {
      _errorMessage = 'O banco de dados não permitiu o cadastro';
    }
  }
}
