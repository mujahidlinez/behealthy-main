import 'dart:convert';

import 'package:behealthy/address_selector.dart';
import 'package:behealthy/database/dbhelper.dart';
import 'package:behealthy/providers/planmealcustinvoiceDb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:behealthy/constants.dart';
import 'package:behealthy/homePage.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'constants.dart';
import 'homePage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class CartCheckout extends StatefulWidget {
  @override
  _CartCheckoutState createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  List addressList = [];
  bool _isLoading = true;
  var _currentAddress;
  DateTime _selectedDay;
  DateClass _currentValue;
  var db = DatabaseHelper.instance;
  String name;

  bool isLoading = false;
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List<DateClass> dates = [];
  Map<String, String> foodNames = {
    '1401': 'BreakFast',
    '1402': 'Lunch',
    '1403': 'Dinner',
    '1404': 'Snack',
    '1405': 'Salad',
    '1406': 'Soup'
  };

  Map<String, List> food = {
    '1401': [],
    '1402': [],
    '1403': [],
    '1404': [],
    '1405': [],
    '1406': []
  };

  @override
  void initState() {
    super.initState();
    getAddressList();
    getUniqueDate();
  }

  Future getDatesData() async {
    setState(() {
      isLoading = true;
    });
    var data = await db.queryDate(_currentValue.dayNumber);

    for (var value in data) {
      // print(value['switch5']) ;
      List<int> dateString = (value['expectedDelDate'] as String)
          .split('/')
          .map((e) => int.parse(e))
          .toList();
      DateTime date = DateTime(dateString[2], dateString[0], dateString[1]);
      if (isSameDay(date, _selectedDay)) {
        food[value['mealType'].toString()].add(value['switch5']);
      }
    }
    setState(() {
      isLoading = false;
    });
    print(food);
  }

  void getUniqueDate() async {
    var rows = await db.getFirstWeekUniqueData();
    List<DateClass> datesToAdd = [];
    for (var row in rows) {
      List<int> dateString = (row['expectedDelDate'] as String)
          .split('/')
          .map((e) => int.parse(e))
          .toList();
      DateTime date = DateTime(dateString[2], dateString[0], dateString[1]);
      var newDate = DateClass(date, row['dayNumber']);
      datesToAdd.add(newDate);
      datesToAdd.sort();
    }
    setState(() {
      dates.addAll(datesToAdd);
      // _selectedDay = dates.first.date;
      // _currentValue = dates.first;
    });
    for (var date in dates) {
      print(date);
    }
    // await getDatesData() ;
  }

  Future<void> getAddressList() async {
    var pref = await SharedPreferences.getInstance();
    var custId = pref.get('custID');
    setState(() {
      name = pref.getString('compName');
    });
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
        if (values.isNotEmpty) {
          addressList.addAll(values);
          _isLoading = false;
          _currentAddress = addressList.first;
        }
      });
    }
    for (var val in addressList) {
      print(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          elevation: 100,
          child: SafeArea(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // GestureDetector(
                //   onTap: () {
                //     // Navigator.pushReplacement(
                //     //     context,
                //     //     MaterialPageRoute(
                //     //         builder: (context) => CartCheckout()));
                //   },
                //   child: Container(
                //     width: MediaQuery.of(context).size.width - 300,
                //     height: 45,
                //     alignment: Alignment.center,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Pay with',
                //           style: BeHealthyTheme.kMainTextStyle.copyWith(
                //               fontSize: 12, color: BeHealthyTheme.kMainOrange),
                //         ),
                //         Text(
                //           'Card',
                //           style: BeHealthyTheme.kProfileFont.copyWith(
                //             fontSize: 14,
                //             color: Color(0xff707070),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 150,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: BeHealthyTheme.kMainOrange,
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'place_order'.tr,
                            style: BeHealthyTheme.kMainTextStyle
                                .copyWith(fontSize: 18, color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image(image: AssetImage('assets/images/semi-circle.png')),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 10,
                      top: MediaQuery.of(context).size.height / 18,
                      child: Text(
                        'عربة التسوق',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 10,
                      top: MediaQuery.of(context).size.height / 9,
                      child: Text(
                        'order_summary'.tr,
                        style: BeHealthyTheme.kMainTextStyle
                            .copyWith(fontSize: 21, color: Colors.white),
                      ),
                    )
                    // Positioned(child: child)
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.61,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(children: [
                          Text(
                            'name'.tr,
                            style: BeHealthyTheme.kMainTextStyle.copyWith(
                                fontSize: 15,
                                color: BeHealthyTheme.kMainOrange),
                          ),
                          Icon(Icons.edit_outlined,
                              color: BeHealthyTheme.kMainOrange, size: 16),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          name ?? 'no name added',
                          style: BeHealthyTheme.kProfileFont.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: GestureDetector(
                          onTap: () async {
                            var data = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectAddressPage()));
                            if (data != null) {
                              setState(() {
                                _currentAddress = data;
                              });
                            }
                          },
                          child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'deliver_to'.tr,
                                  style: BeHealthyTheme.kMainTextStyle.copyWith(
                                      fontSize: 15,
                                      color: BeHealthyTheme.kMainOrange),
                                ),
                                Icon(Icons.edit_outlined,
                                    color: BeHealthyTheme.kMainOrange,
                                    size: 16),
                              ]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          (_isLoading)
                              ? 'Add an address'
                              : (_currentAddress == null)
                                  ? 'Add an address'
                                  : _currentAddress['GoogleName'],
                          style: BeHealthyTheme.kProfileFont.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      (dates.isEmpty)
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(
                              height: MediaQuery.of(context).size.height / 14,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                itemCount: dates.length > 6 ? 6 : dates.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return DateBox(
                                    date: dates[index].date,
                                    onTap: () async {
                                      for (var dates in food.keys) {
                                        food[dates].clear();
                                      }
                                      setState(() {
                                        _currentValue = dates[index];
                                        _selectedDay = dates[index].date;
                                      });
                                      await getDatesData();
                                    },
                                  );
                                },
                              ),
                            ),
                      getCurrentPlanData(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCurrentPlanData() {
    // getDatesData() ;
    DateTime date = _selectedDay;
    return (date == null)
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Text(
              'select_date'.tr,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: BeHealthyTheme.kMainOrange,
              ),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      '${_selectedDay.day} ${months[_selectedDay.month - 1]} ${_selectedDay.year}',
                      style: BeHealthyTheme.kMainTextStyle.copyWith(
                          color: Colors.orange,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: food.keys.length,
                    itemBuilder: (BuildContext context, int index) {
                      List items = [];
                      items.addAll(food.keys);
                      if (food[items[index]].isNotEmpty &&
                          food[items[index]].first != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${foodNames[items[index]]}',
                                style: BeHealthyTheme.kMainTextStyle.copyWith(
                                    color: Color(0xff707070), fontSize: 20),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            for (var items in food[items[index]])
                              CustomItemBox(items),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        );
                      }
                      return Container();
                      // return Column(
                      //   children: [
                      //     Container(
                      //       child: Center(
                      //         child: Text(
                      //           'EMPTY',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //               fontSize: 30,
                      //               color: BeHealthyTheme.kMainOrange),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       height: 30,
                      //     )
                      //   ],
                      // );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}

class CustomItemBox extends StatelessWidget {
  final String itemName;
  CustomItemBox(this.itemName);
  @override
  Widget build(BuildContext context) {
    return (itemName == '10009')
        ? Container()
        : Container(
            margin: EdgeInsets.all(5.0),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            // height: MediaQuery.of(context).size.height / 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: BeHealthyTheme.kLightOrange,
                  ),
                  child: Text(
                    itemName,
                    // textAlign: TextAlign.center,
                    style: BeHealthyTheme.kProfileFont.copyWith(
                        color: Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
  }
}

class DateBox extends StatelessWidget {
  final DateTime date;
  final Function onTap;
  final List<String> dayName = [
    "Mon",
    "Tue",
    "Wed",
    "Thur",
    "Fri",
    "Sat",
    "Sun"
  ];

  DateBox({this.date, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.width / 6,
        width: MediaQuery.of(context).size.width / 7,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: BeHealthyTheme.kMainOrange,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: BeHealthyTheme.kProfileFont.copyWith(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '${dayName[date.weekday - 1]}',
              style: BeHealthyTheme.kProfileFont.copyWith(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class DateClass implements Comparable<DateClass> {
  DateTime date;
  int dayNumber;

  DateClass(this.date, this.dayNumber);

  @override
  int compareTo(DateClass other) {
    return this.date.compareTo(other.date);
  }

  @override
  String toString() {
    return '${date.month}/${date.day}/${date.year} -> $dayNumber';
  }
}
