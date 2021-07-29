import 'package:behealthy/database/dbhelper.dart';
import 'package:behealthy/providers/planmealcustinvoiceDb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:table_calendar/table_calendar.dart';

import 'constants.dart';

class MealPlan extends StatefulWidget {
  @override
  _MealPlanState createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan> {
  // CalendarFormat _calendarFormat = CalendarFormat.month;
  // DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateClass _currentValue;
  var db = DatabaseHelper.instance;
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
  List<int> transIdList = [];
  int currentTransId;

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

  bool allAreNotEmpty() {
    int count = food.keys
        .where((element) =>
            food[element].isNotEmpty &&
            !food[element].contains('10009') &&
            food[element].first != null)
        .length;
    print('count: $count');
    return count > 0;
  }

  @override
  void initState() {
    super.initState();
    // getUniqueDate() ;
    getTransIdList();
  }

  Future getDatesData() async {
    setState(() {
      isLoading = true;
    });
    var data = await db.queryDate(_currentValue.dayNumber,
        transID: transIdList[currentTransId]);

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
    var rows = await db.getAllDistinctDate(transIdList[currentTransId]);
    List<DateClass> datesToAdd = [];
    for (var row in rows) {
      print(row);
      List<int> dateString = (row['expectedDelDate'] as String)
          .split('/')
          .map((e) => int.parse(e))
          .toList();
      DateTime date = DateTime(dateString[2], dateString[0], dateString[1]);
      var newDate = DateClass(date, row['dayNumber']);
      datesToAdd.add(newDate);
    }
    datesToAdd.sort();
    setState(() {
      dates.addAll(datesToAdd);
      // _selectedDay = dates.first.date;
      // _currentValue = dates.first;
    });
    // await getDatesData() ;
  }

  Future<void> getTransIdList() async {
    var uniqueTransIds = await db.getAllDistinctTransId();
    List<int> transIds = [];
    for (var ids in uniqueTransIds) {
      transIds.add(ids['transId']);
    }
    setState(() {
      transIdList.addAll(transIds);
      currentTransId = 0;
    });
    for (var id in transIdList) {
      print(id);
    }
    getUniqueDate();
  }

  Widget getCurrentPlanData() {
    // getDatesData() ;
    DateTime date = _selectedDay;
    return (transIdList.isEmpty)
        ? Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  'Buy a plan to see the details here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: BeHealthyTheme.kMainOrange,
                  ),
                ),
              ),
            ),
          )
        : (date == null)
            ? Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      'Select a date',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: BeHealthyTheme.kMainOrange,
                      ),
                    ),
                  ),
                ),
              )
            : Expanded(
                child: Container(
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
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: (!allAreNotEmpty())
                            ? Center(
                                child: Text(
                                  'Empty',
                                  style: BeHealthyTheme.kMainTextStyle
                                      .copyWith(fontSize: 30),
                                ),
                              )
                            : ListView.builder(
                                itemCount: food.keys.length,
                                itemBuilder: (BuildContext context, int index) {
                                  List items = [];
                                  items.addAll(food.keys);
                                  if (food[items[index]].isNotEmpty &&
                                      food[items[index]].first != null &&
                                      food[items[index]].first.toString() !=
                                          '10009' &&
                                      food[items[index]].first.toString() !=
                                          '100007') {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            '${foodNames[items[index]]}',
                                            style: BeHealthyTheme.kMainTextStyle
                                                .copyWith(
                                                    color: Color(0xff707070),
                                                    fontSize: 20),
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
                                  // return Column(
                                  //   children: [
                                  //     Container(
                                  //       child: Center(
                                  //         child: Text(
                                  //           'EMPTY',
                                  //           style: TextStyle(
                                  //             fontWeight: FontWeight.bold,
                                  //             fontSize: 30,
                                  //             color: BeHealthyTheme.kMainOrange
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     SizedBox(height: 30,)
                                  //   ],
                                  // );
                                  return Container();
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              );
  }

  // void getPlanDate() async {
  //   var weekOne = await (PlanmealCustInvoiceDB.instance).giveFirstWeekData();
  //   var dayOne = weekOne[0];
  //   List<int> startDateValue = (dayOne['startDate'] as String)
  //       .split('/')
  //       .map((e) => int.parse(e))
  //       .toList();
  //   List<int> endDateValue = (dayOne['endDate'] as String)
  //       .split('/')
  //       .map((e) => int.parse(e))
  //       .toList();
  //   DateTime startDate =
  //       DateTime(startDateValue[2], startDateValue[0], startDateValue[1]);
  //   DateTime endDate =
  //       DateTime(endDateValue[2], endDateValue[0], endDateValue[1]);
  //   setState(() {
  //     _startDate = startDate;
  //     _focusedDay = startDate.add(Duration(days: 1));
  //     _selectedDay = startDate.add(Duration(days: 2));
  //     _endDate = endDate;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: BeHealthyTheme.kLightOrange),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    focusColor: BeHealthyTheme.kMainOrange,
                    hint: Text('Transaction ID'),
                    value: currentTransId,
                    items: (transIdList.isEmpty)
                        ? []
                        : [
                            for (int i = 0; i < transIdList.length; i++)
                              DropdownMenuItem(
                                child: Text(
                                  'Trans ID: ${transIdList[i]}',
                                  style: TextStyle(
                                      color: BeHealthyTheme.kMainOrange),
                                ),
                                value: i,
                              )
                          ],
                    onChanged: (value) {
                      setState(() {
                        currentTransId = value;
                        _selectedDay = null;
                      });
                      dates.clear();
                      getUniqueDate();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              (transIdList.isEmpty)
                  ? Container()
                  : (dates.isEmpty)
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 12,
                          child: ListView.builder(
                            itemCount: dates.length,
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
              (_selectedDay == null && isLoading)
                  ? Expanded(
                      child: Container(
                        child: Center(
                          child: Text(
                            'Select a date',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: BeHealthyTheme.kMainOrange,
                            ),
                          ),
                        ),
                      ),
                    )
                  : getCurrentPlanData(),
            ],
          ),
        ),
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
        height: MediaQuery.of(context).size.width / 5,
        width: MediaQuery.of(context).size.width / 6,
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
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '${dayName[date.weekday - 1]}',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
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
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
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
                SizedBox(
                  height: 5,
                )
              ],
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
