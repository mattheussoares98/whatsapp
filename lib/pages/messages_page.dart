import 'package:flutter/material.dart';
import 'package:whatsapp/model/user.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const Text('listview'),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
