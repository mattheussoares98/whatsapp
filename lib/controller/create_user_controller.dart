import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/utils/error_message.dart';

class CreateUserController {
  bool _registered = false;

  get isRegistered {
    return _registered;
  }

  String? _error;

  get message {
    return _error;
  }

  ErrorMessage _errorMessage = ErrorMessage();

  Future<void> createUser(
    Usuario usuario,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _registered = false;

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
      print('erro no cadastro ----------> $e');
      if (e.toString().contains('badly formatted')) {
        _error = 'E-mail com formato inválido';
      }
    }
  }
}
