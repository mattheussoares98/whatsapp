import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/provider/user_image_provider.dart';
import 'package:whatsapp/provider/user_provider.dart';

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationsPage> createState() => _ConfigurationsPageState();
}

TextEditingController _nameController = TextEditingController();

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  bool didChange = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final UserImageProvider _userImageProvider =
        Provider.of(context, listen: false);

    final UserProvider _userDataProvider = Provider.of(context, listen: false);

    if (didChange == false &&
        _userImageProvider.imageUrl != 'lib/images/avatar.jpeg') {
      print(_userImageProvider.imageUrl);
      print('carregando imagem');
      await _userImageProvider.loadCurrentUserImage();
    }

    await _userDataProvider.getUserName();

    setState(() {
      _nameController.text = _userDataProvider.userName;
    });

    didChange = true;
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final UserImageProvider _userImageProvider =
        Provider.of(context, listen: true);

    final UserProvider _userDataProvider = Provider.of(context, listen: true);

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
                _userImageProvider.isLoadingImage
                    ? Column(
                        children: const [
                          Text(
                              'Esse processo pode ser demorado\ncaso a sua internet esteja lenta...'),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 200,
                        width: 200,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: _userImageProvider.imageUrl ==
                                  'lib/images/avatar.jpeg'
                              ? const AssetImage('lib/images/avatar.jpeg')
                                  as ImageProvider
                              : NetworkImage(_userImageProvider.imageUrl),
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
                TextField(
                  controller: _nameController,
                  enabled:
                      _userDataProvider.isLoading || _userDataProvider.isLoading
                          ? false
                          : true,
                  // onChanged: (value) {
                  //   _userName = value;
                  // },
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
                  onPressed: _userDataProvider.isLoading
                      ? null
                      : () {
                          _userDataProvider.updateNameOnFirestore(
                            _nameController.text,
                          );
                        },
                  child: _userDataProvider.isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Carregando...',
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(width: 20),
                              CircularProgressIndicator(),
                            ],
                          ),
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
