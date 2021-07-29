import 'dart:async';

import 'package:behealthy/chat_system/controllers/nutritional_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NutritionalUserChat extends StatefulWidget {
  const NutritionalUserChat({Key key}) : super(key: key);

  @override
  _NutritionalUserChatState createState() => _NutritionalUserChatState();
}

class _NutritionalUserChatState extends State<NutritionalUserChat> {
  NutritionalChatController n = Get.put(NutritionalChatController());
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
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 60),
                child: ListView.builder(
                  itemCount: n.messageList.length,
                  controller: _controller,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (n.messageList[index]['Sender'] == "user"
                            ? Alignment.topRight
                            : Alignment.topLeft),
                        // alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (n.messageList[index]['Sender'] == "user"
                                ? Color(0xffFF9629)
                                : Colors.orange.shade700),
                          ),
                          // color: Color(0xffFF9629)),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                '${n.messageList[index]['Name'].toString()}:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              Text(
                                n.messageList[index]['Message'].toString(),
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
                            n.sendMessage(message);
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
