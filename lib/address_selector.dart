import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'address_page.dart';
import 'constants.dart';
import 'package:get/get.dart';

class SelectAddressPage extends StatefulWidget {
  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  List addressList = [];
  bool _isLoading = true;
  var _currentLocation;

  @override
  void initState() {
    getAddressList();
    super.initState();
  }

  Future<void> getAddressList() async {
    var pref = await SharedPreferences.getInstance();
    var custId = pref.get('custID');
    Map<String, String> body = {
      'TenentID': TenentID.toString(),
      'CUSERID': custId.toString(),
    };

    var response = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Food/FetchAddressList'),
        body: body);
    if (response.statusCode < 299) {
      var body = jsonDecode(response.body)['data'] as List;
      List values = [];
      for (var address in body) {
        values.add(address);
      }
      setState(() {
        addressList.addAll(values);
        _isLoading = false;
      });
    }
    for (var val in addressList) {
      print(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var value = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddressPage(
                        whereToSend: true,
                      )));
          if (value != null) {
            setState(() {
              addressList.clear();
              getAddressList();
            });
          }
        },
        backgroundColor: Colors.lightGreen,
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          "add_address".tr,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 25),
              height: MediaQuery.of(context).size.height / 10,
              child: Center(
                child: RichText(
                  text: TextSpan(
                      text: 'your'.tr,
                      style: BeHealthyTheme.kMainTextStyle.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff707070)),
                      children: [
                        TextSpan(
                            text: 'addresses'.tr,
                            style: BeHealthyTheme.kMainTextStyle.copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: BeHealthyTheme.kMainOrange)),
                      ]),
                ),
              ),
            ),
            (_isLoading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : (addressList.isEmpty)
                    ? Center(
                        child: Container(
                          child: Text('empty'.tr,
                              style: BeHealthyTheme.kMainTextStyle.copyWith(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: BeHealthyTheme.kMainOrange)),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: addressList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AddressCard(
                              name: addressList[index]['GoogleName'],
                              address: addressList[index]['AddressName1'],
                              city: addressList[index]['CITY'],
                              state: addressList[index]['STATE'],
                              country: addressList[index]['STATE'],
                              onPress: () {
                                setState(() {
                                  _currentLocation = addressList[index];
                                });
                                Navigator.pop(context, addressList[index]);
                              },
                            );
                          },
                        ),
                      )
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String name;
  final String address;
  final String city;
  final String state;
  final String country;
  final Function onPress;

  AddressCard(
      {this.name,
      this.address,
      this.city,
      this.state,
      this.country,
      this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: BeHealthyTheme.kLightOrange),
        height: MediaQuery.of(context).size.height / 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: BeHealthyTheme.kMainTextStyle.copyWith(
                  fontSize: 25,
                  color: Color(0xff707070),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '$address,',
              style: BeHealthyTheme.kProfileFont.copyWith(
                  fontSize: 20,
                  color: BeHealthyTheme.kMainOrange,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '$city,',
              style: BeHealthyTheme.kProfileFont.copyWith(
                  fontSize: 20,
                  color: BeHealthyTheme.kMainOrange,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              state,
              style: BeHealthyTheme.kProfileFont.copyWith(
                  fontSize: 20,
                  color: BeHealthyTheme.kMainOrange,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
