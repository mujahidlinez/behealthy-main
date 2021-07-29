import 'package:behealthy/address_list.dart';
import 'package:behealthy/chat_system/views/admin_chat_list.dart';
import 'package:behealthy/chat_system/views/nutritional_admin_list.dart';
import 'package:behealthy/chat_system/views/nutritional_user_chat.dart';
import 'package:behealthy/chat_system/views/user_chat.dart';
import 'package:flutter/material.dart';
import 'package:behealthy/constants.dart';
import 'package:behealthy/homePage.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'basicplan.dart';
import 'lang/localization_service.dart';
import 'loginScreen.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userID = '';
  String lng;
  Future shardPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      setState(() {
        userID = prefs.get('custID').toString();
      });
      return prefs;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    shardPref();
    lng = LocalizationService().getCurrentLang();
  }

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        child: Column(
          // alignment: AlignmentDirectional.topCenter,
          children: [
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Image(
                  image: AssetImage('assets/images/semi-circle.png'),
                ),
                Positioned(
                  top: medq.height / 50,
                  left: medq.width / 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: medq.width * 0.46,
                        alignment: Alignment.topRight,
                        child: Text(
                          'الملف الشخصي',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(fontSize: 32, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Profile',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(color: Colors.white, fontSize: 19),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                          future: shardPref(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              var email = snapshot.data.get('email');
                              var number = snapshot.data.get('number');
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    email.toString(),
                                    style: BeHealthyTheme.kMainTextStyle
                                        .copyWith(
                                            color: BeHealthyTheme.kMainOrange,
                                            fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(number.toString(),
                                      style: BeHealthyTheme.kProfileFont),
                                ],
                              );
                            } else {
                              return Text('');
                            }
                          }),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/arabMan.png'), //NetworkImage
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 1),
                                  blurRadius: 6,
                                  spreadRadius: 1),
                            ] //BoxSha
                            ),
                        //                        child: Image.asset('assets/images/profilepic.png'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Container(
                      //   child: Column(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/heart (2).png',
                      //         width: 30,
                      //         height: 30,
                      //       ),
                      //       SizedBox(
                      //         height: 2,
                      //       ),
                      //       Text(
                      //         'Favorite',
                      //         style: BeHealthyTheme.kProfileFont,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   child: Column(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/settings (2).png',
                      //         width: 30,
                      //         height: 30,
                      //       ),
                      //       SizedBox(
                      //         height: 3,
                      //       ),
                      //       Text(
                      //         'Settings',
                      //         style: BeHealthyTheme.kProfileFont,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   child: Column(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/card.png',
                      //         width: 30,
                      //         height: 30,
                      //       ),
                      //       SizedBox(
                      //         height: 2,
                      //       ),
                      //       Text(
                      //         'Payments',
                      //         style: BeHealthyTheme.kProfileFont,
                      //       )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 40,
                //   width: MediaQuery.of(context).size.width * 0.8,
                //   child: Divider(
                //     color: Colors.black12,
                //   ),
                // ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8),
                      //     child: Container(
                      //       height: 95,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(15),
                      //         color: BeHealthyTheme.kLightOrange,
                      //         boxShadow: [
                      //           BoxShadow(
                      //             offset: Offset(0, 1),
                      //             color: Colors.black12,
                      //             blurRadius: 5,
                      //           )
                      //         ],
                      //       ),
                      //       //color: Colors.green,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           SizedBox(
                      //             height: 5,
                      //           ),
                      //           Image.asset(
                      //             'assets/images/dish.png',
                      //             height: 40,
                      //             width: 40,
                      //           ),
                      //           SizedBox(
                      //             height: 3,
                      //           ),
                      //           Text(
                      //             'Package',
                      //             style: BeHealthyTheme.kProfileFont.copyWith(
                      //                 fontSize: 14,
                      //                 color: BeHealthyTheme.kMainOrange),
                      //             textAlign: TextAlign.center,
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8),
                      //     child: Container(
                      //       height: 95,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(15),
                      //         color: BeHealthyTheme.kLightOrange,
                      //         boxShadow: [
                      //           BoxShadow(
                      //             offset: Offset(0, 1),
                      //             color: Colors.black12,
                      //             blurRadius: 5,
                      //           )
                      //         ],
                      //       ),
                      //       //color: Colors.green,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           SizedBox(
                      //             height: 5,
                      //           ),
                      //           Image.asset(
                      //             'assets/images/take-away (3).png',
                      //             height: 40,
                      //             width: 40,
                      //           ),
                      //           SizedBox(
                      //             height: 3,
                      //           ),
                      //           Text(
                      //             'My Orders',
                      //             style: BeHealthyTheme.kProfileFont.copyWith(
                      //                 fontSize: 14,
                      //                 color: BeHealthyTheme.kMainOrange),
                      //             textAlign: TextAlign.center,
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddressList())),
                            child: Container(
                              height: 95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: BeHealthyTheme.kLightOrange,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              //color: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/images/location (1).png',
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'address'.tr,
                                    style: BeHealthyTheme.kProfileFont.copyWith(
                                        fontSize: 14,
                                        color: BeHealthyTheme.kMainOrange),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              print(userID);
                              if (userID == '8992') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NutritionalAdminChatList()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NutritionalUserChat()));
                              }
                            },
                            child: Container(
                              height: 95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: BeHealthyTheme.kLightOrange,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              //color: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/images/support (1).png',
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'nutri_support'.tr,
                                    style: BeHealthyTheme.kProfileFont.copyWith(
                                        fontSize: 14,
                                        color: BeHealthyTheme.kMainOrange),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print(userID);
                            if (userID == '8991') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdminChatListAll()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserChat()));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              height: 95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: BeHealthyTheme.kLightOrange,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              //color: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/images/support (1).png',
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'tech_support'.tr,
                                    style: BeHealthyTheme.kProfileFont.copyWith(
                                        fontSize: 14,
                                        color: BeHealthyTheme.kMainOrange),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              Get.dialog(
                                Scaffold(
                                  body: SafeArea(
                                    child: Center(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/translation.png',
                                              height: 60,
                                              width: 60,
                                            ),
                                            Text(
                                              "Select Default Language",
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.03,
                                                  color: Colors.orange),
                                            ),
                                            DropdownButton<String>(
                                              items: LocalizationService.langs
                                                  .map((String value) {
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: value,
                                                  child: new Text(value),
                                                );
                                              }).toList(),
                                              value: this.lng,
                                              underline: Container(
                                                  color: Colors.transparent),
                                              isExpanded: false,
                                              onChanged: (newVal) {
                                                setState(() {
                                                  this.lng = newVal;
                                                  LocalizationService()
                                                      .changeLocale(newVal);
                                                });
                                                Get.back();
                                              },
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                                barrierDismissible: true,
                              );
                              // setState(() {
                              //   if (lng == 'Arabic') {
                              //     setState(
                              //       () {
                              //         this.lng = 'English';
                              //       },
                              //     );
                              //   } else
                              //     this.lng = 'Arabic';
                              //   LocalizationService().changeLocale(lng);
                              // });
                            },
                            child: Container(
                              height: 95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: BeHealthyTheme.kLightOrange,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              //color: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/images/translation.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'language'.tr,
                                    style: BeHealthyTheme.kProfileFont.copyWith(
                                        fontSize: 14,
                                        color: BeHealthyTheme.kMainOrange),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            FlutterOpenWhatsapp.sendSingleMessage('96592222991',
                                'Hello, Behealthy \nI want support with...');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              height: 95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: BeHealthyTheme.kLightOrange,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              //color: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/images/whatsapp.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'support'.tr,
                                    style: BeHealthyTheme.kProfileFont.copyWith(
                                        fontSize: 14,
                                        color: BeHealthyTheme.kMainOrange),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Container(
                              height: 95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(
                                    color: BeHealthyTheme.kMainOrange),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              //color: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/images/exit.png',
                                    height: 27,
                                    width: 27,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'logout'.tr,
                                    style: BeHealthyTheme.kProfileFont.copyWith(
                                        fontSize: 14,
                                        color: BeHealthyTheme.kMainOrange),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
