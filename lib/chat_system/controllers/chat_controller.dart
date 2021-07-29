import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  var messageList = List.empty(growable: true).obs;
  var adminMessageList = List.empty(growable: true).obs;

  @override
  void onInit() {
    super.onInit();
    receiveMessage();
    // adminChatScreen('userID');
    // recieveAdminMessage();
  }

  sendMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> demoData = {
      "Message": message,
      "Sender": "user",
      "Name": prefs.get("compName").toString()
    };

    CollectionReference c = FirebaseFirestore.instance.collection('messages');
    DocumentReference d = FirebaseFirestore.instance.collection('messages').doc(prefs.get('custID').toString());
    d.collection('User').doc('${DateTime.now().toUtc()}').set(demoData);
    CollectionReference uid = FirebaseFirestore.instance.collection('UID');
    Map<String, dynamic> uidData = {
      "UID": prefs.get('custID').toString(),
    };

    uid.doc('${prefs.get('custID').toString()}').set(uidData);
  }

//.set(demoData);
  receiveMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference c = FirebaseFirestore.instance.collection('messages');
    c.doc(prefs.get('custID').toString()).collection('User').snapshots().listen((messages) {
      messageList.value = messages.docs;
    });
  }

  Stream<QuerySnapshot> adminMessage() {
    CollectionReference c = FirebaseFirestore.instance.collection('messages');
    return c.snapshots();
  }

  adminChatScreen(String userID) async {
    CollectionReference c = FirebaseFirestore.instance.collection('messages');
    c.doc(userID).collection('User').snapshots().listen((messages) {
      adminMessageList.value = messages.docs;
      // print(messageList.value);
    });
  }

  receiveAdminMessage() async {
    CollectionReference c = FirebaseFirestore.instance.collection('messages');

    // c.get().then((querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print('$doc');
    //     adminMessageList.add(doc);
    //   });
    // }

    // c.snapshots().listen((messages) {
    //   adminMessageList.value = messages.docChanges.toList();
    //   // messages.docs.forEach((element) {
    //   //   adminMessageList.add(element);
    //   // });
    //   print(adminMessageList.value);
    // });

    QuerySnapshot querySnapshot = await c.get();
    adminMessageList.value = querySnapshot.docs.map((e) => e.data()).toList();
    print(adminMessageList);

    // c.snapshots().listen((event) {
    //   event.docs.forEach((element) {
    //     print(element.data().toString());
    //   });
    // });
  }

  adminSendMessage(String message, String UID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> demoData = {
      "Message": message,
      "Sender": "admin",
      "Name": prefs.get("compName").toString()
    };
    CollectionReference c = FirebaseFirestore.instance.collection('messages');
    c.doc(UID).collection('User').doc('${DateTime.now().toUtc()}').set(demoData);
  }
}
