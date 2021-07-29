import 'dart:async';

import 'package:behealthy/chat_system/controllers/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserChat extends StatefulWidget {
  const UserChat({Key key}) : super(key: key);

  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  ChatController chatController = Get.put(ChatController());
  TextEditingController messageTextController = TextEditingController();
  ScrollController _controller = ScrollController();
  void getToBottom() {
    Timer(Duration(milliseconds: 300),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
  }

  @override
  void initState() {
    getToBottom();
    super.initState();
  }

  var message = '';
  @override
  Widget build(BuildContext context) {
    // _controller = ScrollController(
    //     initialScrollOffset: _controller.position.maxScrollExtent);

    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 60),
                child: ListView.builder(
                  controller: _controller,
                  itemCount: chatController.messageList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (chatController.messageList[index]
                                    ['Sender'] ==
                                "user"
                            ? Alignment.topRight
                            : Alignment.topLeft),
                        // alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (chatController.messageList[index]
                                        ['Sender'] ==
                                    "user"
                                ? Color(0xffFF9629)
                                : Colors.orange.shade700),
                          ),
                          // color: Color(0xffFF9629)),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                '${chatController.messageList[index]['Name'].toString()}:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              Text(
                                chatController.messageList[index]['Message']
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          controller: messageTextController,
                          onTap: () {
                            getToBottom();
                          },
                          onChanged: (newValue) {
                            getToBottom();
                            setState(() {
                              message = newValue;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(width: 15,),
                      FloatingActionButton(
                        onPressed: () {
                          if (message != '') {
                            chatController.sendMessage(message);
                            messageTextController.clear();
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Color(0xffFF9629),
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
