import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/model/user.dart';
import 'package:whatsapp/provider/user_image_provider.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  Widget boxMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: 'Digite uma mensagem...',
                filled: true,
                fillColor: Colors.white,
                focusColor: Theme.of(context).colorScheme.secondary,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            child: const Icon(Icons.send),
            mini: true,
            onPressed: () {},
          ),
          // Flexible(
          //   flex: 30,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: SizedBox(
          //       height: 45,
          //       child: TextField(
          //         decoration: InputDecoration(
          //           filled: true,
          //           fillColor: Colors.white,
          //           focusColor: Theme.of(context).colorScheme.secondary,
          //           focusedBorder: OutlineInputBorder(
          //             borderSide: BorderSide(
          //               color: Theme.of(context).colorScheme.secondary,
          //             ),
          //             borderRadius: const BorderRadius.all(
          //               Radius.circular(40),
          //             ),
          //           ),
          //           border: const OutlineInputBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(40),
          //             ),
          //           ),
          //           prefixIcon: IconButton(
          //             onPressed: () {},
          //             icon: Icon(
          //               Icons.camera_alt,
          //               color: Theme.of(context).colorScheme.secondary,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Flexible(
          //   flex: 5,
          //   child: FloatingActionButton(
          //     child: const Icon(Icons.send),
          //     mini: true,
          //     onPressed: () {},
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    UserImageProvider _userImageProvider = Provider.of(context, listen: false);

    if (_userImageProvider.imageUrl == '' ||
        _userImageProvider.imageUrl == 'http://') {
      _userImageProvider.loadCurrentUserImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Usuario;
    UserImageProvider _userImageProvider = Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              _userImageProvider.imageUrl,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(itemBuilder: (context, index) {
                  return Container();
                }),
              ),
              boxMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
