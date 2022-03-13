// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp/model/user_model.dart';

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
  final List<UserModel> _items = [];

  List<UserModel> get items {
    return _items;
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
      userModel.idUser = itemsData.data()['idUser'];

      DocumentSnapshot<Map<String, dynamic>> dataOfCurrentUser =
          await _firestore.collection('user').doc(_auth.currentUser!.uid).get();

      if (userModel.email == dataOfCurrentUser.data()!['email']) continue;
      //se o e-mail for igual ao do usuário logado, não adiciona na lista pro
      //usuário não conseguir abrir uma conversa com ele mesmo

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
