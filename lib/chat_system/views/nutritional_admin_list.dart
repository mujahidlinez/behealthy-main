import 'package:behealthy/chat_system/controllers/nutritional_chat_controller.dart';
import 'package:behealthy/chat_system/views/nutritional_admin_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NutritionalAdminChatList extends StatefulWidget {
  const NutritionalAdminChatList({Key key}) : super(key: key);

  @override
  _NutritionalAdminChatListState createState() =>
      _NutritionalAdminChatListState();
}

class _NutritionalAdminChatListState extends State<NutritionalAdminChatList> {
  NutritionalChatController n = Get.put(NutritionalChatController());
  Stream collectionStream =
      FirebaseFirestore.instance.collection("NutriUID").snapshots();
  var userId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: collectionStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      userId = document.id;
                    });
                    n.adminChatScreen(userId);
                    print(userId);
                    Get.to(NutritionalAdminChatScreen(), arguments: userId);
                  },
                  child: new ListTile(
                    title: new Text('User ID:${document.id}'),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
