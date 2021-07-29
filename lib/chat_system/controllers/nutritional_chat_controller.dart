import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NutritionalChatController extends GetxController {
  var messageList = List.empty(growable: true).obs;
  var adminMessageList = List.empty(growable: true).obs;

  @override
  void onInit() {
    super.onInit();
    receiveMessage();
  }

  sendMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> demoData = {
      "Message": message,
      "Sender": "user",
      "Name": prefs.get("compName").toString()
    };
    DocumentReference d = FirebaseFirestore.instance
        .collection('Nutrimessages')
        .doc(prefs.get('custID').toString());

    d.collection('User').doc('${DateTime.now().toUtc()}').set(demoData);

    CollectionReference uid = FirebaseFirestore.instance.collection('NutriUID');
    Map<String, dynamic> uidData = {
      "UID": prefs.get('custID').toString(),
    };

    uid.doc('${prefs.get('custID').toString()}').set(uidData);
  }

  receiveMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference c =
        FirebaseFirestore.instance.collection('Nutrimessages');
    c.doc(prefs.get('custID').toString()).collection('User').snapshots().listen(
      (messages) {
        messageList.value = messages.docs;
        // print(messageList.value);
      },
    );
  }

  adminChatScreen(String userID) async {
    CollectionReference c =
        FirebaseFirestore.instance.collection('Nutrimessages');
    c.doc(userID).collection('User').snapshots().listen((messages) {
      adminMessageList.value = messages.docs;
      // print(messageList.value);
    });
  }

  adminSendMessage(String message, String UID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> demoData = {
      "Message": message,
      "Sender": "admin",
      "Name": prefs.get("compName").toString()
    };
    CollectionReference c =
        FirebaseFirestore.instance.collection('Nutrimessages');
    c
        .doc(UID)
        .collection('User')
        .doc('${DateTime.now().toUtc()}')
        .set(demoData);
  }
}
