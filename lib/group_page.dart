import 'dart:convert';
import 'dart:io';

import 'package:behealthy/constants.dart';
import 'package:behealthy/plansAvailable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'loginScreen.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  var isLoading = false;
  Map<String, List<Group>> groups = {'active': [], 'inActive': []};
  Map<String, String> images = {
    'Building': 'muscle.png',
    'Diet': 'diet (2).png',
    'Slimming': 'diet (1).png',
    'Healthy': 'Soup.png',
    'Ramadan': 'dish.png'
  };

  @override
  void initState() {
    super.initState();
    _readJson();
  }

  getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('you_sure'.tr),
            content: Text('exit_app'.tr),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('no'.tr),
              ),
              ElevatedButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text('yes'.tr),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Image(image: AssetImage('assets/images/semi-circle.png'),),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'groups_Available'.tr,
                            style: BeHealthyTheme.kMainTextStyle
                                .copyWith(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * 0.64,
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : DefaultTabController(
                          length: 2,
                          child: _buidTabView(),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _readJson() async {
    setState(() {
      isLoading = true;
    });
    Set<Group> uniqueGroupActive = {};
    Set<Group> uniqueGroupInActive = {};
    var txtData = await DefaultAssetBundle.of(context)
        .loadString("assets/json/newplan2.json");
    var jsonData = jsonDecode(txtData);
    var dataList = jsonData['NEwPlanMeal'] as List;

    for (var element in dataList) {
      var item = Group(
          groupName: element['GroupName'],
          groupId: int.parse(element['GroupID']));
      if (element['ACTIVE'] != '0') {
        uniqueGroupActive.add(item);
      } else {
        uniqueGroupInActive.add(item);
      }
    }

    print(uniqueGroupActive);
    print(uniqueGroupInActive);

    setState(() {
      groups['active'].addAll(uniqueGroupActive);
      groups['inActive'].addAll(uniqueGroupInActive);
      isLoading = false;
    });
  }
  Widget _buidTabView() {
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
            child: Center(
              child: Text(
                'empty'.tr,
                style: BeHealthyTheme.kMainTextStyle
                    .copyWith(color: BeHealthyTheme.kMainOrange, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: groups[tabName].length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: GroupCard(
                  title: groups[tabName][index].groupName,
                  image: images[
                      (groups[tabName][index].groupName.split(" ").length > 1)
                          ? groups[tabName][index].groupName.split(" ")[1]
                          : groups[tabName][index].groupName.split(" ")[0]],
                  onTap: () {
                    tabName == 'inActive'
                        ? showPopUp(context)
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlansAvailableScreen(
                                  id: groups[tabName][index].groupId,
                                  groupName: groups[tabName][index].groupName),
                            ),
                          );
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
}

class GroupCard extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;
  const GroupCard({
    this.onTap,
    this.image = 'Dinner.png',
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(title,
                    style: BeHealthyTheme.kMainTextStyle.copyWith(
                        color: BeHealthyTheme.kMainOrange, fontSize: 22),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class Group {
  String groupName;
  int groupId;

  Group({this.groupName, this.groupId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Group &&
          runtimeType == other.runtimeType &&
          groupName == other.groupName &&
          groupId == other.groupId;

  @override
  int get hashCode => groupName.hashCode ^ groupId.hashCode;

  @override
  String toString() {
    return '${this.groupName} -> ${this.groupId}';
  }
}
