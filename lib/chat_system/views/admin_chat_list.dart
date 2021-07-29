import 'package:behealthy/chat_system/controllers/chat_controller.dart';
import 'package:behealthy/chat_system/views/admin_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminChatListAll extends StatefulWidget {
  const AdminChatListAll({Key key}) : super(key: key);

  @override
  _AdminChatListAllState createState() => _AdminChatListAllState();
}

class _AdminChatListAllState extends State<AdminChatListAll> {
  ChatController chatController = Get.put(ChatController());

  Stream collectionStream =
      FirebaseFirestore.instance.collection("UID").snapshots();

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
                    chatController.adminChatScreen(userId);
                    print(userId);
                    Get.to(AdminChatScreen(), arguments: userId);
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
