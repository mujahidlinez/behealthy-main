// // import 'package:behealthy/cart_checkout.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:behealthy/basicplan.dart';
// import 'package:behealthy/cart_checkout.dart';
// import 'package:behealthy/mainScreen.dart';
// import 'package:behealthy/providers/planmealcustinvoiceDb.dart';
// import 'package:flutter/material.dart';
// import 'package:behealthy/package_details.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:behealthy/constants.dart';
// import 'package:behealthy/homePage.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:toast/toast.dart';
// import 'constants.dart';
// import 'mealPlan.dart';
// import 'package:date_picker_timeline/date_picker_timeline.dart';
// import 'package:http/http.dart' as http;

// class tempfile extends StatefulWidget {
//   @override
//   _tempfileState createState() => _tempfileState();
// }

// //api will be https://foodapi.pos53.com/api/Food/PlanmealsetupKitchen_Get

// class _tempfileState extends State<tempfile> {
//   String _selectedDate;
//   int totalWeek;
//   String _chosenWeek = 'Week 1';
//   String _chosenMeal = 'Breakfast';
//   List weekDate = [];
//   List weekDay = [];
//   List expectedDelDayList = [];
//   var expectedDelDay = 1;
//   List deliveryIdList = [];
//   var deliveryId = 1;
//   int selectedIndex = 0;
//   int selectedWeekNumber = 1;
//   String selectedMealType = '1401';
//   int mealIndex = 0;
//   final planmealcustinvoicedbhelper = PlanmealCustInvoiceDB.instance;
//   var transid;
//   var planid;
//   var mealType;
//   List selectedMeals = [];
//   List mealsList = [];
//   List allowedMealsList = [];
//   // bool mealsCompleted;

//   planMealSetupKitchen() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     print('PlanId:${prefs.get('id')}');
//     print('Customer Id:${prefs.get('custID')}');
//     print('Selected Date:$_selectedDate');
//     DateTime date = DateTime.now().add(const Duration(days: 2));
//     http.Response response = await http.post(
//         Uri.parse(
//             'https://foodapi.pos53.com/api/Food/PlanmealsetupKitchen_Get'),
//         body: {
//           'TenentID':TenentID.toString(),
//           'PlanID': '${prefs.get('id')}',
//           'MealType': selectedMealType == null
//               ? '${prefs.get('mealType')}'
//               : selectedMealType,
//           'Date': _selectedDate == null
//               ? '${date.month} - ${date.day} - ${date.year}'
//               : _selectedDate
//         });
//     if (jsonDecode(response.body)['status'] == 200) {
//       return jsonDecode(response.body)['data'];
//     } else {
//       return jsonDecode(response.body);
//     }
//   }

//   getMenuFromMealtType(mealtype) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     DateTime date = DateTime.now().add(const Duration(days: 2));
//     http.Response response = await http.post(
//         Uri.parse(
//             'https://foodapi.pos53.com/api/Food/PlanmealsetupKitchen_Get'),
//         body: {
//           'TenentID':TenentID.toString(),
//           'PlanID': '${prefs.get('id')}',
//           'MealType': mealtype,
//           'Date': _selectedDate == null
//               ? '${date.month} - ${date.day} - ${date.year}'
//               : _selectedDate
//         });
//     if (jsonDecode(response.body)['status'] == 200) {
//       return jsonDecode(response.body)['data'];
//     } else {
//       return jsonDecode(response.body);
//     }
//   }

//   // void _queryMain(int selectedWeek) async {
//   // weekDate.clear();
//   // weekDay.cast();
//   // final allRows = await planmealcustinvoicedbhelper.queryAllRows(
//   //     selectedWeek, selectedMealType);
//   // print('query all rows:');
//   // allRows.forEach(print);
//   // allRows.forEach((element) {
//   //   setState(() {
//   //     totalWeek = element['totalWeek'];
//   //   });
//   // });
//   // allRows.forEach((element) {
//   //   weekDate.add(element['expectedDelDate']);
//   //   weekDay.add(element['nameOfDay']);
//   // });
//   // generateWeekList(totalWeek);
//   // generateMealTitleList();
//   // print(totalWeek);
//   // }

//   _queryDeliveryId(rEdd) async {
//     deliveryIdList.clear();
//     final rows = await planmealcustinvoicedbhelper.queryDeliveryID(rEdd);
//     // print('Delivery IDs:');
//     // rows.forEach(print);
//     rows.forEach((element) {
//       deliveryIdList.add(element['deliveryId']);
//     });
//   }

//   _queryMealTypes() async {
//     List mealsTypeList = [];
//     final rows = await planmealcustinvoicedbhelper.queryMealTypes();
//     rows.forEach(print);
//     rows.forEach((element) {
//       mealsTypeList.add(element['mealType']);
//     });
//     return mealsTypeList;
//   }

//   void _query(int selectedWeek) async {
//     weekDate.clear();
//     weekDay.clear();
//     expectedDelDayList.clear();
//     deliveryIdList.clear();
//     final allRows = await planmealcustinvoicedbhelper.queryAllRows(
//         selectedWeek, selectedMealType);
//     print('Query all rows:');
//     allRows.forEach(print);
//     allRows.forEach((element) {
//       setState(() {
//         totalWeek = element['totalWeek'];
//       });
//     });
//     allRows.forEach((element) {
//       weekDate.add(element['expectedDelDate']);
//       weekDay.add(element['nameOfDay']);
//       expectedDelDayList.add(element['expectedDeliveryDay']);
//     });
//     generateWeekList(totalWeek);
//     generateMealTitleList();
//     // print(totalWeek);
//   }

//   _querySelected(int rTenentId, int rMyTransId, int rDeliveryId,
//       int rExpectedDeliveryDay, int rPlanid, int rMealtype) async {
//     final rows = await planmealcustinvoicedbhelper.querySelected(rTenentId,
//         rMyTransId, rDeliveryId, rExpectedDeliveryDay, rPlanid, rMealtype);
//     print('Switch5 query:');
//     rows.forEach(print);
//     rows.forEach((element) {
//       selectedMeals.add(element['switch5']);
//     });
//     return rows;
//   }

//   generateWeekList(int weeks) {
//     List<String> listofWeeks = [];
//     for (int i = 1; i <= weeks; i++) {
//       listofWeeks.add('Week $i');
//     }
//     return listofWeeks;
//   }

//   getInstances() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs != null) {
//       return prefs;
//     } else {
//       return null;
//     }
//   }

//   initData() async {
//     var prefs = await getInstances();
//     transid = prefs.get('myTransId');
//     planid = prefs.get('id');
//     mealType = prefs.get('mealType');
//   }

//   generateMealTitleList() async {
//     var prefs = await getInstances();
//     var planid = prefs.get('id');
//     mealsList.clear();
//     final String response =
//         await rootBundle.loadString('assets/json/getpackagewithplanmeal.json');
//     var rData = jsonDecode(response.toString());
//     rData[planid.toString()].forEach((element) {
//       if (element['planid'] == planid) {
//         mealsList.add(element['Meal_Eng']);
//       }
//     });
//     return mealsList;
//   }

//   giveAllowedMeals() async {
//     var prefs = await getInstances();
//     var planid = prefs.get('id');
//     allowedMealsList.clear();
//     final String response =
//         await rootBundle.loadString('assets/json/getpackagewithplanmeal.json');
//     var rData = jsonDecode(response.toString());
//     rData[planid.toString()].forEach((element) {
//       if (element['planid'] == planid) {
//         allowedMealsList.add(element['Allowed_Meal']);
//       }
//     });
//   }

//   checkFunction(int index, bool value, int allowedM) {
//     int count = 0;
//     if (count > allowedM) {
//       return false;
//     } else {
//       if (value == true) {
//         //update db
//       } else {
//         //update db with null values
//       }
//     }
//   }

//   updateRow(var snap, mealtype) async {
//     final rows = _querySelected(
//         14, transid, deliveryId, expectedDelDay, planid, mealType);
//     print('Delivery ID:$deliveryId');
//     print('Expected del Day:$expectedDelDay');
//     print('Meal Type:$selectedMealType');
//     var id = await planmealcustinvoicedbhelper.updateUsingRawQuery(
//         snap['MYPRODID'],
//         snap['UOM'],
//         snap['Item_cost'],
//         snap['Calories'],
//         snap['Protein'],
//         snap['Carbs'],
//         snap['Fat'],
//         snap['ItemWeight'],
//         snap['ProdName1'],
//         'Note by user',
//         'Note by user for short remark',
//         14,
//         transid,
//         deliveryId,
//         expectedDelDay,
//         planid,
//         mealtype);
//     print('number of rows changed:$id');
//     _query(selectedWeekNumber);
//   }

//   dateSelectClick(int index) {}

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initData();
//     _query(selectedWeekNumber);
//     _queryDeliveryId(expectedDelDay);
//     planMealSetupKitchen();
//     _queryMealTypes();
//     giveAllowedMeals();
//     initData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size medq = MediaQuery.of(context).size;
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         bottomNavigationBar: BottomAppBar(
//           color: BeHealthyTheme.kMainOrange.withOpacity(0.27),
//           //shape: CircularNotchedRectangle(),
//           //notchMargin: 4.0,
//           elevation: 100,
//           child: new Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               GestureDetector(
//                 onTap: () {
//                   displayBottomSheet();
//                 },
//                 child: Image.asset(
//                   'assets/images/Group 99.png',
//                   width: 30,
//                   height: 30,
//                   color: BeHealthyTheme.kMainOrange,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   // _queryDeliveryId(expectedDelDay);

//                   // var data = await planmealcustinvoicedbhelper.querySomeRows(
//                   //     selectedWeekNumber, selectedMealType, _selectedDate);
//                   // print('Selected Query:');
//                   // data.forEach(print);
//                   // _query(3);
//                   // generateWeekList(totalWeek);
//                   // generateMealTitleList();
//                   // Navigator.push(context,
//                   //     MaterialPageRoute(builder: (context) => CartCheckout()));
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => HomePage()));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8, bottom: 12),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width - 150,
//                     height: 45,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: Colors.greenAccent[400],
//                         borderRadius: BorderRadius.circular(25)),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Continue ',
//                           style: BeHealthyTheme.kMainTextStyle
//                               .copyWith(fontSize: 18, color: Colors.white),
//                         ),
//                         Icon(
//                           Icons.arrow_forward_ios,
//                           size: 20,
//                           color: Colors.white,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Positioned(
//                 //     top: -medq.height * 0.57,
//                 //     child: Image(
//                 //       image: AssetImage('assets/images/Path 29.png'),
//                 //     )),
//                 // Positioned(
//                 //   top: medq.height / 25,
//                 //   left: 0,
//                 //   child: IconButton(
//                 //       icon: Icon(
//                 //         Icons.arrow_back_ios,
//                 //         color: Colors.white,
//                 //         size: 25,
//                 //       ),
//                 //       onPressed: () {
//                 //         Navigator.push(context,
//                 //             MaterialPageRoute(builder: (context) => BasicPlan()));
//                 //       }),
//                 // ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Text(
//                         'Meal Selection',
//                         style: BeHealthyTheme.kMainTextStyle.copyWith(
//                             color: BeHealthyTheme.kMainOrange,
//                             fontSize: 25,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 10.0),
//                       child: Text(
//                         'اختيار الوجبة',
//                         style: BeHealthyTheme.kMainTextStyle.copyWith(
//                           fontSize: 23,
//                           color: BeHealthyTheme.kMainOrange,
//                         ),
//                       ),
//                     ),
//                     // Container(
//                     //   child: Padding(
//                     //     padding: const EdgeInsets.only(right: 10),
//                     //     child: Image(
//                     //         width: 40,
//                     //         height: 40,
//                     //         color: BeHealthyTheme.kMainOrange,
//                     //         image: AssetImage('assets/images/bh_logo.png')),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 // Positioned(
//                 //     top: -medq.height * 0.35,
//                 //     left: medq.width * 0.65,
//                 //     child: Image(
//                 //         width: 71,
//                 //         height: 455,
//                 //         image: AssetImage('assets/images/login_lamp.png'))),

//                 // Positioned(
//                 //     bottom: 0,
//                 //     child:
//                 //         Image(image: AssetImage('assets/images/Untitled-1.png'))),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: medq.width - 30,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           SizedBox(width: 10),
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: BeHealthyTheme.kMainOrange,
//                             ),
//                             child: DropdownButton<String>(
//                               focusColor: Colors.white,
//                               value: _chosenWeek,
//                               dropdownColor: BeHealthyTheme.kMainOrange,
//                               underline: Container(),
//                               elevation: 0,
//                               icon: Icon(
//                                 Icons.arrow_drop_down,
//                                 color: Colors.white,
//                               ),
//                               iconDisabledColor: Colors.white,
//                               //elevation: 5,
//                               iconEnabledColor: Colors.black,
//                               items: generateWeekList(totalWeek)
//                                   .map<DropdownMenuItem<String>>(
//                                       (String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10),
//                                     child: Text(
//                                       value,
//                                       style: BeHealthyTheme.kMainTextStyle
//                                           .copyWith(color: Colors.white),
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               onChanged: (String value) {
//                                 setState(() {
//                                   _chosenWeek = value;
//                                   switch (value) {
//                                     case 'Week 1':
//                                       {
//                                         print(value);
//                                         _query(1);
//                                         selectedWeekNumber = 1;
//                                       }
//                                       break;
//                                     case 'Week 2':
//                                       {
//                                         print(value);
//                                         _query(2);
//                                         selectedWeekNumber = 2;
//                                       }
//                                       break;
//                                     case 'Week 3':
//                                       {
//                                         print(value);
//                                         _query(3);
//                                         selectedWeekNumber = 3;
//                                       }
//                                       break;
//                                     case 'Week 4':
//                                       {
//                                         print(value);
//                                         _query(4);
//                                         selectedWeekNumber = 4;
//                                       }
//                                       break;
//                                     case 'Week 5':
//                                       {
//                                         print(value);
//                                         _query(5);
//                                         selectedWeekNumber = 5;
//                                       }
//                                       break;
//                                     default:
//                                       {
//                                         _query(1);
//                                         selectedWeekNumber = 1;
//                                       }
//                                       break;
//                                   }
//                                   final rows = _querySelected(
//                                       14,
//                                       transid,
//                                       deliveryId,
//                                       expectedDelDay,
//                                       planid,
//                                       mealType);
//                                 });
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           // FutureBuilder(
//                           //     future: generateMealTitleList(),
//                           //     builder: (context, snap) {
//                           //       return Container(
//                           //         decoration: BoxDecoration(
//                           //           borderRadius: BorderRadius.circular(10),
//                           //           color: BeHealthyTheme.kMainOrange,
//                           //         ),
//                           //         child: DropdownButton<String>(
//                           //           underline: Container(),
//                           //           focusColor: Colors.white,
//                           //           value: _chosenMeal,
//                           //           dropdownColor: BeHealthyTheme.kMainOrange,
//                           //           elevation: 0,
//                           //           icon: Icon(
//                           //             Icons.arrow_drop_down,
//                           //             color: Colors.white,
//                           //           ),
//                           //           iconDisabledColor: Colors.white,
//                           //           //elevation: 5,
//                           //           iconEnabledColor: Colors.black,
//                           //           items: snap.data
//                           //               .map<DropdownMenuItem<String>>(
//                           //                   (String value) {
//                           //             return DropdownMenuItem<String>(
//                           //               value: value,
//                           //               child: Padding(
//                           //                 padding: const EdgeInsets.symmetric(
//                           //                     horizontal: 10),
//                           //                 child: Text(
//                           //                   value,
//                           //                   style: BeHealthyTheme.kMainTextStyle
//                           //                       .copyWith(color: Colors.white),
//                           //                 ),
//                           //               ),
//                           //             );
//                           //           }).toList(),
//                           //           onChanged: (String value) {
//                           //             setState(() {
//                           //               _chosenMeal = value;
//                           //               switch (value) {
//                           //                 case 'Breakfast':
//                           //                   {
//                           //                     selectedMealType = '1401';
//                           //                     mealIndex = 0;
//                           //                     // print(
//                           //                     //     'Expected Del Day:$expectedDelDay');

//                           //                     // _queryDeliveryId(expectedDelDay);
//                           //                     // deliveryId = deliveryIdList[0];
//                           //                     _querySelected(
//                           //                         14,
//                           //                         transid,
//                           //                         deliveryId,
//                           //                         expectedDelDay,
//                           //                         planid,
//                           //                         mealType);
//                           //                   }
//                           //                   break;
//                           //                 case 'Lunch':
//                           //                   {
//                           //                     selectedMealType = '1402';
//                           //                     mealIndex = 1;

//                           //                     // print(
//                           //                     //     'Expected Del Day:$expectedDelDay');

//                           //                     // _queryDeliveryId(expectedDelDay);
//                           //                     // deliveryId = deliveryIdList[1];
//                           //                     _querySelected(
//                           //                         14,
//                           //                         transid,
//                           //                         deliveryId,
//                           //                         expectedDelDay,
//                           //                         planid,
//                           //                         mealType);
//                           //                   }
//                           //                   break;
//                           //                 case 'Dinner':
//                           //                   {
//                           //                     selectedMealType = '1403';
//                           //                     mealIndex = 2;

//                           //                     // print(
//                           //                     //     'Expected Del Day:$expectedDelDay');
//                           //                     // _queryDeliveryId(expectedDelDay);
//                           //                     // deliveryId = deliveryIdList[2];
//                           //                     _querySelected(
//                           //                         14,
//                           //                         transid,
//                           //                         deliveryId,
//                           //                         expectedDelDay,
//                           //                         planid,
//                           //                         mealType);
//                           //                   }
//                           //                   break;
//                           //                 case 'Snack':
//                           //                   {
//                           //                     selectedMealType = '1404';
//                           //                     mealIndex = 3;

//                           //                     // print(
//                           //                     //     'Expected Del Day:$expectedDelDay');
//                           //                     // _queryDeliveryId(expectedDelDay);
//                           //                     // deliveryId = deliveryIdList[3];
//                           //                     // dateSelectClick(selectedIndex);
//                           //                     _querySelected(
//                           //                         14,
//                           //                         transid,
//                           //                         deliveryId,
//                           //                         expectedDelDay,
//                           //                         planid,
//                           //                         mealType);
//                           //                   }
//                           //                   break;
//                           //                 case 'Salad':
//                           //                   {
//                           //                     selectedMealType = '1405';
//                           //                     mealIndex = 4;

//                           //                     // print(
//                           //                     //     'Expected Del Day:$expectedDelDay');
//                           //                     // _queryDeliveryId(expectedDelDay);
//                           //                     // deliveryId = deliveryIdList[4];
//                           //                     // dateSelectClick(selectedIndex);
//                           //                     _querySelected(
//                           //                         14,
//                           //                         transid,
//                           //                         deliveryId,
//                           //                         expectedDelDay,
//                           //                         planid,
//                           //                         mealType);
//                           //                   }
//                           //                   break;
//                           //                 default:
//                           //                   {
//                           //                     selectedMealType = '1401';
//                           //                     mealIndex = 0;
//                           //                     // _queryDeliveryId(expectedDelDay);
//                           //                     // deliveryId = deliveryIdList[0];
//                           //                     // dateSelectClick(selectedIndex);
//                           //                     _querySelected(
//                           //                         14,
//                           //                         transid,
//                           //                         deliveryId,
//                           //                         expectedDelDay,
//                           //                         planid,
//                           //                         mealType);
//                           //                   }
//                           //                   break;
//                           //               }
//                           //             });
//                           //           },
//                           //         ),
//                           //       );
//                           //     }),
//                           // SizedBox(width: 10),
//                           // Container(
//                           //     decoration: BoxDecoration(
//                           //       borderRadius: BorderRadius.circular(10),
//                           //       color: BeHealthyTheme.kMainOrange,
//                           //     ),
//                           //     child: FutureBuilder(
//                           //       future: giveAllowedMeals(),
//                           //       builder: (context, snapshot) {
//                           //         allowedMeals = snapshot.data[mealIndex];
//                           //         return Padding(
//                           //           padding: const EdgeInsets.symmetric(
//                           //               horizontal: 10, vertical: 14),
//                           //           child: Text(
//                           //             '    ${snapshot.data[mealIndex]}    ',
//                           //             style: BeHealthyTheme.kMainTextStyle
//                           //                 .copyWith(color: Colors.white),
//                           //           ),
//                           //         );
//                           //       },
//                           //     ))
//                         ],
//                       ),
//                     ),
//                     // Container(
//                     //   margin: EdgeInsets.symmetric(vertical: 20.0),
//                     //   width: MediaQuery.of(context).size.width - 40,
//                     //   child: DatePicker(
//                     //     DateTime.now().add(const Duration(days: 2)),
//                     //     daysCount: 6,
//                     //     initialSelectedDate:
//                     //         DateTime.now().add(const Duration(days: 2)),
//                     //     selectionColor: BeHealthyTheme.kMainOrange,
//                     //     selectedTextColor: Colors.white,
//                     //     onDateChange: (date) {
//                     //       // New date selected
//                     //       setState(() {
//                     //         _selectedDate = date;
//                     //       });
//                     //     },
//                     //   ),
//                     // ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Container(
//                         // margin: EdgeInsets.symmetric(vertical: 10),
//                         width: medq.width,
//                         height: medq.height * 0.09,
//                         child: ListView.builder(
//                             physics: BouncingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             itemCount: weekDate.length,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 8, horizontal: 5),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // setState(() {
//                                     //   dateSelectClick(index);
//                                     // });
//                                     setState(() {
//                                       selectedIndex = index;
//                                       _selectedDate = weekDate[index];
//                                       expectedDelDay =
//                                           expectedDelDayList[index];
//                                       _queryDeliveryId(expectedDelDay);
//                                       deliveryId = deliveryIdList[index];
//                                       print(
//                                           'Delivery ID Changed:$deliveryId from $deliveryIdList');
//                                       print(
//                                           'Expected DAY Changed:$expectedDelDay from $expectedDelDayList');
//                                       selectedMeals.clear();
//                                       planMealSetupKitchen();
//                                     });
//                                     _querySelected(
//                                         14,
//                                         transid,
//                                         deliveryId,
//                                         expectedDelDay,
//                                         planid,
//                                         int.parse(mealType));
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: selectedIndex == index
//                                           ? BeHealthyTheme.kMainOrange
//                                           : BeHealthyTheme.kMainOrange
//                                               .withOpacity(0.11),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 12),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             '${weekDate[index].substring(3, 5)}',
//                                             style: BeHealthyTheme.kDhaaTextStyle
//                                                 .copyWith(
//                                                     color:
//                                                         selectedIndex == index
//                                                             ? Colors.white
//                                                             : BeHealthyTheme
//                                                                 .kMainOrange,
//                                                     fontSize: 25),
//                                           ),
//                                           Text(
//                                             '${weekDay[index]}',
//                                             style: BeHealthyTheme.kDhaaTextStyle
//                                                 .copyWith(
//                                                     color:
//                                                         selectedIndex == index
//                                                             ? Colors.white
//                                                             : BeHealthyTheme
//                                                                 .kMainOrange,
//                                                     fontSize: 14),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                       ),
//                     ),
//                     // FutureBuilder(
//                     //   future: _queryMealTypes(),
//                     //   builder: (context, snap) {
//                     //     if (snap.connectionState == ConnectionState.waiting) {
//                     //       return Center(
//                     //         child: CircularProgressIndicator(),
//                     //       );
//                     //     } else {
//                     //       if (!snap.hasData)
//                     //         return Center(
//                     //           child: CircularProgressIndicator(),
//                     //         );
//                     //       else
//                     //         return Container(
//                     //           height: medq.height *
//                     //               0.28 *
//                     //               double.parse(snap.data.length.toString()),
//                     //           width: medq.width,
//                     //           child: ListView.builder(
//                     //               itemCount: snap.data.length,
//                     //               itemBuilder: (context, index) {
//                     //                 return FutureBuilder(
//                     //                   future: getMenuFromMealtType(
//                     //                       '${snap.data[index]}'),
//                     //                   builder: (context, snapshot) {
//                     //                     if (snapshot.connectionState ==
//                     //                         ConnectionState.waiting) {
//                     //                       return Center(
//                     //                           child:
//                     //                               CircularProgressIndicator());
//                     //                     } else {
//                     //                       if (snapshot.hasData) {
//                     //                         // final List<Item> _data =
//                     //                         //     generateItems(snapshot.data);
//                     //                         return Padding(
//                     //                           padding:
//                     //                               const EdgeInsets.all(8.0),
//                     //                           child: Container(
//                     //                             // decoration: BoxDecoration(
//                     //                             //     borderRadius: BorderRadius.circular(15),
//                     //                             //     color: BeHealthyTheme.kMainOrange
//                     //                             //         .withOpacity(0.11)),
//                     //                             child: Column(
//                     //                               children: [
//                     //                                 Text(
//                     //                                   '${snap.data[index]}',
//                     //                                   style: BeHealthyTheme
//                     //                                       .kMainTextStyle
//                     //                                       .copyWith(
//                     //                                           color: BeHealthyTheme
//                     //                                               .kMainOrange,
//                     //                                           fontSize: 22),
//                     //                                 ),
//                     //                                 Container(
//                     //                                   height:
//                     //                                       medq.height * 0.25,
//                     //                                   child: ListView(
//                     //                                     scrollDirection:
//                     //                                         Axis.horizontal,
//                     //                                     children: snapshot.data
//                     //                                         .map<Widget>(
//                     //                                             (var product) {
//                     //                                       return CustomGridItem(
//                     //                                         title:
//                     //                                             '${product['ProdName1']}',
//                     //                                         imageUrl: product[
//                     //                                             'ProdName3'],
//                     //                                       );
//                     //                                     }).toList(),
//                     //                                   ),
//                     //                                 ),
//                     //                               ],
//                     //                             ),
//                     //                           ),
//                     //                         );
//                     //                       } else {
//                     //                         return Text(
//                     //                           'Network Error',
//                     //                           style:
//                     //                               BeHealthyTheme.kMainTextStyle,
//                     //                         );
//                     //                       }
//                     //                     }
//                     //                   },
//                     //                 );
//                     //               }),
//                     //         );
//                     //     }
//                     //   },
//                     // ),
//                     FutureBuilder(
//                       future: getMenuFromMealtType('1401'),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         } else {
//                           if (snapshot.hasData) {
//                             // final List<Item> _data =
//                             //     generateItems(snapshot.data);
//                             int am = allowedMealsList[0];

//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 // decoration: BoxDecoration(
//                                 //     borderRadius: BorderRadius.circular(15),
//                                 //     color: BeHealthyTheme.kMainOrange
//                                 //         .withOpacity(0.11)),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       'Breakfast   $am',
//                                       style: BeHealthyTheme.kMainTextStyle
//                                           .copyWith(
//                                               color: BeHealthyTheme.kMainOrange,
//                                               fontSize: 22),
//                                     ),
//                                     Container(
//                                       height: medq.height * 0.25,
//                                       width: medq.width,
//                                       child: ListView(
//                                         scrollDirection: Axis.horizontal,
//                                         children: snapshot.data
//                                             .map<Widget>((var product) {
//                                           return CustomGridItem(
//                                             title: '${product['ProdName1']}',
//                                             imageUrl: product['ProdName3'],
//                                             onTap: () {
//                                               updateRow(product, am);
//                                               // rows.forEach((element) {
//                                               //   Map<String, dynamic> newRow = {
//                                               //     // PlanmealCustInvoiceDB.columnId: i++,
//                                               //     PlanmealCustInvoiceDB
//                                               //             .tenentId:
//                                               //         element['TenentID'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .mytransid:
//                                               //         element['MYTRANSID'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .deliveryId:
//                                               //         element['DeliveryID'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .myprodid:
//                                               //         element['MYPRODID'],
//                                               //     PlanmealCustInvoiceDB.uom:
//                                               //         element['UOM'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .locationId:
//                                               //         element['LOCATION_ID'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .customerId:
//                                               //         element['CustomerID'],
//                                               //     PlanmealCustInvoiceDB.planid:
//                                               //         element['planid'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .mealType:
//                                               //         element['MealType'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .prodName1:
//                                               //         element['ProdName1'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .oprationDay:
//                                               //         element['OprationDay'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .dayNumber:
//                                               //         element['DayNumber'],
//                                               //     PlanmealCustInvoiceDB.transId:
//                                               //         element['TransID'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .contractId:
//                                               //         element['ContractID'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .weekofDay:
//                                               //         element['WeekofDay'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .nameOfDay:
//                                               //         element['NameOfDay'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .totalWeek:
//                                               //         element['TotalWeek'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .noOfWeek:
//                                               //         element['NoOfWeek'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .displayWeek:
//                                               //         element['DisplayWeek'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .totalDeliveryDay:
//                                               //         element[
//                                               //             'TotalDeliveryDay'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .actualDeliveryDay:
//                                               //         element[
//                                               //             'ActualDeliveryDay'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .expectedDeliveryDay:
//                                               //         element[
//                                               //             'ExpectedDeliveryDay'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .deliveryTime:
//                                               //         element['DeliveryTime'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .deliveryMeal:
//                                               //         element['DeliveryMeal'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .driverId:
//                                               //         element['DriverID'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .startDate:
//                                               //         element['StartDate'],
//                                               //     PlanmealCustInvoiceDB.endDate:
//                                               //         element['EndDate'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .expectedDelDate:
//                                               //         element[
//                                               //             'ExpectedDelDate'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .actualDelDate:
//                                               //         element['ActualDelDate'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .nExtDeliveryDate:
//                                               //         element[
//                                               //             'NExtDeliveryDate'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .returnReason:
//                                               //         element['ReturnReason'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .reasonDate:
//                                               //         element['ReasonDate'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .productionDate:
//                                               //         element['ProductionDate'],
//                                               //     PlanmealCustInvoiceDB.chiefId:
//                                               //         element['chiefID'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .subscriptonDayNumber:
//                                               //         element[
//                                               //             'SubscriptonDayNumber'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .calories:
//                                               //         element['Calories'],
//                                               //     PlanmealCustInvoiceDB.protein:
//                                               //         element['Protein'],
//                                               //     PlanmealCustInvoiceDB.fat:
//                                               //         element['Fat'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .itemWeight:
//                                               //         element['ItemWeight'],
//                                               //     PlanmealCustInvoiceDB.carbs:
//                                               //         element['Carbs'],
//                                               //     PlanmealCustInvoiceDB.qty:
//                                               //         element['Qty'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .itemCost:
//                                               //         element['Item_cost'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .itemPrice:
//                                               //         element['Item_price'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .totalprice:
//                                               //         element['Totalprice'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .shortRemark:
//                                               //         element['ShortRemark'],
//                                               //     PlanmealCustInvoiceDB.active:
//                                               //         element['ACTIVE'],
//                                               //     PlanmealCustInvoiceDB.crupid:
//                                               //         element['CRUPID'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .changesDate:
//                                               //         element['ChangesDate'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .deliverySequence:
//                                               //         element[
//                                               //             'DeliverySequence'],
//                                               //     PlanmealCustInvoiceDB.switch1:
//                                               //         element['Switch1'],
//                                               //     PlanmealCustInvoiceDB.switch2:
//                                               //         element['Switch2'],
//                                               //     PlanmealCustInvoiceDB.switch3:
//                                               //         element['Switch3'],
//                                               //     PlanmealCustInvoiceDB.switch4:
//                                               //         element['Switch4'],
//                                               //     PlanmealCustInvoiceDB.switch5:
//                                               //         element['Switch5'],
//                                               //     PlanmealCustInvoiceDB.status:
//                                               //         element['Status'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .uploadDate:
//                                               //         element['UploadDate'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .uploadby:
//                                               //         element['Uploadby'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .syncDate:
//                                               //         element['SyncDate'],
//                                               //     PlanmealCustInvoiceDB.syncby:
//                                               //         element['Syncby'],
//                                               //     PlanmealCustInvoiceDB.synId:
//                                               //         element['SynID'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .syncStatus:
//                                               //         element['syncStatus'],
//                                               //     PlanmealCustInvoiceDB.localId:
//                                               //         element['LocalID'],
//                                               //     PlanmealCustInvoiceDB
//                                               //             .offlineStatus:
//                                               //         element['OfflineStatus']
//                                               //   };
//                                               // });
//                                             },
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return Text(
//                               'Network Error',
//                               style: BeHealthyTheme.kMainTextStyle,
//                             );
//                           }
//                         }
//                       },
//                     ),

//                     FutureBuilder(
//                       future: getMenuFromMealtType('1402'),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         } else {
//                           if (snapshot.hasData) {
//                             int am = allowedMealsList[1];
//                             // final List<Item> _data =
//                             //     generateItems(snapshot.data);
//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 // decoration: BoxDecoration(
//                                 //     borderRadius: BorderRadius.circular(15),
//                                 //     color: BeHealthyTheme.kMainOrange
//                                 //         .withOpacity(0.11)),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       'Lunch  $am',
//                                       style: BeHealthyTheme.kMainTextStyle
//                                           .copyWith(
//                                               color: BeHealthyTheme.kMainOrange,
//                                               fontSize: 22),
//                                     ),
//                                     Container(
//                                       height: medq.height * 0.25,
//                                       child: ListView(
//                                         scrollDirection: Axis.horizontal,
//                                         children: snapshot.data
//                                             .map<Widget>((var product) {
//                                           return CustomGridItem(
//                                             title: '${product['ProdName1']}',
//                                             imageUrl: product['ProdName3'],
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return Text(
//                               'Network Error',
//                               style: BeHealthyTheme.kMainTextStyle,
//                             );
//                           }
//                         }
//                       },
//                     ),
//                     FutureBuilder(
//                       future: getMenuFromMealtType('1403'),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         } else {
//                           if (snapshot.hasData) {
//                             // final List<Item> _data =
//                             //     generateItems(snapshot.data);
//                             int am = allowedMealsList[2];
//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 // decoration: BoxDecoration(
//                                 //     borderRadius: BorderRadius.circular(15),
//                                 //     color: BeHealthyTheme.kMainOrange
//                                 //         .withOpacity(0.11)),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       'Dinner   $am',
//                                       style: BeHealthyTheme.kMainTextStyle
//                                           .copyWith(
//                                               color: BeHealthyTheme.kMainOrange,
//                                               fontSize: 22),
//                                     ),
//                                     Container(
//                                       height: medq.height * 0.25,
//                                       child: ListView(
//                                         scrollDirection: Axis.horizontal,
//                                         children: snapshot.data
//                                             .map<Widget>((var product) {
//                                           return CustomGridItem(
//                                             title: '${product['ProdName1']}',
//                                             imageUrl: product['ProdName3'],
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return Text(
//                               'Network Error',
//                               style: BeHealthyTheme.kMainTextStyle,
//                             );
//                           }
//                         }
//                       },
//                     ),
//                     FutureBuilder(
//                       future: getMenuFromMealtType('1404'),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         } else {
//                           if (snapshot.hasData) {
//                             // final List<Item> _data =
//                             //     generateItems(snapshot.data);
//                             int am = allowedMealsList[3];
//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 // decoration: BoxDecoration(
//                                 //     borderRadius: BorderRadius.circular(15),
//                                 //     color: BeHealthyTheme.kMainOrange
//                                 //         .withOpacity(0.11)),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       'Snack   $am',
//                                       style: BeHealthyTheme.kMainTextStyle
//                                           .copyWith(
//                                               color: BeHealthyTheme.kMainOrange,
//                                               fontSize: 22),
//                                     ),
//                                     Container(
//                                       height: medq.height * 0.25,
//                                       child: ListView(
//                                         scrollDirection: Axis.horizontal,
//                                         children: snapshot.data
//                                             .map<Widget>((var product) {
//                                           return CustomGridItem(
//                                             title: '${product['ProdName1']}',
//                                             imageUrl: product['ProdName3'],
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return Text(
//                               'Network Error',
//                               style: BeHealthyTheme.kMainTextStyle,
//                             );
//                           }
//                         }
//                       },
//                     ),
//                     FutureBuilder(
//                       future: getMenuFromMealtType('1405'),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         } else {
//                           if (snapshot.hasData) {
//                             // final List<Item> _data =
//                             //     generateItems(snapshot.data);
//                             int am = allowedMealsList[4];
//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 // decoration: BoxDecoration(
//                                 //     borderRadius: BorderRadius.circular(15),
//                                 //     color: BeHealthyTheme.kMainOrange
//                                 //         .withOpacity(0.11)),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       'Salad   $am',
//                                       style: BeHealthyTheme.kMainTextStyle
//                                           .copyWith(
//                                               color: BeHealthyTheme.kMainOrange,
//                                               fontSize: 22),
//                                     ),
//                                     Container(
//                                       height: medq.height * 0.25,
//                                       child: ListView(
//                                         scrollDirection: Axis.horizontal,
//                                         children: snapshot.data
//                                             .map<Widget>((var product) {
//                                           return CustomGridItem(
//                                             title: '${product['ProdName1']}',
//                                             imageUrl: product['ProdName3'],
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return Text(
//                               'Network Error',
//                               style: BeHealthyTheme.kMainTextStyle,
//                             );
//                           }
//                         }
//                       },
//                     ),
//                     // FutureBuilder(
//                     //   future: getMenuFromMealtType('1401'),
//                     //   builder: (context, snapshot) {
//                     //     if (snapshot.connectionState ==
//                     //         ConnectionState.waiting) {
//                     //       return Center(child: CircularProgressIndicator());
//                     //     } else {
//                     //       if (snapshot.hasData) {
//                     //         return Padding(
//                     //           padding: const EdgeInsets.all(8.0),
//                     //           child: Container(
//                     //             decoration: BoxDecoration(
//                     //                 borderRadius: BorderRadius.circular(15),
//                     //                 color: BeHealthyTheme.kMainOrange),
//                     //             child: ExpansionTile(
//                     //               onExpansionChanged: (bool a) {
//                     //                 mealType = '1401';
//                     //                 _queryDeliveryId(expectedDelDay);
//                     //                 deliveryId = deliveryIdList[0];
//                     //                 print('Delivery Id:$deliveryId');
//                     //               },
//                     //               title: Text(
//                     //                 'Breakfast',
//                     //                 style: BeHealthyTheme.kMainTextStyle
//                     //                     .copyWith(
//                     //                         color: Colors.white, fontSize: 20),
//                     //               ),
//                     //               children:
//                     //                   snapshot.data.map<Widget>((var element) {
//                     //                 return ListTile(
//                     //                   leading: Text(
//                     //                     '${element['ProdName1']}',
//                     //                     style: BeHealthyTheme.kMainTextStyle
//                     //                         .copyWith(
//                     //                             color: Colors.white,
//                     //                             fontSize: 15),
//                     //                   ),
//                     //                   trailing: GestureDetector(
//                     //                     onTap: () {
//                     //                       print(mealType);
//                     //                     },
//                     //                     child: Container(
//                     //                       height: 10,
//                     //                       width: 10,
//                     //                       color: Colors.white,
//                     //                     ),
//                     //                   ),
//                     //                 );
//                     //               }).toList(),
//                     //             ),
//                     //           ),
//                     //         );
//                     //       } else {
//                     //         return Text(
//                     //           'Network Error',
//                     //           style: BeHealthyTheme.kMainTextStyle,
//                     //         );
//                     //       }
//                     //     }
//                     //   },
//                     // ),
//                     // FutureBuilder(
//                     //   future: getMenuFromMealtType('1402'),
//                     //   builder: (context, snapshot) {
//                     //     if (snapshot.connectionState ==
//                     //         ConnectionState.waiting) {
//                     //       return Center(child: CircularProgressIndicator());
//                     //     } else {
//                     //       if (snapshot.hasData) {
//                     //         return Padding(
//                     //           padding: const EdgeInsets.all(8.0),
//                     //           child: Container(
//                     //             decoration: BoxDecoration(
//                     //                 borderRadius: BorderRadius.circular(15),
//                     //                 color: BeHealthyTheme.kMainOrange),
//                     //             child: ExpansionTile(
//                     //               onExpansionChanged: (bool a) {
//                     //                 mealType = '1402';
//                     //                 _queryDeliveryId(expectedDelDay);
//                     //                 deliveryId = deliveryIdList[1];
//                     //                 print('Delivery Id:$deliveryId');
//                     //               },
//                     //               title: Text(
//                     //                 'Lunch',
//                     //                 style: BeHealthyTheme.kMainTextStyle
//                     //                     .copyWith(
//                     //                         color: Colors.white, fontSize: 20),
//                     //               ),
//                     //               children:
//                     //                   snapshot.data.map<Widget>((var element) {
//                     //                 return ListTile(
//                     //                   leading: Text(
//                     //                     '${element['ProdName1']}',
//                     //                     style: BeHealthyTheme.kMainTextStyle
//                     //                         .copyWith(
//                     //                             color: Colors.white,
//                     //                             fontSize: 15),
//                     //                   ),
//                     //                   trailing: GestureDetector(
//                     //                     onTap: () {
//                     //                       print(mealType);
//                     //                     },
//                     //                     child: Container(
//                     //                       height: 10,
//                     //                       width: 10,
//                     //                       color: Colors.white,
//                     //                     ),
//                     //                   ),
//                     //                 );
//                     //               }).toList(),
//                     //             ),
//                     //           ),
//                     //         );
//                     //       } else {
//                     //         return Text(
//                     //           'Network Error',
//                     //           style: BeHealthyTheme.kMainTextStyle,
//                     //         );
//                     //       }
//                     //     }
//                     //   },
//                     // ),
//                     // FutureBuilder(
//                     //   future: getMenuFromMealtType('1403'),
//                     //   builder: (context, snapshot) {
//                     //     if (snapshot.connectionState ==
//                     //         ConnectionState.waiting) {
//                     //       return Center(child: CircularProgressIndicator());
//                     //     } else {
//                     //       if (snapshot.hasData) {
//                     //         return Padding(
//                     //           padding: const EdgeInsets.all(8.0),
//                     //           child: Container(
//                     //             decoration: BoxDecoration(
//                     //                 borderRadius: BorderRadius.circular(15),
//                     //                 color: BeHealthyTheme.kMainOrange),
//                     //             child: ExpansionTile(
//                     //               onExpansionChanged: (bool a) {
//                     //                 mealType = '1403';
//                     //                 _queryDeliveryId(expectedDelDay);
//                     //                 deliveryId = deliveryIdList[2];
//                     //                 print('Delivery Id:$deliveryId');
//                     //               },
//                     //               title: Text(
//                     //                 'Dinner',
//                     //                 style: BeHealthyTheme.kMainTextStyle
//                     //                     .copyWith(
//                     //                         color: Colors.white, fontSize: 20),
//                     //               ),
//                     //               children:
//                     //                   snapshot.data.map<Widget>((var element) {
//                     //                 return ListTile(
//                     //                   leading: Text(
//                     //                     '${element['ProdName1']}',
//                     //                     style: BeHealthyTheme.kMainTextStyle
//                     //                         .copyWith(
//                     //                             color: Colors.white,
//                     //                             fontSize: 15),
//                     //                   ),
//                     //                 );
//                     //               }).toList(),
//                     //             ),
//                     //           ),
//                     //         );
//                     //       } else {
//                     //         return Text(
//                     //           'Network Error',
//                     //           style: BeHealthyTheme.kMainTextStyle,
//                     //         );
//                     //       }
//                     //     }
//                     //   },
//                     // ),
//                     // FutureBuilder(
//                     //   future: getMenuFromMealtType('1404'),
//                     //   builder: (context, snapshot) {
//                     //     if (snapshot.connectionState ==
//                     //         ConnectionState.waiting) {
//                     //       return Center(child: CircularProgressIndicator());
//                     //     } else {
//                     //       if (snapshot.hasData) {
//                     //         return Padding(
//                     //           padding: const EdgeInsets.all(8.0),
//                     //           child: Container(
//                     //             decoration: BoxDecoration(
//                     //                 borderRadius: BorderRadius.circular(15),
//                     //                 color: BeHealthyTheme.kMainOrange),
//                     //             child: ExpansionTile(
//                     //               onExpansionChanged: (bool a) {
//                     //                 mealType = '1404';
//                     //                 _queryDeliveryId(expectedDelDay);
//                     //                 deliveryId = deliveryIdList[3];
//                     //                 print('Delivery Id:$deliveryId');
//                     //               },
//                     //               title: Text(
//                     //                 'Snack',
//                     //                 style: BeHealthyTheme.kMainTextStyle
//                     //                     .copyWith(
//                     //                         color: Colors.white, fontSize: 20),
//                     //               ),
//                     //               children:
//                     //                   snapshot.data.map<Widget>((var element) {
//                     //                 return ListTile(
//                     //                   leading: Text(
//                     //                     '${element['ProdName1']}',
//                     //                     style: BeHealthyTheme.kMainTextStyle
//                     //                         .copyWith(
//                     //                             color: Colors.white,
//                     //                             fontSize: 15),
//                     //                   ),
//                     //                 );
//                     //               }).toList(),
//                     //             ),
//                     //           ),
//                     //         );
//                     //       } else {
//                     //         return Text(
//                     //           'Network Error',
//                     //           style: BeHealthyTheme.kMainTextStyle,
//                     //         );
//                     //       }
//                     //     }
//                     //   },
//                     // ),
//                     // FutureBuilder(
//                     //   future: getMenuFromMealtType('1405'),
//                     //   builder: (context, snapshot) {
//                     //     if (snapshot.connectionState ==
//                     //         ConnectionState.waiting) {
//                     //       return Center(child: CircularProgressIndicator());
//                     //     } else {
//                     //       if (snapshot.hasData) {
//                     //         return Padding(
//                     //           padding: const EdgeInsets.all(8.0),
//                     //           child: Container(
//                     //             decoration: BoxDecoration(
//                     //                 borderRadius: BorderRadius.circular(15),
//                     //                 color: BeHealthyTheme.kMainOrange),
//                     //             child: ExpansionTile(
//                     //               onExpansionChanged: (bool a) {
//                     //                 mealType = '1405';
//                     //                 _queryDeliveryId(expectedDelDay);
//                     //                 deliveryId = deliveryIdList[4];
//                     //                 print('Delivery Id:$deliveryId');
//                     //               },
//                     //               title: Text(
//                     //                 'Salad',
//                     //                 style: BeHealthyTheme.kMainTextStyle
//                     //                     .copyWith(
//                     //                         color: Colors.white, fontSize: 20),
//                     //               ),
//                     //               children:
//                     //                   snapshot.data.map<Widget>((var element) {
//                     //                 return ListTile(
//                     //                   leading: Text(
//                     //                     '${element['ProdName1']}',
//                     //                     style: BeHealthyTheme.kMainTextStyle
//                     //                         .copyWith(
//                     //                             color: Colors.white,
//                     //                             fontSize: 15),
//                     //                   ),
//                     //                 );
//                     //               }).toList(),
//                     //             ),
//                     //           ),
//                     //         );
//                     //       } else {
//                     //         return Text(
//                     //           'Network Error',
//                     //           style: BeHealthyTheme.kMainTextStyle,
//                     //         );
//                     //       }
//                     //     }
//                     //   },
//                     // ),
//                     // FutureBuilder(
//                     //     future: generateMealTitleList(),
//                     //     builder: (context, snap) {
//                     //       print(snap.data);
//                     //       return Container(
//                     //           child: ExpansionPanelList(
//                     //         expansionCallback: (int index, bool isExpanded) {
//                     //           setState(() {
//                     //             _data[index].isExpanded = !isExpanded;
//                     //           });
//                     //         },
//                     //         children: _data.map<ExpansionPanel>((Item item) {
//                     //           return ExpansionPanel(
//                     //             canTapOnHeader: true,
//                     //             headerBuilder:
//                     //                 (BuildContext context, bool isExpanded) {
//                     //               return ListTile(
//                     //                 title: Text(item.headerValue),
//                     //               );
//                     //             },
//                     //             body: ListTile(
//                     //                 title: Text(item.expandedValue),
//                     //                 subtitle: const Text(
//                     //                     'To delete this panel, tap the trash can icon'),
//                     //                 trailing: const Icon(Icons.delete),
//                     //                 onTap: () {
//                     //                   setState(() {
//                     //                     _data.removeWhere((Item currentItem) =>
//                     //                         item == currentItem);
//                     //                   });
//                     //                 }),
//                     //             isExpanded: item.isExpanded,
//                     //           );
//                     //         }).toList(),
//                     //       ));
//                     //     }),
//                     // FutureBuilder(
//                     //   future: planMealSetupKitchen(),
//                     //   builder: (context, snapshot) {
//                     //     return Container(
//                     //       height: MediaQuery.of(context).size.height * 0.65,
//                     //       child: ListView.builder(
//                     //         itemCount: mealsList.length,
//                     //         itemBuilder: (context, index) {
//                     //           return ExpansionTile(
//                     //             onExpansionChanged: (bool a) {
//                     //               switch (mealsList[index]) {
//                     //                 case 'Breakfast':
//                     //                   {
//                     //                     setState(() {
//                     //                       selectedMealType = '1401';
//                     //                     });
//                     //                   }
//                     //                   break;
//                     //                 case 'Lunch':
//                     //                   {
//                     //                     setState(() {
//                     //                       selectedMealType = '1402';
//                     //                     });
//                     //                   }
//                     //                   break;
//                     //                 case 'Dinner':
//                     //                   {
//                     //                     setState(() {
//                     //                       selectedMealType = '1403';
//                     //                     });
//                     //                   }
//                     //                   break;
//                     //                 case 'Snack':
//                     //                   {
//                     //                     setState(() {
//                     //                       selectedMealType = '1404';
//                     //                     });
//                     //                   }
//                     //                   break;
//                     //                 case 'Salad':
//                     //                   {
//                     //                     setState(() {
//                     //                       selectedMealType = '1405';
//                     //                     });
//                     //                   }
//                     //                   break;
//                     //                 default:
//                     //                   {
//                     //                     setState(() {
//                     //                       selectedMealType = '1401';
//                     //                     });
//                     //                   }
//                     //                   break;
//                     //               }
//                     //             },
//                     //             title: Text(
//                     //               '${mealsList[index]}',
//                     //               style: BeHealthyTheme.kMainTextStyle,
//                     //             ),
//                     //             children:
//                     //                 snapshot.data.map<Widget>((var product) {
//                     //               return ListTile(
//                     //                 title: Text('${product['ProdName1']}'),
//                     //               );
//                     //             }).toList(),
//                     //           );
//                     //         },
//                     //       ),
//                     //     );
//                     //   },
//                     // ),

//                     // FutureBuilder(
//                     //     future: planMealSetupKitchen(),
//                     //     builder: (context, snapshot) {
//                     //       if (snapshot.connectionState ==
//                     //           ConnectionState.waiting) {
//                     //         return Center(
//                     //           child: CircularProgressIndicator(),
//                     //         );
//                     //       } else {
//                     //         if (snapshot.hasData) {
//                     //           _querySelected(14, transid, deliveryId,
//                     //               expectedDelDay, planid, mealType);
//                     //           return Container(
//                     //             height:
//                     //                 MediaQuery.of(context).size.height * 0.65,
//                     //             child: ListView.builder(
//                     //               itemCount: mealsList.length,
//                     //               itemBuilder: (context, index) {
//                     //                 return ExpansionTile(
//                     //                   onExpansionChanged: (bool a) {
//                     //                     switch (mealsList[index]) {
//                     //                       case 'Breakfast':
//                     //                         {
//                     //                           selectedMealType = '1401';
//                     //                           planMealSetupKitchen();
//                     //                         }
//                     //                         break;
//                     //                       case 'Lunch':
//                     //                         {
//                     //                           selectedMealType = '1402';
//                     //                           planMealSetupKitchen();
//                     //                         }
//                     //                         break;
//                     //                       case 'Dinner':
//                     //                         {
//                     //                           selectedMealType = '1403';
//                     //                           planMealSetupKitchen();
//                     //                         }
//                     //                         break;
//                     //                       case 'Snack':
//                     //                         {
//                     //                           selectedMealType = '1404';
//                     //                           planMealSetupKitchen();
//                     //                         }
//                     //                         break;
//                     //                       case 'Salad':
//                     //                         {
//                     //                           selectedMealType = '1405';
//                     //                           planMealSetupKitchen();
//                     //                         }
//                     //                         break;
//                     //                       default:
//                     //                         {
//                     //                           selectedMealType = '1401';
//                     //                           planMealSetupKitchen();
//                     //                         }
//                     //                         break;
//                     //                     }
//                     //                   },
//                     //                   title: Text(
//                     //                     '${mealsList[index]}',
//                     //                     style: BeHealthyTheme.kMainTextStyle,
//                     //                   ),
//                     //                   children: planMealSetupKitchen()
//                     //                       .map<Widget>((var product) {
//                     //                     return ListTile(
//                     //                       title:
//                     //                           Text('${product['ProdName1']}'),
//                     //                     );
//                     //                   }).toList(),
//                     //                 );
//                     //               },
//                     //             ),
//                     //           );
//                     //         } else {
//                     //           return Center(
//                     //             child: Text(snapshot.data['message']),
//                     //           );
//                     //         }
//                     //       }
//                     //     }),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void displayBottomSheet() {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   GestureDetector(
//                       onTap: () {},
//                       child: Image.asset(
//                         'assets/images/Group 99.png',
//                         width: 30,
//                         height: 30,
//                         color: BeHealthyTheme.kMainOrange,
//                       )),
//                   GestureDetector(
//                     onTap: () {
//                       // _query();
//                       // Navigator.pushReplacement(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (context) => CartCheckout()));
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 8, bottom: 12),
//                       child: Container(
//                         width: MediaQuery.of(context).size.width - 150,
//                         height: 45,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                             color: BeHealthyTheme.kMainOrange,
//                             borderRadius: BorderRadius.circular(25)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Continue ',
//                               style: BeHealthyTheme.kMainTextStyle
//                                   .copyWith(fontSize: 18, color: Colors.white),
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               size: 20,
//                               color: Colors.white,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 children: [
//                   MaterialButton(
//                     onPressed: () {},
//                     child: Container(
//                       width: MediaQuery.of(context).size.width - 300,
//                       height: 32,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           color: BeHealthyTheme.kLightOrange,
//                           borderRadius: BorderRadius.circular(25)),
//                       child: Text(
//                         'Spicy',
//                         style: BeHealthyTheme.kMainTextStyle.copyWith(
//                             fontSize: 13, color: BeHealthyTheme.kMainOrange),
//                       ),
//                     ),
//                   ),
//                   MaterialButton(
//                     onPressed: () {},
//                     child: Container(
//                       width: MediaQuery.of(context).size.width - 300,
//                       height: 32,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(25)),
//                       child: Text(
//                         'Non-Spicy',
//                         style: BeHealthyTheme.kMainTextStyle.copyWith(
//                             fontSize: 13, color: BeHealthyTheme.kMainOrange),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   MaterialButton(
//                     onPressed: () {},
//                     child: Container(
//                       width: MediaQuery.of(context).size.width - 300,
//                       height: 32,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           color: BeHealthyTheme.kLightOrange,
//                           borderRadius: BorderRadius.circular(25)),
//                       child: Text(
//                         'Salt',
//                         style: BeHealthyTheme.kMainTextStyle.copyWith(
//                             fontSize: 13, color: BeHealthyTheme.kMainOrange),
//                       ),
//                     ),
//                   ),
//                   MaterialButton(
//                     onPressed: () {},
//                     child: Container(
//                       width: MediaQuery.of(context).size.width - 300,
//                       height: 32,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(25)),
//                       child: Text(
//                         'No Salt',
//                         style: BeHealthyTheme.kMainTextStyle.copyWith(
//                             fontSize: 13, color: BeHealthyTheme.kMainOrange),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Text(
//                   'Cooking Directions',
//                   style: BeHealthyTheme.kMainTextStyle
//                       .copyWith(fontSize: 18, color: Color(0xff707070)),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width - 40,
//                   height: 150,
//                   child: TextFormField(
//                     maxLines: 5,
//                     cursorColor: BeHealthyTheme.kMainOrange,
//                     textAlign: TextAlign.center,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       isDense: true,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(25)),
//                           borderSide: BorderSide(
//                             width: 1,
//                           )),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(25)),
//                         borderSide: BorderSide(
//                             width: 1, color: BeHealthyTheme.kMainOrange),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(25)),
//                         borderSide: BorderSide(
//                             width: 2, color: BeHealthyTheme.kMainOrange),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         });
//   }
// }

// class Item {
//   Item({
//     @required this.title,
//     this.isSelected = false,
//   });

//   String title;
//   bool isSelected;
// }

// List<Item> generateItems(List list) {
//   return List<Item>.generate(list.length, (int index) {
//     return Item(
//       title: '${list[index]['ProdName1']}',
//     );
//   });
// }

// class CustomGridItem extends StatefulWidget {
//   final String title;
//   final String desc;
//   final Function onTap;
//   final bool isCompleted;
//   final String imageUrl;
//   CustomGridItem(
//       {this.title,
//       this.desc,
//       this.onTap,
//       this.isCompleted = false,
//       this.imageUrl});
//   @override
//   _CustomGridItemState createState() => _CustomGridItemState();
// }

// class _CustomGridItemState extends State<CustomGridItem> {
//   bool mealsCompleted;
//   @override
//   void initState() {
//     mealsCompleted = widget.isCompleted;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.5,
//         decoration: BoxDecoration(
//             color: BeHealthyTheme.kMainOrange.withOpacity(0.11),
//             borderRadius: BorderRadius.circular(15)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(15),
//                       topRight: Radius.circular(15)),
//                   child: Image(
//                     height: MediaQuery.of(context).size.height * 0.11,
//                     width: MediaQuery.of(context).size.width * 0.5,
//                     fit: BoxFit.cover,
//                     image: widget.imageUrl != null
//                         ? NetworkImage(widget.imageUrl)
//                         : AssetImage('assets/images/haha2.png'),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Text(
//                     widget.title,
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                     style: BeHealthyTheme.kMainTextStyle.copyWith(
//                         fontSize: 14, color: BeHealthyTheme.kMainOrange),
//                   ),
//                 ),
//               ],
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.symmetric(horizontal: 10),
//             //   child: Text(
//             //     desc,
//             //     textAlign: TextAlign.start,
//             //     style: BeHealthyTheme.kDhaaTextStyle.copyWith(fontSize: 10),
//             //   ),
//             // )
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 GestureDetector(
//                   onTap: widget.onTap,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(70),
//                             bottomRight: Radius.circular(20)),
//                         color: BeHealthyTheme.kMainOrange.withOpacity(0.27)),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 10, left: 10),
//                       child: Icon(
//                         mealsCompleted ? Icons.done : Icons.add,
//                         size: 30,
//                         color: mealsCompleted
//                             ? Colors.green
//                             : BeHealthyTheme.kMainOrange,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
