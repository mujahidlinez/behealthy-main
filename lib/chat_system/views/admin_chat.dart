
import 'dart:async';
import 'package:behealthy/chat_system/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({Key key}) : super(key: key);

  @override
  _AdminChatScreenState createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
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
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: chatController.adminMessageList.isEmpty
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 60),
                      child: ListView.builder(
                        controller: _controller,
                        itemCount: chatController.adminMessageList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        // physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            child: Align(
                              alignment: (chatController.adminMessageList[index]
                                          ['Sender'] ==
                                      "admin"
                                  ? Alignment.topRight
                                  : Alignment.topLeft),
                              // alignment: Alignment.topLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (chatController.adminMessageList[index]
                                              ['Sender'] ==
                                          "admin"
                                      ? Color(0xffFF9629)
                                      : Colors.orange.shade700),
                                ),
                                // color: Color(0xffFF9629)),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Text(
                                      '${chatController.adminMessageList[index]['Name'].toString()}:',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      chatController.adminMessageList[index]
                                              ['Message']
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
                                onTap: () {
                                  getToBottom();
                                },
                                controller: messageTextController,
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
                            SizedBox(
                              width: 15,
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                if (message != '') {
                                  chatController.adminSendMessage(
                                      message, Get.arguments.toString());
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
