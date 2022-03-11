// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp/model/user.dart';

class UserDataProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _userName = '';

  get userName {
    return _userName;
  }

  bool _isLoading = false;

  get isLoading {
    return _isLoading;
  }

  // ignore: prefer_final_fields
  final List<Usuario> _items = [];

  List<Usuario> get items {
    return _items;
  }

  Future<List<Usuario>> loadUsers() async {
    _isLoading = true;
    _items.clear();
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('user').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.docs;

    print('limpou a lista');
    for (QueryDocumentSnapshot<Map<String, dynamic>> itemsData in data) {
      print('executando o for');
      Usuario usuario = Usuario();

      usuario.name = itemsData.data()['name'];
      usuario.email = itemsData.data()['email'];
      usuario.imageUrl = itemsData.data()['imageUrl'];

      DocumentSnapshot<Map<String, dynamic>> dataOfCurrentUser =
          await _firestore.collection('user').doc(_auth.currentUser!.uid).get();

      if (usuario.email == dataOfCurrentUser.data()!['email']) continue;
      //se o e-mail for igual ao do usuário logado, não adiciona na lista pro
      //usuário não conseguir abrir uma conversa com ele mesmo

      _items.add(usuario);
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
