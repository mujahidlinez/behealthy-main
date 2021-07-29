import 'dart:convert';
import 'package:behealthy/basicplan.dart';
import 'package:behealthy/constants.dart';
import 'package:behealthy/meal_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'loginScreen.dart';
import 'package:get/get.dart';

class SubMenuScreen extends StatefulWidget {
  final String planTitle;
  final String title;
  final int id;
  final int mealType;
  final String arabicName;
  final String groupName;
  SubMenuScreen(this.planTitle, this.title, this.id, this.mealType,
      this.arabicName, this.groupName);
  @override
  _SubMenuScreenState createState() => _SubMenuScreenState();
}

class _SubMenuScreenState extends State<SubMenuScreen> {
  planmealsetupGet() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('title', widget.title);
    preferences.setString('arabicName', widget.arabicName);
    DateTime dateTime = DateTime.now();
    print("Meal type:${widget.mealType}");
    var params = {
      'TenentID': TenentID.toString(),
      'PlanID': widget.id.toString(),
      'MealType': widget.mealType.toString(),
      'Date': '${dateTime.month}-${dateTime.day}-${dateTime.year}'
    };
    http.Response response = await http.post(
        Uri.parse(
            'https://foodapi.pos53.com/api/Food/Planmealsetupkitchen_Get'),
        body: params);
    if (jsonDecode(response.body)['status'] == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  void initState() {
    super.initState();
  }

  List selectedItemsList = [];

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FutureBuilder(
        future: getPreferences(),
        builder: (context, instances) {
          if (instances.connectionState == ConnectionState.done) {
            if (instances.data.get('custID') != null) {
              return Container();
            } else {
              return GestureDetector(
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setInt('PlanID', widget.id);
                  pref.setString(
                    'planTitle',
                    widget.title,
                  );
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: BeHealthyTheme.kMainOrange,
                  child: Text(
                    'login'.tr,
                    style: BeHealthyTheme.kMainTextStyle
                        .copyWith(color: Colors.white),
                  ),
                ),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Image(
                  image: AssetImage('assets/images/semi-circle.png'),
                ),
                Positioned(
                  top: medq.width / 20,
                  left: medq.width / 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: medq.width * 0.6,
                        child: Text(
                          widget.groupName,
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Container(
                        width: medq.width * 0.6,
                        child: Center(
                          child: Text(
                            widget.planTitle,
                            style: BeHealthyTheme.kMainTextStyle
                                .copyWith(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  // top: MediaQuery.of(context).size.height / 4.5 ,
                  bottom: 10,
                  left: MediaQuery.of(context).size.width * 0.25 ,
                  child: GestureDetector(
                    onTap: () async {
                      SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                      preferences.setInt('id', widget.id);
                      preferences.setString('planTitle', widget.planTitle);
                      if(preferences.get('custID') != null) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BasicPlan()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      }
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width * 0.5),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Buy Plan',
                          style: BeHealthyTheme.kMainTextStyle.copyWith(
                            color: BeHealthyTheme.kMainOrange,
                            fontSize: 25,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height * 0.65,
                child: FutureBuilder(
                  future: planmealsetupGet(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data != null || snapshot.data.length == 0) {
                        var showData = snapshot.data;
                        var showDataList = showData["data"];
                        if(showDataList.length != 0){
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: showData['data'].length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(MealDetailPage(),
                                      arguments: showData['data'][index]);
                                },
                                child: CustomContainer(
                                  id: widget.id,
                                  planName: showData['data'][index]['ProdName1'],
                                  imageUrl: showData['data'][index]['ProdName3'],
                                ),
                              );
                            },
                          );
                        }else {
                          return Center(
                            child: Text('sorry'.tr),
                          );
                        }
                      } else {
                        return Center(
                          child: Text('sorry'.tr),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatefulWidget {
  final String imageUrl;
  final String planName;
  final int planPrice;
  final int id;
  const CustomContainer({
    this.imageUrl,
    this.planName,
    this.planPrice,
    this.id,
    Key key,
  });

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool isSelected = false;
  getInstances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        // width: MediaQuery.of(context).size.width*0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: BeHealthyTheme.kMainOrange.withOpacity(0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (widget.imageUrl != null)
                        ? NetworkImage(widget.imageUrl)
                        : AssetImage('assets/images/haha.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    (widget.planName != null)
                        ? widget.planName
                        : 'الخطة الأساسية',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: BeHealthyTheme.kMainTextStyle.copyWith(
                        letterSpacing: 1.0,
                        fontSize: 15,
                        color: BeHealthyTheme.kMainOrange),
                  ),
                ),
                // Text(
                //   'Lorem Ipsum, Lorem Ipsum,\nLorem Ipsum, ',
                //   textAlign: TextAlign.start,
                //   style: BeHealthyTheme.kDhaaTextStyle
                //       .copyWith(fontSize: 10),
                // ),

                // Container(
                //   decoration: BoxDecoration(
                //       boxShadow: [
                //         BoxShadow(
                //             blurRadius: 5,
                //             offset: Offset(0, 2),
                //             color: Colors.black26)
                //       ],
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(15)),
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         vertical: 5, horizontal: 10),
                //     child: Text(
                //       (widget.planPrice != null)
                //           ? '${widget.planPrice.toString()} Kd'
                //           : '99 Kd',
                //       style: BeHealthyTheme.kDhaaTextStyle
                //           .copyWith(color: BeHealthyTheme.kMainOrange),
                //     ),
                //   ),
                // ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                          bottomRight: Radius.circular(20)),
                      color: BeHealthyTheme.kMainOrange.withOpacity(0.27)),
                  child: FutureBuilder(
                    future: getInstances(),
                    builder: (context, instance) {
                      if (instance.connectionState == ConnectionState.done) {
                        if (instance.data.get('custID') != null) {
                          return IconButton(
                            onPressed: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.setInt('id', widget.id);
                              preferences.setString(
                                'planTitle',
                                widget.planName,
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BasicPlan()));
                            },
                            icon: Icon(Icons.arrow_forward_ios),
                            color: BeHealthyTheme.kMainOrange,
                          );
                        } else {
                          return IconButton(
                            onPressed: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.setInt('id', widget.id);
                              preferences.setString(
                                'planTitle',
                                widget.planName,
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            icon: isSelected
                                ? Icon(Icons.check)
                                : Icon(Icons.add),
                            color: BeHealthyTheme.kMainOrange,
                          );
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
