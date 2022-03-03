import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/model/user.dart';

class LoginUserController {
  bool _signIn = false;

  bool get isSignIn {
    return _signIn;
  }

  Future login(Usuario usuario) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _signIn = false;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.password,
      );

      if (userCredential.user != null) {
        _signIn = true;
      }
    } catch (e) {
      print('erro no login -----> $e');
    }
  }
}
