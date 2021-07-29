import 'dart:convert';
import 'package:behealthy/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController compName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  // TextEditingController countryId = TextEditingController();
  // TextEditingController state = TextEditingController();
  String add = 'ADD';
  List<bool> genderSelected = [true, false] ;

  List<StateData> stateList = [];
  List<DropdownMenuItem> menuItems = [];
  int _value = 0;

  List cityList = [];
  List<DropdownMenuItem> cityListItems = [];
  int _cityValue = 0;

  @override
  void initState() {
    getStateList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    compName.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    // countryId.dispose();
    // state.dispose();
    // gender.dispose();
  }

  Future getStateList() async {
    var response = await http
        .post(Uri.parse('https://foodapi.pos53.com/api/Food/DeliveryStateGet'));

    List<StateData> statesToAdd = [];
    List<DropdownMenuItem> itemList = [];

    if (response.statusCode <= 299) {
      var body = jsonDecode(response.body)['data'];
      int index = 0;
      for (var state in body) {
        var newState =
        StateData(state['StateName'] as String, state['StateID']);
        statesToAdd.add(newState);
        itemList.add(DropdownMenuItem(
          child: Text(
            state['StateName'] as String,
            style: TextStyle(color: BeHealthyTheme.kMainOrange),
          ),
          value: index,
        ));
        index++;
      }
    }

    setState(() {
      if (statesToAdd.isNotEmpty) {
        stateList.addAll(statesToAdd);
        menuItems.addAll(itemList);
      }
    });
    getCityList();
  }

  Future<void> getCityList() async {
    var stateId = stateList[_value].stateId;
    var cities = [];
    List<DropdownMenuItem> cityItems = [];
    var response = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Food/DeliveryCityGet'),
        body: {'StateID': stateId.toString()});
    print(response.statusCode);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body['data']);
      int i = 0;
      for (var city in body['data']) {
        cities.add(city['CityEnglish']);
        cityItems.add(DropdownMenuItem(
          child: Text(
            city['CityEnglish'],
            style: TextStyle(color: BeHealthyTheme.kMainOrange),
          ),
          value: i,
        ));
        i++;
        print(city);
      }
    }

    setState(() {
      if (cities.isNotEmpty) {
        if (cityList.isNotEmpty) {
          cityList.clear();
          cityListItems.clear();
        }
        cityList.addAll(cities);
        cityListItems.addAll(cityItems);
      }
    });
    print(cityList);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BeHealthyTheme.kMainOrange,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: TextFormField(
                    controller: compName,
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 1, color: BeHealthyTheme.kMainOrange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 2, color: BeHealthyTheme.kMainOrange),
                        ),
                        labelText: "full_name".tr,
                        labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 1, color: BeHealthyTheme.kMainOrange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 2, color: BeHealthyTheme.kMainOrange),
                        ),
                        labelText: "email_address".tr,
                        labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: TextFormField(
                    controller: phone,
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 1, color: BeHealthyTheme.kMainOrange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 2, color: BeHealthyTheme.kMainOrange),
                        ),
                        labelText: "phone_number".tr,
                        labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: TextFormField(
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 1, color: BeHealthyTheme.kMainOrange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                              width: 2, color: BeHealthyTheme.kMainOrange),
                        ),
                        labelText: "password".tr,
                        labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: BeHealthyTheme.kLightOrange),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      focusColor: BeHealthyTheme.kMainOrange,
                      hint: Text('your_state'.tr),
                      value: _value,
                      items: (stateList.isEmpty) ? [] : menuItems,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                          _cityValue = 0;
                        });
                        getCityList();
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 100,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: BeHealthyTheme.kLightOrange),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      focusColor: BeHealthyTheme.kMainOrange,
                      hint: Text('your_city'.tr),
                      value: _cityValue,
                      items: (cityListItems.isEmpty) ? [] : cityListItems,
                      onChanged: (value) {
                        setState(() {
                          _cityValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(25),
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Male'),
                            Icon(Icons.male),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Female'),
                            Icon(Icons.female),
                          ],
                        ),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0; buttonIndex < genderSelected.length; buttonIndex++) {
                          if (buttonIndex == index) {
                            genderSelected[buttonIndex] = true;
                          } else {
                            genderSelected[buttonIndex] = false;
                          }
                        }
                      });
                    },
                    isSelected: genderSelected,
                  ),
              ),
              // Flexible(
              //   child: Container(
              //     width: MediaQuery.of(context).size.width - 100,
              //     height: 50,
              //     padding: EdgeInsets.symmetric(horizontal: 20),
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(20),
              //         color: BeHealthyTheme.kLightOrange),
              //     child: DropdownButtonHideUnderline(
              //       child: DropdownButton(
              //         focusColor: BeHealthyTheme.kMainOrange,
              //         hint: Text('your_gender'.tr),
              //         value: _gender,
              //         items: (genderList.isEmpty)
              //             ? []
              //             : [
              //                 for (int i = 0; i < genderList.length; i++)
              //                   DropdownMenuItem(
              //                     child: Text(
              //                       genderList[i],
              //                       style: TextStyle(
              //                           color: BeHealthyTheme.kMainOrange),
              //                     ),
              //                     value: i,
              //                   )
              //               ],
              //         onChanged: (value) {
              //           setState(() {
              //             _gender = value;
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 30,
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width - 100,
              //   height: 50,
              //   child: TextFormField(
              //     cursorColor: BeHealthyTheme.kMainOrange,
              //     textAlign: TextAlign.center,
              //     decoration: InputDecoration(
              //         isDense: true,
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(25)),
              //             borderSide: BorderSide(
              //               width: 1,
              //             )),
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(25)),
              //           borderSide:
              //               BorderSide(width: 1, color: BeHealthyTheme.kMainOrange),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(25)),
              //           borderSide:
              //               BorderSide(width: 2, color: BeHealthyTheme.kMainOrange),
              //         ),
              //         labelText: "Enter E-mail Address",
              //         labelStyle: BeHealthyTheme.kInputFieldTextStyle),
              //   ),
              // ),

              Flexible(
                child: MaterialButton(
                  onPressed: () async {
                    if (compName.text.isNotEmpty &&
                        phone.text.isNotEmpty &&
                        email.text.isNotEmpty &&
                        password.text.isNotEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () async {
                              try {
                                http.Response response = await http.post(
                                  Uri.parse(
                                      "https://foodapi.pos53.com/api/Food/CompanySetupSave"),
                                  body: {
                                    'TenentID': TenentID.toString(),
                                    'COMPNAME1': compName.text,
                                    'EMAIL': email.text,
                                    'MOBPHONE': phone.text,
                                    'CPASSWRD': password.text,
                                    'COUNTRYID': '1',
                                    'STATE': stateList[_value].stateName,
                                    'Gender': genderSelected[0] ? 'Male' : 'Female',
                                    'Action': 'ADD',
                                    'CITY' : cityList[_cityValue]
                                  },
                                );
                                print(jsonDecode(response.body));
                                if (jsonDecode(response.body)['status'] ==
                                    200) {
                                  Toast.show(
                                    '${jsonDecode(response.body)['message']}',
                                    context,
                                    textColor: Colors.black,
                                    duration: 1,
                                    backgroundColor: BeHealthyTheme.kMainOrange
                                        .withOpacity(0.27),
                                  );

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                } else {
                                  Navigator.pop(context);
                                  compName.clear();
                                  email.clear();
                                  password.clear();
                                  phone.clear();
                                  // state.clear();
                                  Toast.show(
                                      jsonDecode(response.body)['message'],
                                      context,
                                      duration: 2,
                                      backgroundColor: BeHealthyTheme
                                          .kMainOrange
                                          .withOpacity(0.27),
                                      textColor: Colors.black);
                                }
                              } catch (e) {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('error'.tr),
                                      content: Text('some_error'.tr),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('ok'.tr),
                                        )
                                      ],
                                    );
                                  },
                                );
                                // Toast.show('some_error'.tr, context,
                                //     duration: 2,
                                //     backgroundColor: BeHealthyTheme.kMainOrange
                                //         .withOpacity(0.27),
                                //     textColor: Colors.black
                                // );
                              }
                            });
                            return Center(
                                child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  BeHealthyTheme.kMainOrange),
                            ));
                          });
                    } else {
                      Toast.show('enter_all_detail'.tr, context,
                          duration: 3,
                          backgroundColor:
                              BeHealthyTheme.kMainOrange.withOpacity(0.27),
                          textColor: Colors.black);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: BeHealthyTheme.kMainOrange,
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      'signup'.tr,
                      style: BeHealthyTheme.kMainTextStyle
                          .copyWith(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StateData {
  String stateName;
  int stateId;

  StateData(this.stateName, this.stateId);

  @override
  String toString() {
    return 'stateName: $stateName, stateId: $stateId';
  }
}
