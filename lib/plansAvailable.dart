import 'dart:convert';

import 'package:behealthy/constants.dart';
import 'package:behealthy/mealsAvailable.dart';
import 'package:behealthy/providers/dashboard_items_dbprovider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'database/dbhelper.dart';
import 'loginScreen.dart';

class PlansAvailableScreen extends StatefulWidget {
  final int id;
  final String groupName;

  PlansAvailableScreen({this.id, this.groupName});

  @override
  _PlansAvailableScreenState createState() => _PlansAvailableScreenState();
}

class _PlansAvailableScreenState extends State<PlansAvailableScreen> {
  Map<String, String> images = {
    'Building': 'muscle.png',
    'Diet': 'diet (2).png',
    'Slimming': 'diet (1).png',
    'Healthy': 'Soup.png',
    'Ramadan': 'dish.png'
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filteredData();
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                  // SharedPreferences preferences =
                  // await SharedPreferences.getInstance();
                  // preferences.setInt('id', widget.id);
                  // preferences
                  //     .setString(
                  //   'planTitle',
                  //   widget.groupName,
                  // )
                  //     .then((value) {
                  //
                  // });
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
                  left: medq.width / 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: medq.width * 0.46,
                        alignment: Alignment.topRight,
                        child: Text(
                          'الخطط',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(fontSize: 33, color: Colors.white),
                        ),
                      ),
                      Text(
                        'plan_available'.tr,
                        style: BeHealthyTheme.kMainTextStyle
                            .copyWith(color: Colors.white, fontSize: 25),
                      ),
                      Container(
                        width: medq.width * 0.6,
                        child: Text(
                          widget.groupName,
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
                child:
                    // Column(
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [

                    Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: _buildGetPackageListView(),
            )
                //   ],
                // ),
                )
          ],
        ),
      ),
    );
  }

  // _loadFromApi() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   var apiProvider = DataApiProvider();
  //   await apiProvider.getAllPackages();
  //
  //   // wait for 2 seconds to simulate loading of data
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  _deleteData() async {
    setState(() {
      // isLoading = true;
    });

    await DBProvider.db.deleteAllPackages();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // isLoading = false;
    });

    print('All data deleted');
  }
  List<Plan> plans = List();
  filteredData() async {
    final dbHelper = DatabaseHelper.instance;
    var rowsFuture = dbHelper.selectPlanMeal();
    var groupId = widget.id;
    rowsFuture.then((dataList){
      List filtered = dataList.where((element) => element['GroupID'] == groupId.toString()).toList();
      for (var items in filtered) {
       var imageName =  (items['GroupName'] as String).split(' ').length > 1
      ? (items['GroupName'] as String).split(' ')[1] : (items['GroupName'] as String).split(' ')[0];
       var planDesc = items['plandesc'] == null ? "No Description" : items['plandesc'];
       var switch3 = items['switch3'];
       var planId = items['planid'];
       var plan = Plan(imageName: imageName, planName: planDesc, planDetails:switch3, planID: planId);
        setState(() {
          plans.add(plan);
        });
      }
    });
  }

  _buildGetPackageListView() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: plans.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 15, vertical: 10),
          child: CustomCard(
            image: images[plans[index].imageName],
            title: plans[index].planName,
            desc: plans[index].planDetails,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealsAvailableScreen(
                    planName: plans[index].planName,
                    id: widget.id,
                    groupName: widget.groupName,
                    planId: plans[index].planID,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;
  final String desc;

  const CustomCard({
    this.desc,
    this.onTap,
    this.image,
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  image: AssetImage('assets/images/$image'),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.height * 0.1,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        title,
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                            color: BeHealthyTheme.kMainOrange, fontSize: 22),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        desc,
                        textAlign: TextAlign.start,
                        style: BeHealthyTheme.kDhaaTextStyle
                            .copyWith(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class Plan {
  String planName;
  String planDetails;
  String imageName;
  int planID;

  Plan({this.planName, this.planDetails, this.imageName, this.planID});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Plan &&
          runtimeType == other.runtimeType &&
          planName == other.planName &&
          planDetails == other.planDetails;

  @override
  int get hashCode => planName.hashCode ^ planDetails.hashCode;
}
