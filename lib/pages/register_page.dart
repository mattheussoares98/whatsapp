import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/utils/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

final _formKey = GlobalKey<FormState>();

Map _data = {
  'name': '',
  'password': '',
  'email': '',
};

Future _createUser(Usuario usuario) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  await auth.createUserWithEmailAndPassword(
    email: usuario.email,
    password: usuario.password,
  );
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    validate() {
      bool isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
    }

    Usuario usuario = Usuario();
    usuario.email = _data['email'];
    usuario.password = _data['password'];
    try {
      _createUser(usuario);
    } catch (e) {
      print('erro no login ----------> $e');
    } finally {
      Navigator.of(context).pushNamed(AppRoutes.home);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      child: Image.asset('lib/images/usuario.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: Colors.redAccent[400],
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Nome',
                    ),
                    onChanged: (value) => _data['name'] = value,
                    validator: (value) {
                      if (_data['name'].toString().length < 3) {
                        return 'O nome deve conter no mínimo 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: Colors.redAccent[400],
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'E-mail',
                    ),
                    onChanged: (value) => _data['email'] = value,
                    validator: (value) {
                      if (!value!.contains('@')) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: Colors.redAccent[400],
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Senha',
                    ),
                    obscureText: true,
                    onChanged: (value) => _data['password'] = value,
                    validator: (value) {
                      if (value!.length <= 6) {
                        return 'A senha deve conter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      validate();
                    },
                    child: const Text('Cadastrar'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(0, 55),
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
