import 'package:flutter/material.dart';

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationsPage> createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                    'https://a2.espncdn.com/combiner/i?img=%2Fphoto%2F2021%2F1201%2Fr944946_1296x729_16%2D9.jpg'),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Câmera'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Galeria'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
