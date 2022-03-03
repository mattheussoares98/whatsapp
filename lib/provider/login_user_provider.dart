import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp/model/user.dart';

class LoginUserProvider extends ChangeNotifier {
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

  Future login(Usuario usuario) async {
    _isLoading = true;
    FirebaseAuth auth = FirebaseAuth.instance;
    _signIn = false;
    _errorMessage = '';
    notifyListeners();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.password,
      );

      if (userCredential.user != null) {
        _signIn = true;
      }
    } catch (e) {
      _changeErrorMessage(e.toString());
      print('erro no login -----> $e');
    }

    _isLoading = false;

    notifyListeners();
  }

  _changeErrorMessage(String error) {
    if (error.contains('badly formatted')) {
      _errorMessage = 'E-mail com formato inválido';
    } else if (error.contains('password is invalid')) {
      _errorMessage = 'A senha está inválida';
    } else if (error.contains('network error')) {
      _errorMessage = 'Verifique a sua internet';
    } else if (error.contains('no user record')) {
      _errorMessage = 'Não há cadastro com esse e-mail';
    }
  }
}
