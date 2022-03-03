import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/controller/login_user_controller.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/utils/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    LoginUserController _loginUserController = LoginUserController();
    Usuario _usuario = Usuario();

    bool validate() {
      bool isValid = _formKey.currentState!.validate();

      if (!isValid) {
        return false;
      } else {
        return true;
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 150),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.asset(
                      'lib/images/logo.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (!value!.contains('@')) {
                        return 'O e-mail é inválido';
                      }
                      return null;
                    },
                    onChanged: (value) => _usuario.email = value,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true, //ficar com a cor branca
                      fillColor: Colors.white, //cor do fundo do campo
                      hintText: 'E-mail',
                      focusColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'A senha deve conter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                    onChanged: (value) => _usuario.password = value,
                    obscureText: true,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true, //ficar com a cor branca
                      fillColor: Colors.white, //cor do fundo do campo
                      hintText: 'Senha',
                      focusColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      bool isValid = validate();
                      if (!isValid) {
                        return;
                      }

                      await _loginUserController.login(_usuario);

                      if (_loginUserController.isSignIn) {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.home);
                      }
                    },
                    child: const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(0, 60),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.register);
                    },
                    child: const Text(
                      'Não possui uma conta? Cadastre uma',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
