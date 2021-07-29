import 'dart:convert';

import 'package:behealthy/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class UserProvider extends ChangeNotifier {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get phoneNumberController => _phoneNumberController;

  TextEditingController get passwordController => _passwordController;

  Future<UserModel> userLogin(String token) async {
    UserModel user;
    try {
      http.Response response = await http.post(
        Uri.parse("https://foodapi.pos53.com/api/Food/AuthenticateUser"),
        body: {
          'TenentID': TenentID.toString(),
          'EMAIL': _phoneNumberController.text,
          'CPASSWRD': _passwordController.text,
          'MOBPHONE': _phoneNumberController.text,
          'FCNToken': token,
          'action': 'AppLogin'
        },
      );

      if (response.statusCode == 200) {
        //parse user model
        user = UserModel.fromJson(json.decode(response.body));
        SharedPreferences preferences = await SharedPreferences.getInstance();
        // print(response.body);
        var data = jsonDecode(response.body);
        // await insertSynchronizationDataInDB(
        //     data['data']['COMPID']);
        // print('done');
        if (jsonDecode(response.body)['status'] == 200) {
          preferences.setString('email', user.data.eMAIL);
          preferences.setString('compName', user.data.cOMPNAME1);
          preferences.setString('number', user.data.mOBPHONE);
          preferences.setString('state', user.data.sTATE);
          preferences.setString('gender', user.data.gENDER);
          preferences.setInt('custID', user.data.cOMPID);
          //get subscription data
          //save user model
        }
      }
      notifyListeners();
      return user;
    } catch (exception) {
      print(exception);
      notifyListeners();
      return null;
    }
  }
}
