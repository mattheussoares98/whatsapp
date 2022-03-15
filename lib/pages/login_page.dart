import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/model/user_model.dart';
import 'package:whatsapp/provider/user_provider.dart';
import 'package:whatsapp/utils/app_routes.dart';
import 'package:whatsapp/utils/show_error_message.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _LoginPageState extends State<LoginPage> {
  bool _isValidatingCurrentUser = false;
  Future _validCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      });
    } else {
      setState(() {
        _isValidatingCurrentUser = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isValidatingCurrentUser = true;
    });
    _validCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final UserModel _user = UserModel();
  ShowErrorMessage showErrorMessage = ShowErrorMessage();

  bool validate() {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider _userDataProvider = Provider.of(context, listen: true);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: _isValidatingCurrentUser
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Validando login...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              )
            : SingleChildScrollView(
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
                          enabled: _userDataProvider.isLoading ? false : true,
                          validator: (value) {
                            if (!value!.contains('@')) {
                              return 'O e-mail é inválido';
                            } else if (value.contains(' ')) {
                              return 'Retire os espaços';
                            } else if (!value.contains('.')) {
                              return 'E-mail inválido';
                            }
                            return null;
                          },
                          onChanged: (value) => _user.email = value,
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
                          enabled: _userDataProvider.isLoading ? false : true,
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'A senha deve conter no mínimo 6 caracteres';
                            }
                            return null;
                          },
                          onChanged: (value) => _user.password = value,
                          obscureText: true,
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
                          onPressed: _userDataProvider.isLoading
                              ? null
                              : () async {
                                  bool isValid = validate();
                                  if (!isValid) {
                                    return;
                                  }

                                  await _userDataProvider.login(_user);

                                  if (_userDataProvider.isSignIn) {
                                    Navigator.of(context)
                                        .pushReplacementNamed(AppRoutes.home);
                                  } else {
                                    showErrorMessage.showErrorMessage(
                                      context: context,
                                      message: _userDataProvider.errorMessage,
                                    );
                                  }
                                },
                          child: _userDataProvider.isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
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
