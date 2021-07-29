import 'dart:convert';
import 'package:behealthy/constants.dart';
import 'package:behealthy/providers/dashboard_items_dbprovider.dart';
import 'package:behealthy/providers/getDataFromApi.dart';
import 'package:behealthy/subMenuScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'database/dbhelper.dart';
import 'loginScreen.dart';

class MealsAvailableScreen extends StatefulWidget {
  final String planName;
  final int planId;
  final int id;
  final String groupName;

  MealsAvailableScreen(
      {this.planName, this.id, this.groupName = 'group', this.planId});

  @override
  _MealsAvailableScreenState createState() => _MealsAvailableScreenState();
}

class _MealsAvailableScreenState extends State<MealsAvailableScreen> {
  getPackageWithPlanID() async {
    // print(widget.id);
    http.Response response = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Food/Getpackagewithplanid'),
        body: {'TenentID': TenentID.toString(), 'PlanId': '${widget.id}'});
    if (response.statusCode == 200) {
      // print(response.body);
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  var isLoading = false;

  Map<String, int> mealType = {
    'Breakfast': 1401,
    'Lunch': 1402,
    'Dinner': 1403,
    'Snack': 1404,
    'Salad': 1405,
    'Soup': 1406
  };

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = DataApiProvider();
    await apiProvider.getAllPackages();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllPackages(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // print(showData);
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Text(
                  "${index + 1}",
                  style: TextStyle(fontSize: 20.0),
                ),
                title: Text(
                    "ID: ${snapshot.data[index].planID} ${snapshot.data[index].planName} "),
                subtitle: Text('Price: ${snapshot.data[index].planPrice}'),
              );
            },
          );
        }
      },
    );
  }
  Map<String, dynamic> meals = {'meals': [], 'details': {}};
  List filtered;
  getDifferentMeals() async {
    final dbHelper = DatabaseHelper.instance;
    var rowsFuture = dbHelper.selectPlanMealWithPlaId(widget.planId);
    var groupId = widget.id;
    rowsFuture.then((dataList) async {
      filtered = dataList.where((element) => element['GroupID'] == groupId.toString()).toList();
      int planDays = dataList[0]["plandays"];
      int mealInGram = dataList[0]["MealInGram"];
      var preferences = await SharedPreferences.getInstance();
      preferences.setInt('planDays', planDays);
      preferences.setInt('mealInGram', mealInGram);
      if(filtered.length > 0){
        var disc = (filtered[0]['switch3'] as String).split(',');
        for (String value in disc) {
          if (value.trim() != '') {
            meals['meals'].add(value.trim());
          }
        }
      }
      for (var items in filtered) {
        if (items['GroupName'] == widget.groupName && items['plandesc'] == widget.planName) {

          setState(() {
            meals['details']['planTitle'] = items['plandesc'];
            meals['details']['id'] = items['planid'];
            meals['details']['mealType'] = items['MealType'];
            meals['details']['groupName'] = widget.groupName;
            if ((meals['meals'] as List).isNotEmpty) {

            }
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDifferentMeals();
    // getData();
  }
  getData() async {
    await _loadFromApi();
  }
  getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

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
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  preferences.setInt('id', widget.id);
                  preferences.setString('planTitle', widget.planName,).
                  then((value) {Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  });
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
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.55,
                      //   alignment: Alignment.topRight,
                      //   child: Text(
                      //     'الوجبة المتاحة',
                      //     textAlign: TextAlign.right,
                      //     style: BeHealthyTheme.kMainTextStyle
                      //         .copyWith(fontSize: 28, color: Colors.white),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 12,
                      // ),
                      // Text(
                      //   'Meals Available',
                      //   textAlign: TextAlign.center,
                      //   style: BeHealthyTheme.kMainTextStyle
                      //       .copyWith(color: Colors.white, fontSize: 20),
                      // )
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          widget.groupName,
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          widget.planName,
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child:  ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: filtered != null ? filtered.length: 0,//(snapshot.data['meals'] as List).length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: CustomCard(
                        title:
                        (meals["meals"][index] as String).split(' ')[1],
                        allowedMeal: int.parse((meals["meals"][index] as String).split(' ')[0]),
                        onTap: () async {
                          SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                          preferences.setInt('id', widget.planId);
                          preferences.setString('planTitle', widget.planName);
                          var mealType = filtered[index]['MealType'];
                          var id  = meals['details']['id'];
                          var mealName  = (meals['meals'][index] as String).split(' ')[1];
                          preferences.setInt('mealType',mealType);
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => SubMenuScreen(widget.planName,mealName, id, mealType, 'Menu', widget.groupName,),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final Function onTap;
  final int allowedMeal;
  const CustomCard({
    this.allowedMeal,
    this.onTap,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: BeHealthyTheme.kMainOrange.withOpacity(0.11),
            borderRadius: BorderRadiusDirectional.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                ),
                Image(image: AssetImage('assets/images/$title.png')),
                SizedBox(
                  width: 30,
                ),
                Text(
                  '$title ($allowedMeal)',
                  textAlign: TextAlign.left,
                  style: BeHealthyTheme.kMainTextStyle.copyWith(
                      color: BeHealthyTheme.kMainOrange,
                      fontSize: 18,
                      letterSpacing: 1.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SafeArea(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 width: MediaQuery.of(context).size.width,
//                 child: isLoading
//                     ? Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : _buildEmployeeListView(),
//               ),
//               MaterialButton(
//                 color: Colors.blue,
//                 onPressed: () async {
//                   await _loadFromApi();
//                 },
//                 child: Text('Get data'),
//               ),
//             ],
//           ),
//         ),
//       ),
