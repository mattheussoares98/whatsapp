import 'package:flutter/material.dart';

class MessageWidget {
  Widget message() {
    List listMessages = [
      'Bom dia',
      'Bom dia',
      'Tudo bem?',
      'Tudo sim, e com você?',
      'Estou bem também',
      'O que vai fazer hoje?',
      'Ainda não sei. E você, o que vai fazer?',
      'Eu ainda não sei também.',
      'Bora marcar alguma coisa pra fazermos juntos',
      'Bora. Eu estou com fome',
      'Podemos ir num restaurante. O que acha',
      'Boa ideia. Vamos em qual?',
      'Não sei ainda. Vamos no shopping porque tem bastante opções, aí lá escolhemos',
      'Tá bom, combinado. Que horas?',
      'Me avisa que horas posso passar aí, que passo pra gente ir',
      'Ok. Por volta das 12h pras 4 pode vir',
    ];

    return Expanded(
      child: ListView.builder(
        itemCount: listMessages.length,
        itemBuilder: (context, index) {
          bool ehPar = index % 2 == 0 ? true : false;

          Alignment alinhamento =
              ehPar ? Alignment.centerRight : Alignment.centerLeft;

          return Container(
            margin: ehPar
                ? const EdgeInsets.only(left: 60)
                : const EdgeInsets.only(right: 60),
            padding: const EdgeInsets.all(4),
            alignment: alinhamento,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              color: ehPar
                  ? const Color.fromARGB(255, 165, 245, 167)
                  : Colors.white,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  listMessages[index],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
