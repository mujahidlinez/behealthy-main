import 'dart:io';

import 'package:behealthy/constants.dart';
import 'package:behealthy/mainScreen.dart';
import 'package:behealthy/mealPlan.dart';
import 'package:behealthy/profile.dart';
import 'package:behealthy/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;
  List screen = [
    MainScreen(),
    // SearchScreen(),
    MealPlan(),
    ProfilePage(),
  ];

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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: SalomonBottomBar(
          itemPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            SalomonBottomBarItem(
              selectedColor: BeHealthyTheme.kMainOrange.withOpacity(0.3),
              icon: Image(
                height: 25,
                width: 25,
                image: AssetImage('assets/images/Untitled-2.png'),
              ),
              title: Text(
                'be_healthy'.tr,
                style: TextStyle(color: BeHealthyTheme.kMainOrange),
              ),
            ),
            // SalomonBottomBarItem(
            //   selectedColor: BeHealthyTheme.kMainOrange.withOpacity(0.2),
            //   icon: Icon(
            //     Icons.search,
            //     size: 25,
            //     color: BeHealthyTheme.kMainOrange,
            //   ),
            //   title: Text(
            //     'Search',
            //     style: TextStyle(color: Colors.black),
            //   ),
            // ),
            SalomonBottomBarItem(
              selectedColor: BeHealthyTheme.kMainOrange.withOpacity(0.2),
              icon: Image(
                color: BeHealthyTheme.kMainOrange,
                height: 25,
                width: 25,
                image: AssetImage('assets/images/take-away.png'),
              ),
              title: Text(
                'meal_plan'.tr,
                style: TextStyle(color: BeHealthyTheme.kMainOrange),
              ),
            ),
            SalomonBottomBarItem(
              selectedColor: BeHealthyTheme.kMainOrange.withOpacity(0.2),
              icon: Image(
                color: BeHealthyTheme.kMainOrange,
                height: 25,
                width: 25,
                image: AssetImage('assets/images/person.png'),
              ),
              title: Text(
                'profile'.tr,
                style: TextStyle(color: BeHealthyTheme.kMainOrange),
              ),
            ),
          ],
        ),
        body: screen[_currentIndex],
      ),
    );
  }
}
