import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String compName;
  String email;
  String number;
  String state;
  String gender;
  int custId;
  int myTransId;
  User(
      {this.compName,
      this.myTransId,
      this.email,
      this.gender,
      this.number,
      this.state,
      this.custId});
}

class CustomerContractDetails {
  String planTitle;
  String title;
  int id;
  String arabicName;
  int mealType;
  CustomerContractDetails({
    this.mealType,
    this.arabicName,
    this.id,
    this.title,
    this.planTitle,
  });
}

Future<User> username() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String compName = prefs.getString('compName');
  String email = prefs.getString('email');
  String number = prefs.getString('number');
  String state = prefs.getString('state');
  String gender = prefs.getString('gender');
  int custId = prefs.getInt('custID');
  int myTransId = prefs.getInt('myTransId');
  User user = User(
    myTransId: myTransId,
      compName: compName,
      email: email,
      number: number,
      state: state,
      gender: gender,
      custId: custId);
  return user;
}

Future<CustomerContractDetails> customerContract() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String planTitle = preferences.getString('planTitle');
  String title = preferences.getString('title');
  int id = preferences.getInt('id');
  String arabicName = preferences.getString('arabicName');
  int mealType = preferences.getInt('mealType');
  CustomerContractDetails contractDetails = CustomerContractDetails(
    mealType: mealType,
    planTitle: planTitle,
    title: title,
    id: id,
    arabicName: arabicName,
  );
  return contractDetails;
}
