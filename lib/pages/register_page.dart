import 'package:flutter/material.dart';
import 'package:whatsapp/controller/create_user_controller.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/utils/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    CreateUserController createUserController = CreateUserController();
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
                    onChanged: (value) => _usuario.name = value,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 3) {
                        return 'O nome deve conter no mínimo 3 letras';
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
                    onChanged: (value) => _usuario.email = value,
                    validator: (value) {
                      if (!value!.trim().contains('@')) {
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
                    onChanged: (value) => _usuario.password = value,
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'A senha deve conter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      bool isValid = validate();
                      if (!isValid) {
                        return;
                      }

                      await createUserController.createUser(_usuario);

                      if (createUserController.isRegistered) {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.home);
                      }
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
