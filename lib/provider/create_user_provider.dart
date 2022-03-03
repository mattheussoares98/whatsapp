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
      _registered = false;
      _changeErrorMessage(e.toString());
      print('erro no cadastro ----------> $e');
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }

  _changeErrorMessage(String error) {
    if (error.contains('badly formatted')) {
      _errorMessage = 'E-mail com formato inválido';
    } else if (error.contains('already in use by another account')) {
      _errorMessage = 'Esse e-mail já foi cadastrado';
    } else if( error.contains('network error')){
      _errorMessage = 'Verifique a sua internet';
    }
  }
}
