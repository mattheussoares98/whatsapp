import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/provider/login_user_provider.dart';
import 'package:whatsapp/provider/user_image_provider.dart';

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationsPage> createState() => _ConfigurationsPageState();
}

final TextEditingController _nameController = TextEditingController();

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  bool didChange = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final UserImageProvider _userImageProvider =
        Provider.of(context, listen: false);

    if (didChange == false && _userImageProvider.imageUrl == '') {
      print('executou');
      _userImageProvider.loadCurrentUserImage();
    }

    didChange = true;
  }

  @override
  Widget build(BuildContext context) {
    final UserImageProvider _userImageProvider =
        Provider.of(context, listen: true);

    final LoginUserProvider _loginUserProvider =
        Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: _userImageProvider.isLoadingImage
                      ? const CircularProgressIndicator(
                          strokeWidth: 1,
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: _userImageProvider.imageUrl != ''
                              ? NetworkImage(_userImageProvider.imageUrl)
                              : null,
                        ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _userImageProvider.takeAndUploadPicture(
                          isCamera: true,
                        );
                      },
                      child: const Text(
                        'Câmera',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _userImageProvider.takeAndUploadPicture(
                          isCamera: false,
                        );

                        if (_userImageProvider.errorMessage != '') {}
                      },
                      child: const Text(
                        'Galeria',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _nameController,
                  enabled: _loginUserProvider.isLoading ? false : true,
                  validator: (value) {
                    // if (!value!.contains('@')) {
                    //   return 'O e-mail é inválido';
                    // } else if (value.contains(' ')) {
                    //   return 'Retire os espaços';
                    // } else if (!value.contains('.')) {
                    //   return 'E-mail inválido';
                    // }
                    // return null;
                  },
                  onChanged: (value) => _nameController.text = value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true, //ficar com a cor branca
                    fillColor: Colors.white, //cor do fundo do campo
                    hintText: 'Nome',
                    focusColor: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: _loginUserProvider.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Salvar',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(9000, 60),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
