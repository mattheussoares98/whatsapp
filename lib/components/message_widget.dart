import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageWidget {
  Widget message({
    required idLoggedUser,
    required idRecipientUser,
  }) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore
            .collection('messages')
            .doc(idLoggedUser)
            .collection(idRecipientUser)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          List listItems = snapshot.hasData ? snapshot.data!.docs : [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return Expanded(
              child: ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  bool messageOfCurrentUser =
                      listItems[index]['idLoggedUser'] == idLoggedUser
                          ? true
                          : false;

                  Alignment alinhamento = messageOfCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft;

                  return Container(
                    margin: messageOfCurrentUser
                        ? const EdgeInsets.only(left: 60)
                        : const EdgeInsets.only(right: 60),
                    padding: const EdgeInsets.all(4),
                    alignment: alinhamento,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      color: messageOfCurrentUser
                          ? const Color.fromARGB(255, 165, 245, 167)
                          : Colors.white,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          listItems[index]['message'],
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
          } else {
            return Text('nada pra carregar');
          }
        });
  }
}
