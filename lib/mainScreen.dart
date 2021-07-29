import 'dart:convert';
import 'package:behealthy/constants.dart';
import 'package:behealthy/group_page.dart';
import 'package:behealthy/meal_selection.dart';
import 'package:behealthy/plansAvailable.dart';
import 'package:behealthy/database/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'customise_plan.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, List<Group>> groups = {'active': [], 'inActive': []};
  Map<String, String> images = {
    'Building': 'muscle.png',
    'Diet': 'diet (2).png',
    'Slimming': 'diet (1).png',
    'Healthy': 'Soup.png',
    'Ramadan': 'dish.png'
  };

  final dbHelper = DatabaseHelper.instance;
  List planTitlesList = [];
  List queryListForHd = [];
  List itemsList = [];
  List mealPlans = [];

  Future<void> readJsonBasic() async {
    Set<Group> uniqueGroupActive = {};
    Set<Group> uniqueGroupActiveAllowedCustom = {};
    var rowsFuture = dbHelper.selectPlanMeal();
    rowsFuture.then((rows){
      rows.forEach((element) {
        var groupName =  element['GroupName'];
        var groupID =  element['GroupID'];
        var active =  element['ACTIVE'];
        var customAllow =  element['CustomAllow'];
        var item = Group(groupName: groupName, groupId: int.parse(groupID));
        if ( customAllow == "0") {//active != 0 &&
          uniqueGroupActive.add(item);
        }
        if (customAllow == "1") {
          uniqueGroupActiveAllowedCustom.add(item);
        }
      });
      setState(() {
        groups['active'].addAll(uniqueGroupActive);
        groups['inActive'].addAll(uniqueGroupActiveAllowedCustom);
      });
    });
  }

  Widget activeListView(String tabName) {
    return (groups[tabName].length == 0)
        ? SizedBox(width: 100, height: 100,
            child: Center(
              child: Text('Empty', style: BeHealthyTheme.kMainTextStyle.copyWith(color: BeHealthyTheme.kMainOrange,
                  fontSize: 22), textAlign: TextAlign.center,),
            ),
          )
         : DefaultTabController(
      length: 2,
      child: _buildTabView(),
    );
  }

  Widget _buildTabView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            indicatorColor: BeHealthyTheme.kMainOrange,
            labelColor: BeHealthyTheme.kMainOrange,
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'basic'.tr,
              ),
              Tab(
                text: 'customized'.tr,
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildGetGroupListView('active'),
                _buildGetGroupListView('inActive'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildGetGroupListView(String tabName) {
    return (groups[tabName].length == 0)
        ? Container(
      child: Center(child: Text("Empty",//'empty'.tr,
          style: BeHealthyTheme.kMainTextStyle.copyWith(color: BeHealthyTheme.kMainOrange, fontSize: 22),
          textAlign: TextAlign.center,
        ),
      ),
    )
        : ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: groups[tabName].length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GroupCard(
            title: groups[tabName][index].groupName,
            image: images[
            (groups[tabName][index].groupName.split(" ").length > 1)
                ? groups[tabName][index].groupName.split(" ")[1]
                : groups[tabName][index].groupName.split(" ")[0]],
            onTap:  () async {
             var groupId = groups[tabName][index].groupId;
             var groupName = groups[tabName][index].groupName;
             var preferences = await SharedPreferences.getInstance();
             preferences.setInt('id', groupId);
             preferences.setString('planTitle', groupName);
             if(tabName == "active"){
               Navigator.push(context, MaterialPageRoute(
                 builder: (context) => PlansAvailableScreen(id: groupId,groupName: groupName),
               ),
               );
             }else{
               Navigator.push(context, MaterialPageRoute(
                 builder: (context) => CustomisePlan(groupId: groupId,groupName: groupName),
               ),
               );
             }
            },
          ),
        );
      },
    );
  }
  void showPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('coming_soon'.tr),
          content: Text('coming_message'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ok'.tr),
            )
          ],
        );
      },
    );
    // return AlertDialog(
    //   title: Text('Coming soon...'),
    //   content: Text('Will try to bring this feature as soon as possible'),
    //   actions: [
    //     TextButton(
    //       onPressed: () => Navigator.pop(context),
    //       child: Text('OK'),
    //     )
    //   ],
    // );
  }
  _queryMain() async {
    queryListForHd.clear();
    final allRows = await dbHelper.queryAllRows();
   // print('query all rows:');
    //allRows.forEach(print);
    getPlanNames(allRows);
    allRows.forEach((element) {
      queryListForHd.add(element);
    });
    return allRows;
  }
  getData() async {
    http.Response response = await http
        .post(Uri.parse('https://foodapi.pos53.com/api/Food/GetPackage'));
    if (jsonDecode(response.body)['status'] == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
  getPlanNames(rQueryList) async {
    final String response =
        await rootBundle.loadString('assets/json/newplan2.json');
    var rData = jsonDecode(response.toString());
    rQueryList.forEach((element) {
      planTitlesList.add((rData['NEwPlanMeal'] as List)
          .where((value) => value['planid'] == element['planid'].toString())
          .first['GroupName']);
    });

    // rData[element['planid'].toString()][0]['Plan_Display']
  }
  getInstances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      return prefs;
    } else {
      return null;
    }
  }

  @override
  void didChangeDependencies() async {
    await readJsonBasic();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'your_existing'.tr,
                                style: BeHealthyTheme.kMainTextStyle.copyWith(
                                    color: Colors.black54, fontSize: 22)),
                            TextSpan(
                                text: 'plan'.tr,
                                style: BeHealthyTheme.kMainTextStyle.copyWith(
                                    color: BeHealthyTheme.kMainOrange,
                                    fontSize: 22))
                          ])),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image(
                        height: 35, width: 35,
                        image: AssetImage('assets/images/bh_logo.png'),
                        color: BeHealthyTheme.kMainOrange,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                FutureBuilder(
                  future: _queryMain(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.done) {
                      if (snap.data != null && snap.data.isNotEmpty && queryListForHd.isNotEmpty) {
                        return Container(
                            height: MediaQuery.of(context).size.height * 0.28,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: snap.data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return MealSelection(
                                          planId: queryListForHd[index]
                                              ['planid'],
                                          transId: queryListForHd[index]
                                              ['mytransid'],
                                        );
                                      }));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.28,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: BeHealthyTheme
                                                    .kMainOrange
                                                    .withOpacity(0.11)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  child: Image(
                                                    fit: BoxFit.fitWidth,
                                                    image: AssetImage(
                                                        'assets/images/haha2.png'),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                        child: Text(
                                                          '${planTitlesList.length != 0 ? planTitlesList[index]:""}',
                                                          overflow: TextOverflow.ellipsis,
                                                          style: BeHealthyTheme.kMainTextStyle.copyWith(fontSize: 22),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: Text(
                                                        '${queryListForHd[index]['mytransid']}',
                                                        style: BeHealthyTheme
                                                            .kMainTextStyle
                                                            .copyWith(
                                                                fontSize: 22),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }));
                      } else {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                          child: Text(
                            'no_active_plan'.tr,
                            textAlign: TextAlign.center,
                            style: BeHealthyTheme.kMainTextStyle.copyWith(
                                color: BeHealthyTheme.kMainOrange,
                                fontSize: 20),
                          ),
                        );
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                activeListView('active'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  StatefulElement createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }

  @override
  createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    // TODO: implement debugDescribeChildren
    throw UnimplementedError();
  }

  @override
  // TODO: implement key
  Key get key => throw UnimplementedError();

  @override
  String toStringDeep({String prefixLineOne = '', String prefixOtherLines, DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toStringDeep
    throw UnimplementedError();
  }
  @override
  String toStringShallow({String joiner = ', ', DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toStringShallow
    throw UnimplementedError();
  }
}
class CustomContainer extends StatefulWidget {
  final String imageUrl;
  final String planName;
  final int planPrice;
  final Function onTap;

  const CustomContainer({
    this.onTap,
    this.imageUrl,
    this.planName,
    this.planPrice,
    Key key,
  });

  @override
  _CustomContainerState createState() => _CustomContainerState();
}
class _CustomContainerState extends State<CustomContainer> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 115,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: BeHealthyTheme.kMainOrange.withOpacity(0.1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: 115, width: 153,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (widget.imageUrl != null)
                          ? NetworkImage(widget.imageUrl)
                          : AssetImage('assets/images/haha.png'),
                      fit: BoxFit.fitHeight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      (widget.planName != null)
                          ? widget.planName
                          : 'الخطة الأساسية',
                      style: BeHealthyTheme.kMainTextStyle.copyWith(
                          fontSize: 15, color: BeHealthyTheme.kMainOrange),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      'Breakfast 1, Lunch 1, Dinner 1, Salad 1, Soup 1',
                      textAlign: TextAlign.start,
                      style:
                          BeHealthyTheme.kDhaaTextStyle.copyWith(fontSize: 10),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              offset: Offset(0, 2),
                              color: Colors.black26)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Text(
                        (widget.planPrice != null)
                            ? '${widget.planPrice.toString()} Kd'
                            : '99 Kd',
                        style: BeHealthyTheme.kDhaaTextStyle
                            .copyWith(color: BeHealthyTheme.kMainOrange),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
              Container(
                height: 115,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(70),
                              bottomRight: Radius.circular(20)),
                          color: BeHealthyTheme.kMainOrange.withOpacity(0.27)),
                      child: IconButton(
                        onPressed: () {
                         // print('tapped');
                          setState(() {
                            isSelected = !isSelected;
                          });
                        },
                        splashColor: Colors.transparent,
                        splashRadius: 10,
                        icon: isSelected ? Icon(Icons.check) : Icon(Icons.add),
                        color: BeHealthyTheme.kMainOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
