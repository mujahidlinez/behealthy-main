
import 'dart:convert';
import 'package:behealthy/cart_checkout.dart';
import 'package:behealthy/database/dbhelper.dart';
import 'package:behealthy/models/meal_Model.dart';
import 'package:behealthy/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:behealthy/constants.dart';
import 'package:behealthy/homePage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'database/table_fields.dart';
import 'package:intl/intl.dart';

class MealSelection extends StatefulWidget {
  final int planId;
  final int transId;

  MealSelection({
    this.planId,
    this.transId,
  });

  @override
  _MealSelectionState createState() => _MealSelectionState();
}

class _MealSelectionState extends State<MealSelection> {

  int totalWeek;
  String _chosenWeek = 'Week 1';
  List weekDate = [];
  List weekDay = [];
  List expectedDelDayList = [];
  var expectedDelDay;
  List deliveryIdList = [];
  var deliveryId = 1;
  int selectedIndex = 0;
  int selectedWeekNumber = 1;
  String selectedMealType;

  final dataBseHelper = DatabaseHelper.instance;
  var transid;
  var planid;
  var mealType;
  List selectedMeals = [];
  List mealsList = [];
  List allowedMealsList = [];
  List mealsTypeList = [];
  Map<String, String> foodNames = {'1401': 'BreakFast', '1402': 'Lunch', '1403': 'Dinner','1404': 'Snack', '1405': 'Salad', '1406': 'Soup'};
  int breakfastCount = 0;
  int lunchCount = 0;
  int dinnerCount = 0;
  int snackCount = 0;
  int saladCount = 0;
  int selectedMealIndex = 0;
  var dayIndex = 0;

  Future<List<Data>> getMenuFromMealType(int mealType,int mealIndex,int dayIndex,String dateStr) async {

    DateTime date = DateTime.now().add(const Duration(days: 2));
    http.Response response = await http.post(Uri.parse('https://foodapi.pos53.com/api/Food/PlanmealsetupKitchen_Get'),
        body: {'TenentID': TenentID.toString(), 'PlanID': '${widget.planId}', 'MealType':
        mealType.toString(), 'Date': dateStr == null ? '${date.month} - ${date.day} - ${date.year}' : dateStr});

    if (jsonDecode(response.body)['status'] == 200) {
      List<Data> tempList = [];
      try {
        Iterable l = jsonDecode(response.body)['data'];
        tempList = l.map((model) => Data.fromJson(model)).toList();
      } catch (ex) {
        print(ex.toString());
      }
      setState(() {
        wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items = tempList;
      });
      return tempList;
    } else {
      return jsonDecode(response.body);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  //  _query(selectedWeekNumber);
  }

  //MARK: API Calls
  planMealCustInvoiceSave() async {
    final rows = await dataBseHelper.giveFirstWeekData(widget.transId);
   // rows.forEach(print);
    int cnt = 0;
    // var parameters = {
    //   'TenentID': '${rows[0]['tenentId']}',
    //   'MYTRANSID': '${rows[0]['mytransid']}',
    //   'LOCATION_ID': '${rows[0]['locationId']}',
    //   'TotalWeek': '${rows[0]['totalWeek']}',
    //   'NoOfWeek': '${rows[0]['noOfWeek']}',
    //   'WeekofDay': '${rows[0]['weekofDay']}',
    //   'StartDate': '${rows[0]['startDate']}',
    //   'EndDate': '${rows[0]['endDate']}',
    // };
    // print('Parameters:$parameters');
    // http.Response res = await http.post(
    //     Uri.parse(
    //         'https://foodapi.pos53.com/api/CopyfullPlan/CopyfullplanList'),
    //     body: parameters);
    // // print(res.body);
    // // print('Copy full plan data:');
    // var data = jsonDecode(res.body)['data'];
    // // _insertinPlanMealCustinvoiceDb(data);
    // return jsonDecode(res.body);
    // // } else {
    // //   return jsonDecode(response.body);
    // // }
    wholePlan.weeks.forEach((weekPlan) {
      weekPlan.days.forEach((dayPlan) {
        if(dayPlan != null){
          dayPlan.meals.forEach((mealPlan) {
            mealPlan.items.forEach((item) {
              if (item.isSelected)
                cnt += 1;
            });
          });
        }
      });
    });
    int totalAllowedMeals = 0;
    allowedMealsList.forEach((element) {
      totalAllowedMeals += element;
    });
    int totalRequiredRecords = totalAllowedMeals*6; // 6 is for first week data say 6 days
    if (cnt >= totalRequiredRecords) {
      try {
        var dataToUploadJson = jsonEncode(rows);
        print(dataToUploadJson);
        http.Response response = await http.post(Uri.parse('https://foodapi.pos53.com/api/Food/Planmealcustinvoice_Save'),
            headers: {'Content-type': 'application/json'},
            body: dataToUploadJson);
        var json = jsonDecode(response.body);
        if (json['status'] == 200) {
          var parameters = {
            'TenentID': '${rows[0]['tenentId']}',
            'MYTRANSID': '${rows[0]['mytransid']}',
            'LOCATION_ID': '${rows[0]['locationId']}',
            'TotalWeek': '${rows[0]['totalWeek']}',
            'NoOfWeek': '${rows[0]['noOfWeek']}',
            'WeekofDay': '${rows[0]['weekofDay']}',
            'StartDate': '${rows[0]['startDate']}',
            'EndDate': '${rows[0]['endDate']}',
          };
         print('Parameters:$parameters');
          http.Response res = await http.post(
              Uri.parse(
                  'https://foodapi.pos53.com/api/CopyfullPlan/CopyfullplanList'),
              body: parameters);
          //print(res.body);
          print('Copy full plan data:');
          var data = jsonDecode(res.body)['data'];
          _insertinPlanMealCustinvoiceDb(data);
          navigationChecker(context);
          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));

          return jsonDecode(res.body);
        } else {
          return jsonDecode(response.body);
        }
      } catch (e) {
        print(e);
      }
    } else {
      return {
        "message": "You must select all the meals for Week 1 to Continue!"
      };
    }
  }
  // _giveFirstWeek() async {
  //   var rows = await dataBseHelper.giveFirstWeekData();
  //   int cnt = 0;
  //   rows.forEach((element) {
  //     if (element['switch5'] != '10009') cnt++;
  //   });
  //   return cnt;
  // }

  //MARK: Database Calls
  _insertinPlanMealCustinvoiceDb(List allData) async {
    var delId =
        await dataBseHelper.deleteAllRowsFromPlanMealCustInvoice(transid);
    allData.forEach((element) {
      Map<String, dynamic> newRow = {
        TableFields.tenentId: element['TenentID'],
        TableFields.mytransid: element['MYTRANSID'],
        TableFields.deliveryId: element['DeliveryID'],
        TableFields.myprodid: element['MYPRODID'],
        TableFields.uom: element['UOM'],
        TableFields.locationId: element['LOCATION_ID'],
        TableFields.customerId: element['CustomerID'],
        TableFields.planid: element['planid'],
        TableFields.basicCustom: 'Basic',
        TableFields.fixFlexible: 'Fixed',
        TableFields.mealType: element['MealType'],
        TableFields.mealUom: element['MealUOM'],
        TableFields.prodName1: element['ProdName1'],
        TableFields.oprationDay: element['OprationDay'],
        TableFields.dayNumber: element['DayNumber'],
        TableFields.transId: element['TransID'],
        TableFields.contractId: element['ContractID'],
        TableFields.weekofDay: element['WeekofDay'],
        TableFields.nameOfDay: element['NameOfDay'],
        TableFields.totalWeek: element['TotalWeek'],
        TableFields.noOfWeek: element['NoOfWeek'],
        TableFields.displayWeek: element['DisplayWeek'],
        TableFields.totalDeliveryDay: element['TotalDeliveryDay'],
        TableFields.actualDeliveryDay: element['ActualDeliveryDay'],
        TableFields.expectedDeliveryDay: element['ExpectedDeliveryDay'],
        TableFields.deliveryTime: element['DeliveryTime'],
        TableFields.deliveryMeal: element['DeliveryMeal'],
        TableFields.driverId: element['DriverID'],
        TableFields.startDate: element['StartDate'],
        TableFields.endDate: element['EndDate'],
        TableFields.expectedDelDate: element['ExpectedDelDate'],
        TableFields.actualDelDate: element['ActualDelDate'],
        TableFields.nExtDeliveryDate: element['NExtDeliveryDate'],
        TableFields.returnReason: element['ReturnReason'],
        TableFields.reasonDate: element['ReasonDate'],
        TableFields.productionDate: element['ProductionDate'],
        TableFields.chiefId: element['chiefID'],
        TableFields.subscriptonDayNumber: element['SubscriptonDayNumber'],
        TableFields.calories: element['Calories'],
        TableFields.protein: element['Protein'],
        TableFields.carbs: element['Carbs'],
        TableFields.fat: element['Fat'],
        TableFields.itemWeight: element['ItemWeight'],
        TableFields.qty: element['Qty'],
        TableFields.itemCost: element['Item_cost'],
        TableFields.itemPrice: element['Item_price'],
        TableFields.totalprice: element['Totalprice'],
        TableFields.shortRemark: element['ShortRemark'],
        TableFields.active: element['ACTIVE'],
        TableFields.crupid: element['CRUPID'],
        TableFields.changesDate: element['ChangesDate'],
        TableFields.deliverySequence: element['DeliverySequence'],
        TableFields.switch1: element['Switch1'],
        TableFields.switch2: element['Switch2'],
        TableFields.switch3: element['Switch3'],
        TableFields.switch4: element['Switch4'],
        TableFields.switch5: element['Switch5'],
        TableFields.status: element['Status'],
        TableFields.uploadDate: element['UploadDate'],
        TableFields.uploadby: element['Uploadby'],
        TableFields.syncDate: element['SyncDate'],
        TableFields.syncby: element['Syncby'],
        TableFields.synId: element['SynID'],
        TableFields.syncStatus: element['syncStatus'],
        TableFields.localId: element['LocalID'],
        TableFields.offlineStatus: element['OfflineStatus'],
        TableFields.updateDate:
            '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}',
      };
      try {
        final id = dataBseHelper.insertToPlanMealCustInvoice(newRow);
        print('Row inserted in planmealcustinvoice db:$id');
      } catch (e) {
        print(e);
      }
    });
    print('Successfully updated the db');
  }
  _queryDeliveryId(rEdd) async {
    deliveryIdList.clear();
    final rows = await dataBseHelper.queryDeliveryID(rEdd, widget.planId);
    // print('Delivery IDs:');
    // rows.forEach(print);
    rows.forEach((element) {
      deliveryIdList.add(element['deliveryId']);
    });
  }
  _queryMealTypes([List<Map<String, dynamic>> allRows]) async {

    mealsTypeList.clear();

    final rows = await dataBseHelper.queryMealTypes(widget.planId);
    //rows.forEach(print);
      for(int i = 0; i < rows.length; i++){
        var mealType = rows[i]['mealType'];
        mealsTypeList.add(mealType);
      }

    mealType = mealsTypeList;
    loadDataInWholePlan(allRows);
    return mealsTypeList;
  }

  loadDataInWholePlan([List<Map<String, dynamic>> allRows] ){
    if (allRows.isNotEmpty) {
      totalWeek = allRows[0]["totalWeek"];
      var dateFrom = allRows[0]["StartDate"];
      var dateTo = allRows[0]["EndDate"];
      DateFormat dateFormat = DateFormat("MM/dd/yyyy","en-US");
      wholePlan.weeks = List(totalWeek);
      //totalDays = 26;
      var mealDays = List();
      allRows.forEach((customerContractDetail) {
       // if (customerContractDetail.mealType == mealsOfDayList[0].mealType) {

         // customerContractDetail.date = dateFormat.parse(customerContractDetail["expectedDelDate"]);
          mealDays.add(customerContractDetail);
      //  }
      });
      print(mealDays.length);
      mealDays.sort((a,b) {
        var dateStrA = a["expectedDelDate"];
        var dateStrB = b["expectedDelDate"];
        var dateA = dateFormat.parse(dateStrA);
        var dateB = dateFormat.parse(dateStrB);
        dateFormat.parse(dateStrB);
        return dateA.millisecondsSinceEpoch.compareTo(dateB.millisecondsSinceEpoch);
      });


      print(mealDays.length);
      for (int weekIndex = 0; weekIndex < totalWeek; weekIndex++) {
        var noOfWeek = weekIndex + 1;
        WeekPlan weekPlan = WeekPlan();
        weekPlan.weekName = "Week $noOfWeek";
        List<DayPlan> dayPlans = List();
        int dayIndex = 0;

        switch(noOfWeek){
          case 1:
            for(int i = 0; i<6;i++){ //fetch first 6 days for week no 1
              var customerContractDetail = mealDays[i];
              DayPlan dayPlan = DayPlan();
              String actualDelDateStr = customerContractDetail["expectedDelDate"];
              DateTime actualDelDate = DateFormat("MM/dd/yyyy", "en_US").parse(actualDelDateStr);
              PlanDates planDate = PlanDates(actualDelDate, false);
              dayPlan.planDate = planDate;
              List<MealPlan> mealPlanes = List(mealsTypeList.length);
              mealType.forEach((mealOfDay) {
                int mealIndex = mealType.indexOf(mealOfDay);
                MealPlan mealPlan = MealPlan();
                mealPlanes[mealIndex] = mealPlan;
              });
              dayPlan.meals = mealPlanes;
              dayPlans.add(dayPlan);
              dayIndex = dayIndex +1;
            }
            break;
          case 2:
            for(int i = 6; i<12;i++){ //fetch next 6 days for week no 2
              var customerContractDetail = mealDays[i];
              DayPlan dayPlan = DayPlan();
              String actualDelDateStr = customerContractDetail["expectedDelDate"];
              DateTime actualDelDate = DateFormat("MM/dd/yyyy", "en_US").parse(actualDelDateStr);
              PlanDates planDate = PlanDates(actualDelDate, false);
              dayPlan.planDate = planDate;
              List<MealPlan> mealPlanes = List(mealType.length);
              mealType.forEach((mealOfDay) {
                int mealIndex = mealType.indexOf(mealOfDay);
                MealPlan mealPlan = MealPlan();
                mealPlanes[mealIndex] = mealPlan;

              });
              dayPlan.meals = mealPlanes;
              dayPlans.add(dayPlan);
              dayIndex = dayIndex +1;
            }
            break;
          case 3:
            for(int i = 12; i<18;i++){ //fetch next 6 days for week no 3
              var customerContractDetail = mealDays[i];
              DayPlan dayPlan = DayPlan();
              String actualDelDateStr = customerContractDetail["expectedDelDate"];
              DateTime actualDelDate = DateFormat("MM/dd/yyyy", "en_US").parse(actualDelDateStr);
              PlanDates planDate = PlanDates(actualDelDate, false);
              dayPlan.planDate = planDate;
              List<MealPlan> mealPlanes = List(mealType.length);
              mealType.forEach((mealOfDay) {
                int mealIndex = mealType.indexOf(mealOfDay);
                MealPlan mealPlan = MealPlan();
                mealPlanes[mealIndex] = mealPlan;
              });
              dayPlan.meals = mealPlanes;
              dayPlans.add(dayPlan);
              dayIndex = dayIndex +1;
            }
            break;
          case 4:
            for(int i = 18; i<24;i++){ //fetch next 6 days for week no 4
              var customerContractDetail = mealDays[i];
              DayPlan dayPlan = DayPlan();
              String actualDelDateStr = customerContractDetail["expectedDelDate"];
              DateTime actualDelDate = DateFormat("MM/dd/yyyy", "en_US").parse(actualDelDateStr);
              PlanDates planDate = PlanDates(actualDelDate, false);
              dayPlan.planDate = planDate;
              List<MealPlan> mealPlanes = List(mealType.length);
              mealType.forEach((mealOfDay) {
                int mealIndex = mealType.indexOf(mealOfDay);
                MealPlan mealPlan = MealPlan();
                mealPlanes[mealIndex] = mealPlan;
              });
              dayPlan.meals = mealPlanes;
              dayPlans.add(dayPlan);
              dayIndex = dayIndex +1;
            }
            break;
          case 5:
            for(int i = 24; i < 26;i++){ //fetch next 2 days for week no 5
              var customerContractDetail = mealDays[i];
              DayPlan dayPlan = DayPlan();
              String actualDelDateStr = customerContractDetail["expectedDelDate"];
              DateTime actualDelDate = DateFormat("MM/dd/yyyy", "en_US").parse(actualDelDateStr);
              PlanDates planDate = PlanDates(actualDelDate, false);
              dayPlan.planDate = planDate;
              List<MealPlan> mealPlanes = List(mealType.length);
              mealType.forEach((mealOfDay) {
                int mealIndex = mealType.indexOf(mealOfDay);
                MealPlan mealPlan = MealPlan();
                mealPlanes[mealIndex] = mealPlan;
              });
              dayPlan.meals = mealPlanes;
              dayPlans.add(dayPlan);
              dayIndex = dayIndex +1;
            }
            break;
        }

        List<DayPlan> tempDayPlans = List(dayPlans.length);

        if(dayPlans.length == 2){
          dayPlans.forEach((dayPlan) {

            switch(dayPlan.planDate.weekday) {
              case 4:
                tempDayPlans[0] = dayPlan;
                break;
              case 5:
                tempDayPlans[1] = dayPlan;
                break;
              case 6:
                tempDayPlans[1] = dayPlan;
                break;
              case 7:
                tempDayPlans[1] = dayPlan;
                break;
              case 1:
                tempDayPlans[1] = dayPlan;
                break;
              case 2:
                tempDayPlans[1] = dayPlan;
                break;
            }
          });
        }else{
          dayPlans.forEach((dayPlan) {
            switch(dayPlan.planDate.weekday) {
              case 4:
                tempDayPlans[0] = dayPlan;
                break;
              case 5:
                tempDayPlans[1] = dayPlan;
                break;
              case 6:
                tempDayPlans[2] = dayPlan;
                break;
              case 7:
                tempDayPlans[3] = dayPlan;
                break;
              case 1:
                tempDayPlans[4] = dayPlan;
                break;
              case 2:
                tempDayPlans[5] = dayPlan;
                break;
            }
          });
        }
        dayPlans = tempDayPlans;
        if(dayPlans.length != 0 ){
          if(dayPlans[0] != null)
            dayPlans[0].planDate.isSelected = true;
        }
        weekPlan.days = dayPlans;
        setState(() {
          wholePlan.weeks[weekIndex] = weekPlan;
        });
      }
    }
   // print(wholePlan.weeks.length);
    fetchDataForTheDay(0,0,wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].planDate.dateForAPIStr);
  }

  fetchDataForTheDay(int weekIndex,int dayIndex,String dateStr){
    mealsTypeList.forEach((mealType) {
      int mealIndex = mealsTypeList.indexOf(mealType);
      getMenuFromMealType(mealType, mealIndex, dayIndex, dateStr);
    });
  }
  Future<void> _query(int selectedWeek) async {
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // print(documentsDirectory.path);
    weekDate.clear();
    weekDay.clear();
    expectedDelDayList.clear();
    final allRows = await dataBseHelper.queryAllRowsFromPlanMealCustInvoice(widget.planId, widget.transId);
    mealType =   _queryMealTypes(allRows);
    for(int i = 0; i < allRows.length; i++){
      totalWeek = allRows[i]['totalWeek'];
    }
    generateWeekList(totalWeek);
    generateMealTitleList();
  }
  _querySelected(int rTenentId, int rMyTransId, int rExpectedDeliveryDay,int rPlanid, int rMealtype) async {
    final rows = await dataBseHelper.querySelectedPlanMealCustInvoice(
        rTenentId, rMyTransId, rExpectedDeliveryDay, rPlanid, rMealtype);
   // print('Switch5 query:');
    //rows.forEach(print);
    // rows.forEach((element) {
    //   selectedMeals.add(element['switch5']);
    // });
    return rows;
  }
  // sortWeekData(List rWeekDateList, List rWeekDayList) {
  //   int turningPoint;
  //   List returningDateList = [];
  //   List returningDayList = [];
  //   for (int i = 0; i < rWeekDateList.length; i++) {
  //     if (rWeekDayList[i] == 'Thu') {
  //       turningPoint = i;
  //     }
  //   }
  //   for (int i = turningPoint; i < rWeekDateList.length; i++) {
  //     returningDateList.add(rWeekDateList[i]);
  //     returningDayList.add(rWeekDayList[i]);
  //   }
  //   for (int i = 0; i < turningPoint; i++) {
  //     returningDateList.add(rWeekDateList[i]);
  //     returningDayList.add(rWeekDayList[i]);
  //   }
  //   weekDate = returningDateList;
  //   weekDay = returningDayList;
  // }

  generateWeekList(int weeks) {
    List<String> listofWeeks = [];
    if (weeks != null) {
      for (int i = 0; i < weeks; i++) {
        listofWeeks.add('Week ${i + 1}');
      }
    }
    return listofWeeks;
  }
  getInstances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      return prefs;
    } else {
      return null;
    }
  }
  initData() async {
    var prefs = await getInstances();
    planid = prefs.get('id');
  }
  generateMealTitleList() async {
    mealsList.clear();
    // final String response =
    //     await rootBundle.loadString('assets/json/getpackagewithplanmeal.json');
    // var rData = jsonDecode(response.toString());
    // rData[widget.planId.toString()].forEach((element) {
    //   if (element['planid'] == widget.planId) {
    //     mealsList.add(element['Meal_Eng']);
    //   }
    // });
    // http.Response response = await http.post(
    //     Uri.parse('https://foodapi.pos53.com/api/Food/GetpackageMeal'),
    //     body: {'TenentID':TenentID.toString(), 'PlanId': widget.planId});
    // var data = jsonDecode(response.body)['data'];
    // data.forEach((element) {
    //   mealsList.add(element['REFNAME1']);
    // });
  }
  giveAllowedMeals() async {
    allowedMealsList.clear();
    final row = await dbHelper.queryAllRowsFromMoreHD();
    row.forEach((element) {
      allowedMealsList.add(element['basemeal']);
    });
    print('Meal type -->>${allowedMealsList.length}');
    // final String newResponse = await rootBundle.loadString('assets/json/newplan2.json');
    // var newData = jsonDecode(newResponse.toString());
    // newData['NEwPlanMeal'].forEach((element) {
    //   if (element['planid'] == widget.planId.toString()) {
    //     print('Meal type -->>${element['MealType']}');
    //     allowedMealsList.add(int.parse(element['MealAllowed']));
    //   }
    // });
    // final String response =
    //     await rootBundle.loadString('assets/json/getpackagewithplanmeal.json');
    // var rData = jsonDecode(response.toString());
    // rData[widget.planId.toString()].forEach((element) {
    //   if (element['planid'] == widget.planId) {
    //     allowedMealsList.add(element['Allowed_Meal']);
    //   }
    // });
    print('allowed meals list:$allowedMealsList');
  }
  final dbHelper = DatabaseHelper.instance;
  checkMealCount(Data snap, bool value) async {
    // final rows = await planmealcustinvoicedbhelper.querySomeRows();
    // rows.forEach(print);
    if (value == true) {
      await updateRow(snap);
      Toast.show('Successfully Added', context);
    } else {
      await downgradeRow(snap);
      Toast.show('Successfully Removed', context);
    }
  }
  navigationChecker(BuildContext context) async {
    var allRows = await dataBseHelper.giveFirstWeekData(widget.transId);
    int cnt = 0;
    allRows.forEach((element) {
      if (element['switch5'] == '10009') {
        cnt++;
      }
    });
    if (cnt == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CartCheckout()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      Navigator.pop(context);
    }
  }
  updateRow(Data snap) async {
    var id = await dataBseHelper.updateUsingRawQuery(snap.mYPRODID, snap.uOM, snap.itemCost,snap.calories, snap.protein, snap.carbs, snap.fat,
        snap.itemWeight,"switch5", snap.prodName1, 'Note by user', 14, transid, snap.productionDate, widget.planId, snap.mealType);
    print(id);
  }
  downgradeRow(Data snap,) async {
    var id = await dataBseHelper.updateUsingRawQuery(null,null,null,null,null,null,null,null, '10009', 'Note by user', 'Note by user for short remark',
        14, transid, snap.productionDate, widget.planId, snap.mealType);
    print('Number of rows changed:$id');
  }

  setPlanCopied() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = ['hello'];
    prefs.setStringList('planCopied', list);
  }

  int getNumberOfSelectedItems(int listMealIndex){
    int numberOfSelectedItem = 0;
    wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
        .meals[listMealIndex].items.forEach((item){
      if (item.isSelected)
        numberOfSelectedItem += 1;
    });
    return numberOfSelectedItem;
  }

  // checkLunch(var snap, bool value, int mealCount, int allowedM) async {
  //   if (mealCount > allowedM) {
  //     return false;
  //   } else {
  //     if (value == true) {
  //       await updateRow(snap);
  //       setState(() {
  //         lunchCount++;
  //       });
  //     } else {
  //       await updateRow(null);
  //       setState(() {
  //         lunchCount--;
  //       });
  //     }
  //   }
  // }

  // checkDinner(var snap, bool value, int mealCount, int allowedM) async {
  //   if (mealCount > allowedM) {
  //     return false;
  //   } else {
  //     if (value == true) {
  //       await updateRow(snap);
  //       setState(() {
  //         dinnerCount++;
  //       });
  //     } else {
  //       await updateRow(null);
  //       setState(() {
  //         dinnerCount--;
  //       });
  //     }
  //   }
  // }

  // checkSnack(var snap, bool value, int mealCount, int allowedM) async {
  //   if (mealCount > allowedM) {
  //     return false;
  //   } else {
  //     if (value == true) {
  //       await updateRow(snap);
  //       setState(() {
  //         snackCount++;
  //       });
  //     } else {
  //       await updateRow(null);
  //       setState(() {
  //         snackCount--;
  //       });
  //     }
  //   }
  // }

  // checkSalad(var snap, bool value, int mealCount, int allowedM) async {
  //   if (mealCount > allowedM) {
  //     return false;
  //   } else {
  //     if (value == true) {
  //       await updateRow(snap);
  //       setState(() {
  //         saladCount++;
  //       });
  //     } else {
  //       await updateRow(null);
  //       setState(() {
  //         saladCount--;
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    wholePlan = WholePlan();
    for(int i = 0 ; i<5 ; i++){
      var week = WeekPlan();
      wholePlan.weeks.add(week);
    }
    _query(selectedWeekNumber);
   // _queryMealTypes();
    _queryDeliveryId(1);
    giveAllowedMeals();

    transid = widget.transId;
  }
  int getKitchenItemCount(int mealIndex){
    int count = 0 ;
    if(wholePlan.weeks.length != 0 && wholePlan.weeks[selectedWeekNumber-1] != null &&
        wholePlan.weeks[selectedWeekNumber-1].days.length != 0 && wholePlan.weeks[selectedWeekNumber-1].days[dayIndex] != null &&
        wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals.length != 0 && wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex]
        != null && wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items.length != 0) {
      count =  wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items.length;
    }
    return count;
  }
  int getMealTypeCount(){
    int count = 0 ;
    if(wholePlan.weeks.length != 0 && wholePlan.weeks[selectedWeekNumber-1] != null && wholePlan.weeks[selectedWeekNumber-1].days.length != 0
        && wholePlan.weeks[selectedWeekNumber-1].days[dayIndex] != null && wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals.length != 0) {
      count =  wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals.length;
    }
    return count;
  }
  int getDayTypeCount(){
    int count = 0 ;
    if(wholePlan.weeks.length != 0 && wholePlan.weeks[selectedWeekNumber-1] != null && wholePlan.weeks[selectedWeekNumber-1].days.length != 0) {
      count =  wholePlan.weeks[selectedWeekNumber-1].days.length;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, //BeHealthyTheme.kMainOrange.withOpacity(0.27),
        elevation: 20,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // GestureDetector(
            //   onTap: () {
            //     displayBottomSheet();
            //   },
            //   child: Image.asset(
            //     'assets/images/Group 99.png',
            //     width: 30,
            //     height: 30,
            //     color: BeHealthyTheme.kMainOrange,
            //   ),
            // ),
            GestureDetector(
              onTap: () async {
                // _queryDeliveryId(expectedDelDay);
                // var data = await planmealcustinvoicedbhelper.querySomeRows(
                //     selectedWeekNumber, selectedMealType, _selectedDate);
                // print('Selected Query:');
                // data.forEach(print);
                // _query(3);
                // generateWeekList(totalWeek);
                // generateMealTitleList();
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => CartCheckout()))
                var value = await planMealCustInvoiceSave();
                //Toast.show('${value['message']}', context, duration: 5);
                //Toast.show('Order Placed', context, duration: 5);
                // showDialog(
                //     barrierDismissible: false,
                //     context: context,
                //     builder: (context) {
                //       Future.delayed(Duration(seconds: 3), () async {
                //         var value = await planMealCustInvoiceSave();
                //         Toast.show('${value['message']}', context, duration: 5);
                //
                //         navigationChecker(context);
                //       });
                //       return Center(child: CircularProgressIndicator());
                //     });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width - 150,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff14CC34),
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue ',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Meal Selection',
                      style: BeHealthyTheme.kMainTextStyle.copyWith(
                          color: BeHealthyTheme.kMainOrange,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      'اختيار الوجبة',
                      style: BeHealthyTheme.kMainTextStyle.copyWith(
                        fontSize: 23,
                        color: BeHealthyTheme.kMainOrange,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: medq.width - 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: BeHealthyTheme.kMainOrange,
                          ),
                          child: DropdownButton<String>(
                            focusColor: Colors.white,
                            value: _chosenWeek,
                            dropdownColor: BeHealthyTheme.kMainOrange,
                            underline: Container(),
                            elevation: 0,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            iconDisabledColor: Colors.white,
                            //elevation: 5,
                            iconEnabledColor: Colors.black,
                            items: generateWeekList(totalWeek)
                                .map<DropdownMenuItem<String>>(
                                    (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    value,
                                    style: BeHealthyTheme.kMainTextStyle
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String value) async {
                              await _queryDeliveryId(expectedDelDay);
                              setState(() async {
                                _chosenWeek = value;
                                switch (value) {
                                  case 'Week 1':
                                    {
                                     if (wholePlan.weeks[0].days.length == 0){
                                        await _query(1);
                                      }
                                      selectedWeekNumber = 1;
                                    }
                                    break;
                                  case 'Week 2':
                                    {
                                      await _query(2);
                                      selectedWeekNumber = 2;
                                    }
                                    break;
                                  case 'Week 3':
                                    {
                                      await _query(3);
                                      selectedWeekNumber = 3;
                                    }
                                    break;
                                  case 'Week 4':
                                    {
                                      await _query(4);
                                      selectedWeekNumber = 4;
                                    }
                                    break;
                                  case 'Week 5':
                                    {
                                      await _query(5);
                                      selectedWeekNumber = 5;
                                    }
                                    break;
                                  default:
                                    {
                                      await _query(1);
                                      selectedWeekNumber = 1;
                                    }
                                    break;
                                }
                                selectedIndex = null;
                              });
                            },
                          ),
                        ),
                        // MaterialButton(
                        //   onPressed: () async {
                        //     SharedPreferences prefs =
                        //         await SharedPreferences.getInstance();
                        //     var list = prefs.getStringList('planCopied');
                        //     print(list);
                        //   },
                        //   child: Text('test'),
                        // ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      // margin: EdgeInsets.symmetric(vertical: 10),
                      width: medq.width,
                      height: medq.height * 0.09,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: getDayTypeCount(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 5),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    selectedIndex = index;
                                    dayIndex = index;
                                    if (wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[0].items.length == 0){
                                      fetchDataForTheDay(selectedWeekNumber-1,dayIndex,wholePlan.weeks[selectedWeekNumber-1]
                                          .days[dayIndex].planDate.dateForAPIStr);
                                    }
                                  });
                                  await _queryDeliveryId(expectedDelDay);
                                  setState(() {
                                    selectedMeals.clear();
                                  });
                                  print('Delivery ID Changed:$deliveryId from $deliveryIdList');
                                  print('Expected DAY Changed:$expectedDelDay from $expectedDelDayList');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: selectedIndex == index ? BeHealthyTheme.kMainOrange : BeHealthyTheme.kMainOrange
                                        .withOpacity(0.11),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${wholePlan.weeks[selectedWeekNumber-1].days[index] != null ?
                                          wholePlan.weeks[selectedWeekNumber-1].days[index].planDate.dayTitle : ""}',
                                          style: BeHealthyTheme.kDhaaTextStyle
                                              .copyWith(color: selectedIndex == index ? Colors.white : BeHealthyTheme
                                              .kMainOrange, fontSize: 22),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            '${wholePlan.weeks[selectedWeekNumber-1].days[index] != null ?
                                            wholePlan.weeks[selectedWeekNumber-1].days[index].planDate.dayNameOfWeek:""}',
                                            style: BeHealthyTheme.kDhaaTextStyle.copyWith(color: selectedIndex == index
                                                ? Colors.white : BeHealthyTheme.
                                            kMainOrange, fontSize: 10),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  // selectedIndex != null
                  //     ? FutureBuilder(
                  //         future: _queryMealTypes(),
                  //         builder: (context, snap) {
                  //           if (snap.connectionState ==
                  //               ConnectionState.waiting) {
                  //             return Center(
                  //               child: CircularProgressIndicator(),
                  //             );
                  //           } else {
                  //             if (!snap.hasData)
                  //               return Center(
                  //                 child: CircularProgressIndicator(),
                  //               );
                  //             else
                  //               return Column(children: [
                  //                 Container(
                  //                   height:
                  //                       MediaQuery.of(context).size.height,
                  //                   child: ListView.builder(
                  //                       scrollDirection: Axis.vertical,
                  //                       itemCount: snap.data.length,
                  //                       itemBuilder: (context, index) {
                  //                         return FutureBuilder(
                  //                           future: getMenuFromMealtType(
                  //                               snap.data[index].toString()),
                  //                           builder: (context, snapshot) {
                  //                             if (snapshot.connectionState ==
                  //                                 ConnectionState.waiting) {
                  //                               return Center(
                  //                                   child:
                  //                                       CircularProgressIndicator());
                  //                             } else {
                  //                               if (snapshot.hasData) {
                  //                                 // final List<Item> _data =
                  //                                 //     generateItems(snapshot.data);
                  //                                 // int am = allowedMealsList[0];
                  //                                 selectedMealType = snap
                  //                                     .data[index]
                  //                                     .toString();
                  //                                 print(deliveryIdList);
                  //                                 deliveryId =
                  //                                     deliveryIdList[index];
                  //                                 return FutureBuilder(
                  //                                     future: _querySelected(
                  //                                         14,
                  //                                         transid,
                  //                                         deliveryId,
                  //                                         expectedDelDay,
                  //                                         widget.planId,
                  //                                         snap.data[index]),
                  //                                     builder:
                  //                                         (context, snap) {
                  //                                       if (snap.connectionState ==
                  //                                           ConnectionState
                  //                                               .waiting) {
                  //                                         return CircularProgressIndicator();
                  //                                       } else {
                  //                                         var switch5 =
                  //                                             snap.data[0]
                  //                                                 ['switch5'];
                  //                                         int cnt = 0;
                  //                                         snap.data.forEach(
                  //                                             (value) {
                  //                                           if (value[
                  //                                                   'switch5'] !=
                  //                                               '10009')
                  //                                             cnt++;
                  //                                         });
                  //                                         return Padding(
                  //                                           padding:
                  //                                               const EdgeInsets
                  //                                                   .all(8.0),
                  //                                           child: Container(
                  //                                             // decoration: BoxDecoration(
                  //                                             //     borderRadius: BorderRadius.circular(15),
                  //                                             //     color: BeHealthyTheme.kMainOrange
                  //                                             //         .withOpacity(0.11)),
                  //                                             child: Column(
                  //                                               children: [
                  //                                                 Padding(
                  //                                                   padding: const EdgeInsets
                  //                                                           .symmetric(
                  //                                                       vertical:
                  //                                                           3),
                  //                                                   child:
                  //                                                       Center(
                  //                                                     child:
                  //                                                         RichText(
                  //                                                       text: TextSpan(
                  //                                                           text: 'Breakfast',
                  //                                                           style: BeHealthyTheme.kMainTextStyle.copyWith(color: BeHealthyTheme.kMainOrange, fontSize: 24),
                  //                                                           children: [
                  //                                                             // TextSpan(
                  //                                                             //   text:
                  //                                                             //       '  $cnt/$am',
                  //                                                             //   style: BeHealthyTheme.kMainTextStyle.copyWith(
                  //                                                             //       color: Color(0xff707070),
                  //                                                             //       fontSize: 24),
                  //                                                             // )
                  //                                                           ]),
                  //                                                     ),
                  //                                                     //   child: Text(
                  //                                                     //     'Breakfast   $cnt/$am',
                  //                                                     //     style: BeHealthyTheme
                  //                                                     //         .kMainTextStyle
                  //                                                     //         .copyWith(
                  //                                                     //             color: Color(0xff707070),
                  //                                                     //                 // BeHealthyTheme.kMainOrange,
                  //                                                     //             fontSize: 24),
                  //                                                     //   ),
                  //                                                   ),
                  //                                                 ),
                  //                                                 Divider(
                  //                                                   indent:
                  //                                                       100,
                  //                                                   endIndent:
                  //                                                       100,
                  //                                                   thickness:
                  //                                                       1.5,
                  //                                                 ),
                  //                                                 Container(
                  //                                                   height: medq
                  //                                                           .height *
                  //                                                       0.25,
                  //                                                   width: medq
                  //                                                       .width,
                  //                                                   child: ListView.builder(
                  //                                                       scrollDirection: Axis.horizontal,
                  //                                                       itemCount: snapshot.data.length,
                  //                                                       itemBuilder: (context, index) {
                  //                                                         return CustomGridItem(
                  //                                                           title: '${snapshot.data[index]['ProdName1']}',
                  //                                                           imageUrl: snapshot.data[index]['ProdName3'],
                  //                                                           isCompleted: switch5 == snapshot.data[index]['ProdName1'] ? true : false,
                  //                                                           onTap: () async {
                  //                                                             deliveryId = deliveryIdList[0];
                  //                                                             //checking the tick icon
                  //                                                             if (switch5 != snapshot.data[index]['ProdName1']) {
                  //                                                               snap.data.forEach((value) {
                  //                                                                 if (value['switch5'] == '10009') {
                  //                                                                   checkMealCount(snapshot.data[index], true, 2);
                  //                                                                 } else {
                  //                                                                   Toast.show('Allowed meal exceeded', context);
                  //                                                                 }
                  //                                                               });
                  //                                                             } else {
                  //                                                               checkMealCount(snapshot.data[index], false, 2);
                  //                                                             }
                  //                                                             setState(() {});

                  //                                                             // checkFunction(, snap, value, allowedM)
                  //                                                           },
                  //                                                         );
                  //                                                       }),
                  //                                                 ),
                  //                                               ],
                  //                                             ),
                  //                                           ),
                  //                                         );
                  //                                       }
                  //                                     });
                  //                               } else {
                  //                                 return Text(
                  //                                   'Network Error',
                  //                                   style: BeHealthyTheme
                  //                                       .kMainTextStyle,
                  //                                 );
                  //                               }
                  //                             }
                  //                           },
                  //                         );
                  //                       }),
                  //                 )
                  //               ]);
                  //           }
                  //         },
                  //       )
                  //     : Center(
                  //         child: Container(
                  //           height: medq.height * 0.4,
                  //           width: medq.width * 0.7,
                  //           child: Center(
                  //             child: Text(
                  //               'Please Select A Date To Continue',
                  //               textAlign: TextAlign.center,
                  //               style: BeHealthyTheme.kMainTextStyle.copyWith(
                  //                   color: BeHealthyTheme.kMainOrange,
                  //                   fontSize: 25),
                  //             ),
                  //           ),
                  //         ),
                  //       ),

// ListView.builder(
//                                       itemCount: snap.data.length,
//                                       itemBuilder: (context, index) {
                  // return FutureBuilder(
                  //   future: getMenuFromMealtType(
                  //       '${snap.data[index]}'),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState ==
                  //         ConnectionState.waiting) {
                  //       return Center(
                  //           child:
                  //               CircularProgressIndicator());
                  //     } else {
                  //       if (snapshot.hasData) {
                  //         // final List<Item> _data =
                  //         //     generateItems(snapshot.data);
                  //         return Padding(
                  //           padding:
                  //               const EdgeInsets.all(
                  //                   8.0),
                  //           child: Container(
                  //             // decoration: BoxDecoration(
                  //             //     borderRadius: BorderRadius.circular(15),
                  //             //     color: BeHealthyTheme.kMainOrange
                  //             //         .withOpacity(0.11)),
                  //             child: Column(
                  //               children: [
                  //                 Text(
                  //                   '${snap.data[index]}',
                  //                   style: BeHealthyTheme
                  //                       .kMainTextStyle
                  //                       .copyWith(
                  //                           color: BeHealthyTheme
                  //                               .kMainOrange,
                  //                           fontSize:
                  //                               22),
                  //                 ),
                  //                 Container(
                  //                   height:
                  //                       medq.height *
                  //                           0.25,
                  //                   child: ListView(
                  //                     scrollDirection:
                  //                         Axis.horizontal,
                  //                     children: snapshot
                  //                         .data
                  //                         .map<Widget>(
                  //                             (var product) {
                  //                       return CustomGridItem(
                  //                         title:
                  //                             '${product['ProdName1']}',
                  //                         imageUrl: product[
                  //                             'ProdName3'],
                  //                       );
                  //                     }).toList(),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         );
                  //       } else {
                  //         return Text(
                  //           'Network Error',
                  //           style: BeHealthyTheme
                  //               .kMainTextStyle,
                  //         );
                  //       }
                  //     }
                  //   },
                  // );
                  //});
                  selectedIndex != null
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: mealsTypeList != null ? mealsTypeList.length : 0,
                            itemBuilder: (BuildContext context, int listMealIndex) {
                              return Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                child:
                                  ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: getKitchenItemCount(listMealIndex),
                                      itemBuilder: (BuildContext context, int itemIndex) {
                                        int am = allowedMealsList[listMealIndex];
                                       return  Container(
                                          margin: EdgeInsets.only(bottom: 20),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                                  child: Center(
                                                    child: RichText(
                                                      text: TextSpan(
                                                          text: foodNames[mealsTypeList[listMealIndex].toString()],
                                                          style: BeHealthyTheme.kMainTextStyle.copyWith(
                                                              color: BeHealthyTheme.kMainOrange, fontSize: 24),
                                                          children: [
                                                            TextSpan(text: '${getNumberOfSelectedItems(listMealIndex)}/${am}',
                                                              style: BeHealthyTheme.kMainTextStyle.copyWith(color:
                                                              Color(0xff707070), fontSize: 24),
                                                            )
                                                          ]),
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  indent: 100,
                                                  endIndent: 100,
                                                  thickness: 1.5,
                                                ),
                                                Container(
                                                  height: medq.height * 0.27,
                                                  width: medq.width,
                                                  child: ListView.builder(
                                                    itemCount: wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                        .meals[listMealIndex].items.length,
                                                    scrollDirection: Axis.horizontal,
                                                    itemBuilder: (context, kitchenItemIndex) {
                                                      return Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width * 0.5,
                                                          decoration: BoxDecoration(
                                                              color: wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex].
                                                              items[kitchenItemIndex].isSelected
                                                                  ? Color(0x2B88CB67) : BeHealthyTheme.kMainOrange.withOpacity(0.20),
                                                              borderRadius: BorderRadius.circular(15)),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight:
                                                                    Radius.circular(15)),
                                                                    child: Image(
                                                                      height: MediaQuery.of(context).size.height * 0.11,
                                                                      width: MediaQuery.of(context).size.width * 0.5,
                                                                      fit: BoxFit.cover,
                                                                      image: wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                          .items[kitchenItemIndex].prodName3 != null ?
                                                                      NetworkImage(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                          .items[kitchenItemIndex].prodName3) :
                                                                      AssetImage('assets/images/haha2.png'),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 3,),
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                                                    child: Center(
                                                                      child: Text(
                                                                        wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                            .items[kitchenItemIndex].prodName1,
                                                                        maxLines: 3,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                                                                            fontSize: 13,
                                                                            color: wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                                .items[kitchenItemIndex].isSelected ? Color(0xff88CB67) :
                                                                            BeHealthyTheme.kMainOrange),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  GestureDetector(
                                                                        onTap: () async {
                                                                          int numberOfSelectedItem = getNumberOfSelectedItems(listMealIndex);
                                                                          wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                                              .meals[listMealIndex].items.forEach((item){
                                                                            if (wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                                                .meals[listMealIndex].items[kitchenItemIndex].isSelected)
                                                                              numberOfSelectedItem += 1;
                                                                          });
                                                                            if(!wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                                .items[kitchenItemIndex].isSelected) {
                                                                              //widget.deliveryId = widget.deliveryIdList[index];
                                                                              if (numberOfSelectedItem < am && !wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                                                  .meals[listMealIndex].items[kitchenItemIndex].isSelected) {
                                                                                setState(() {
                                                                                 // selectedNoMeals += 1;
                                                                                  wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                                      .items[kitchenItemIndex].isSelected = true;
                                                                                  selectedMeals.add(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                                                      .meals[listMealIndex].items[kitchenItemIndex].id);
                                                                                });
                                                                                checkMealCount(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                                                    .meals[listMealIndex].items[kitchenItemIndex], true);
                                                                              } else if (numberOfSelectedItem == am &&
                                                                                  wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                                      .items[kitchenItemIndex].isSelected) {
                                                                                setState(() {
                                                                                  //selectedNoMeals -= 1;
                                                                                  wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                                      .items[kitchenItemIndex].isSelected = false;
                                                                                  selectedMeals.remove(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                                                      .meals[listMealIndex].items[kitchenItemIndex].id);
                                                                                });
                                                                                checkMealCount(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                                                    .meals[listMealIndex].items[kitchenItemIndex], false);
                                                                              } else if (selectedMeals.length > 0 && wholePlan.weeks[selectedWeekNumber-1]
                                                                                  .days[dayIndex].
                                                                              meals[listMealIndex].items[kitchenItemIndex].isSelected) {
                                                                                setState(() {
                                                                                  //selectedNoMeals -= 1;
                                                                                  wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                                      .items[kitchenItemIndex].isSelected = false;
                                                                                  selectedMeals.remove(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                                                      .meals[listMealIndex].items[kitchenItemIndex].id);
                                                                                });
                                                                                checkMealCount(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                                                    .meals[listMealIndex].items[kitchenItemIndex], false);
                                                                              } else {
                                                                                Toast.show('Allowed meal exceeded', context);
                                                                              }
                                                                            }else{

                                                                                   setState(() {
                                                                                    // selectedNoMeals -= 1;
                                                                                     wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                                       .items[kitchenItemIndex].isSelected = false;
                                                                                   selectedMeals.remove(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                                                       .meals[listMealIndex].items[kitchenItemIndex].id); });

                                                                              checkMealCount(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex]
                                                                                  .meals[listMealIndex].items[kitchenItemIndex], false);
                                                                            }
                                                                          },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(70), bottomRight:
                                                                          Radius.circular(20)), color: wholePlan.weeks[selectedWeekNumber-1].
                                                                      days[dayIndex].meals[listMealIndex]
                                                                              .items[kitchenItemIndex].isSelected ? Color(0x4588CB67) : BeHealthyTheme
                                                                              .kMainOrange.withOpacity(0.27)),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 10, left: 10),
                                                                        child: Icon(
                                                                          wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                              .items[kitchenItemIndex].isSelected ? Icons.done : Icons.add,
                                                                          size: 30,
                                                                          color: wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[listMealIndex]
                                                                              .items[kitchenItemIndex].isSelected ? Color(0xff88CB67) :
                                                                          BeHealthyTheme.kMainOrange,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                      // return CustomGridItem(
                                                      //   index: index,
                                                      //   title: '${wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].prodName1}',
                                                      //   imageUrl: wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].prodName3,
                                                      //   isCompleted: wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].isSelected,
                                                      //   dataList: wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items,
                                                      //   onTap: () async {
                                                      //     if(!wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].isSelected) {
                                                      //       //widget.deliveryId = widget.deliveryIdList[index];
                                                      //       if (_selected_meals < am && !wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].isSelected) {
                                                      //         setState(() {
                                                      //           _selected_meals += 1;
                                                      //           wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].isSelected = true;
                                                      //           selectedMeals.add(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].id);
                                                      //         });
                                                      //         checkMealCount(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index], true);
                                                      //       } else if (_selected_meals == am &&
                                                      //           wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].isSelected) {
                                                      //         setState(() {
                                                      //           _selected_meals -= 1;
                                                      //           wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].isSelected = false;
                                                      //           selectedMeals.remove(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].id);
                                                      //         });
                                                      //         checkMealCount(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index], false);
                                                      //       } else if (selectedMeals.length > 0 && wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].
                                                      //       meals[mealIndex].items[index].isSelected) {
                                                      //         setState(() {
                                                      //           _selected_meals -= 1;
                                                      //           wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].isSelected = false;
                                                      //           selectedMeals.remove(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].id);
                                                      //         });
                                                      //         checkMealCount(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index], false);
                                                      //       } else {
                                                      //         Toast.show('Allowed meal exceeded', context);
                                                      //       }
                                                      //     }else{
                                                      //       _selected_meals -= 1;
                                                      //       wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].isSelected = false;
                                                      //       selectedMeals.remove(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index].id);
                                                      //       checkMealCount(wholePlan.weeks[selectedWeekNumber-1].days[dayIndex].meals[mealIndex].items[index], false);
                                                      //     }
                                                      //   },
                                                      // );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                        // return MealTypeWidget(allowdMeals: am, mealIndex: index, planId: widget.planId, mealsTypeList: mealsTypeList,
                                        //   expectedDelDay: expectedDelDay, transid: transid, switch5: "switch5", deliveryId: deliveryId,
                                        //   deliveryIdList: deliveryIdList,selectedWeekNumber: selectedWeekNumber-1,dayIndex: dayIndex,
                                        //   data: wholePlan.weeks[selectedWeekNumber].days[dayIndex].meals[index].items);
                              }),
                                  // FutureBuilder(
                                  //   future: getMenuFromMealType(mealsTypeList[index].toString(),index),
                                  //   builder: (context,
                                  //       AsyncSnapshot<List<Data>> snapshot) {
                                  //     if (snapshot.connectionState ==
                                  //         ConnectionState.waiting) {
                                  //       return Center(
                                  //           child: CircularProgressIndicator());
                                  //     } else {
                                  //       if (snapshot.hasData) {
                                  //         int am = allowedMealsList[index];
                                  //         selectedMealType =
                                  //             mealsTypeList[index].toString();
                                  //         print(deliveryIdList);
                                  //         deliveryId = deliveryIdList[index];
                                  //         if (snapshot.data.length > 0) {
                                  //           return FutureBuilder(
                                  //               future: _querySelected(14, transid, expectedDelDay, widget.planId, snapshot.data[0].mealType),
                                  //               builder: (context, snap) {
                                  //                 if (snap.connectionState == ConnectionState.waiting) {
                                  //                   return CircularProgressIndicator();
                                  //                 } else {
                                  //                   var switch5 = snap.data[0]['switch5'];
                                  //                   int cnt = 0;
                                  //                   snap.data.forEach((value) {
                                  //                     if (value['switch5'] != '10009') cnt++;
                                  //                   });
                                  //                   return MealTypeWidget(
                                  //                     allowdMeals: am,
                                  //                     index: index,
                                  //                     planId: widget.planId,
                                  //                     mealsTypeList:
                                  //                         mealsTypeList,
                                  //                     mealsForType:
                                  //                         snapshot.data,
                                  //                     rowSelectData: snap,
                                  //                     expectedDelDay:
                                  //                         expectedDelDay,
                                  //                     transid: transid,
                                  //                     switch5: switch5,
                                  //                     deliveryId: deliveryId,
                                  //                     deliveryIdList:
                                  //                         deliveryIdList,
                                  //
                                  //                     //  checkMealCount: checkMealCount(snap, true),
                                  //                   );
                                  //                   //TODO Passant un comment this
                                  //                   //   Padding(
                                  //                   //   padding:
                                  //                   //       const EdgeInsets.all(
                                  //                   //           8.0),
                                  //                   //   child: Container(
                                  //                   //     // decoration: BoxDecoration(
                                  //                   //     //     borderRadius: BorderRadius.circular(15),
                                  //                   //     //     color: BeHealthyTheme.kMainOrange
                                  //                   //     //         .withOpacity(0.11)),
                                  //                   //     child: Column(
                                  //                   //       children: [
                                  //                   //         Padding(
                                  //                   //           padding:
                                  //                   //               const EdgeInsets
                                  //                   //                       .symmetric(
                                  //                   //                   vertical:
                                  //                   //                       3),
                                  //                   //           child: Center(
                                  //                   //             child: RichText(
                                  //                   //               text: TextSpan(
                                  //                   //                   text: foodNames[
                                  //                   //                       mealsTypeList[index]
                                  //                   //                           .toString()],
                                  //                   //                   style: BeHealthyTheme.kMainTextStyle.copyWith(
                                  //                   //                       color: BeHealthyTheme
                                  //                   //                           .kMainOrange,
                                  //                   //                       fontSize:
                                  //                   //                           24),
                                  //                   //                   children: [
                                  //                   //                     TextSpan(
                                  //                   //                       text:
                                  //                   //                           '  $cnt/$am',
                                  //                   //                       style: BeHealthyTheme.kMainTextStyle.copyWith(
                                  //                   //                           color: Color(0xff707070),
                                  //                   //                           fontSize: 24),
                                  //                   //                     )
                                  //                   //                   ]),
                                  //                   //             ),
                                  //                   //             //   child: Text(
                                  //                   //             //     'Breakfast   $cnt/$am',
                                  //                   //             //     style: BeHealthyTheme
                                  //                   //             //         .kMainTextStyle
                                  //                   //             //         .copyWith(
                                  //                   //             //             color: Color(0xff707070),
                                  //                   //             //                 // BeHealthyTheme.kMainOrange,
                                  //                   //             //             fontSize: 24),
                                  //                   //             //   ),
                                  //                   //           ),
                                  //                   //         ),
                                  //                   //         Divider(
                                  //                   //           indent: 100,
                                  //                   //           endIndent: 100,
                                  //                   //           thickness: 1.5,
                                  //                   //         ),
                                  //                   //         Container(
                                  //                   //           height:
                                  //                   //               medq.height *
                                  //                   //                   0.25,
                                  //                   //           width: medq.width,
                                  //                   //           child: ListView(
                                  //                   //             scrollDirection:
                                  //                   //                 Axis.horizontal,
                                  //                   //             children: snapshot
                                  //                   //                 .data
                                  //                   //                 .map<Widget>(
                                  //                   //                     (var product) {
                                  //                   //               return CustomGridItem(
                                  //                   //                 title:
                                  //                   //                     '${product['ProdName1']}',
                                  //                   //                 imageUrl:
                                  //                   //                     product[
                                  //                   //                         'ProdName3'],
                                  //                   //                 isCompleted: switch5 ==
                                  //                   //                         product['ProdName1']
                                  //                   //                     ? true
                                  //                   //                     : false,
                                  //                   //                 onTap:
                                  //                   //                     () async {
                                  //                   //                   deliveryId =
                                  //                   //                       deliveryIdList[
                                  //                   //                           index];
                                  //                   //                   //checking the tick icon
                                  //                   //                   if (switch5 !=
                                  //                   //                       product[
                                  //                   //                           'ProdName1']) {
                                  //                   //
                                  //                   //
                                  //                   //                     snap.data
                                  //                   //                         .forEach((value) {
                                  //                   //                       if (value['switch5'] ==
                                  //                   //                           '10009') {
                                  //                   //                         checkMealCount(
                                  //                   //                           product,
                                  //                   //                           true,
                                  //                   //                         );
                                  //                   //                       } else {
                                  //                   //                         Toast.show('Allowed meal exceeded',
                                  //                   //                             context);
                                  //                   //                       }
                                  //                   //                     });
                                  //                   //                   } else {
                                  //                   //                     checkMealCount(
                                  //                   //                       product,
                                  //                   //                       false,
                                  //                   //                     );
                                  //                   //                   }
                                  //                   //                   setState(
                                  //                   //                       () {});
                                  //                   //
                                  //                   //                   // checkFunction(, snap, value, allowedM)
                                  //                   //                 },
                                  //                   //               );
                                  //                   //             }).toList(),
                                  //                   //           ),
                                  //                   //         ),
                                  //                   //       ],
                                  //                   //     ),
                                  //                   //   ),
                                  //                   // );
                                  //                 }
                                  //               });
                                  //         } else {
                                  //           return Center(
                                  //             child: Text('Empty Data'),
                                  //           );
                                  //         }
                                  //       } else {
                                  //         return Text(
                                  //           'Network Error',
                                  //           style:
                                  //               BeHealthyTheme.kMainTextStyle,
                                  //         );
                                  //       }
                                  //     }
                                  //   },
                                  // )  //Here is Comment

                              );
                            },
                          ),
                        )
                      // ? Column(
                      //     children: [
                      //       mealsTypeList.contains(1401)
                      //           ? FutureBuilder(
                      //               future: getMenuFromMealtType('1401'),
                      //               builder: (context, snapshot) {
                      //                 if (snapshot.connectionState ==
                      //                     ConnectionState.waiting) {
                      //                   return Center(
                      //                       child:
                      //                           CircularProgressIndicator());
                      //                 } else {
                      //                   if (snapshot.hasData) {
                      //                     // final List<Item> _data =
                      //                     //     generateItems(snapshot.data);
                      //                     int am = allowedMealsList[0];
                      //                     selectedMealType = '1401';
                      //                     print(deliveryIdList);
                      //                     deliveryId = deliveryIdList[0];
                      //                     return FutureBuilder(
                      //                         future: _querySelected(
                      //                             14,
                      //                             transid,
                      //                             deliveryId,
                      //                             expectedDelDay,
                      //                             widget.planId,
                      //                             snapshot.data[0]
                      //                                 ['MealType']),
                      //                         builder: (context, snap) {
                      //                           if (snap.connectionState ==
                      //                               ConnectionState.waiting) {
                      //                             return CircularProgressIndicator();
                      //                           } else {
                      //                             var switch5 =
                      //                                 snap.data[0]['switch5'];
                      //                             int cnt = 0;
                      //                             snap.data.forEach((value) {
                      //                               if (value['switch5'] !=
                      //                                   '10009') cnt++;
                      //                             });
                      //                             return Padding(
                      //                               padding:
                      //                                   const EdgeInsets.all(
                      //                                       8.0),
                      //                               child: Container(
                      //                                 // decoration: BoxDecoration(
                      //                                 //     borderRadius: BorderRadius.circular(15),
                      //                                 //     color: BeHealthyTheme.kMainOrange
                      //                                 //         .withOpacity(0.11)),
                      //                                 child: Column(
                      //                                   children: [
                      //                                     Padding(
                      //                                       padding:
                      //                                           const EdgeInsets
                      //                                                   .symmetric(
                      //                                               vertical:
                      //                                                   3),
                      //                                       child: Center(
                      //                                         child: RichText(
                      //                                           text: TextSpan(
                      //                                               text:
                      //                                                   'Breakfast',
                      //                                               style: BeHealthyTheme.kMainTextStyle.copyWith(
                      //                                                   color: BeHealthyTheme
                      //                                                       .kMainOrange,
                      //                                                   fontSize:
                      //                                                       24),
                      //                                               children: [
                      //                                                 TextSpan(
                      //                                                   text:
                      //                                                       '  $cnt/$am',
                      //                                                   style: BeHealthyTheme.kMainTextStyle.copyWith(
                      //                                                       color: Color(0xff707070),
                      //                                                       fontSize: 24),
                      //                                                 )
                      //                                               ]),
                      //                                         ),
                      //                                         //   child: Text(
                      //                                         //     'Breakfast   $cnt/$am',
                      //                                         //     style: BeHealthyTheme
                      //                                         //         .kMainTextStyle
                      //                                         //         .copyWith(
                      //                                         //             color: Color(0xff707070),
                      //                                         //                 // BeHealthyTheme.kMainOrange,
                      //                                         //             fontSize: 24),
                      //                                         //   ),
                      //                                       ),
                      //                                     ),
                      //                                     Divider(
                      //                                       indent: 100,
                      //                                       endIndent: 100,
                      //                                       thickness: 1.5,
                      //                                     ),
                      //                                     Container(
                      //                                       height:
                      //                                           medq.height *
                      //                                               0.25,
                      //                                       width: medq.width,
                      //                                       child: ListView(
                      //                                         scrollDirection:
                      //                                             Axis.horizontal,
                      //                                         children: snapshot
                      //                                             .data
                      //                                             .map<Widget>(
                      //                                                 (var product) {
                      //                                           return CustomGridItem(
                      //                                             title:
                      //                                                 '${product['ProdName1']}',
                      //                                             imageUrl:
                      //                                                 product[
                      //                                                     'ProdName3'],
                      //                                             isCompleted: switch5 ==
                      //                                                     product['ProdName1']
                      //                                                 ? true
                      //                                                 : false,
                      //                                             onTap:
                      //                                                 () async {
                      //                                               deliveryId =
                      //                                                   deliveryIdList[
                      //                                                       0];
                      //                                               //checking the tick icon
                      //                                               if (switch5 !=
                      //                                                   product[
                      //                                                       'ProdName1']) {
                      //                                                 snap.data
                      //                                                     .forEach((value) {
                      //                                                   if (value['switch5'] ==
                      //                                                       '10009') {
                      //                                                     checkMealCount(
                      //                                                         product,
                      //                                                         true,
                      //                                                         am);
                      //                                                   } else {
                      //                                                     Toast.show('Allowed meal exceeded',
                      //                                                         context);
                      //                                                   }
                      //                                                 });
                      //                                               } else {
                      //                                                 checkMealCount(
                      //                                                     product,
                      //                                                     false,
                      //                                                     am);
                      //                                               }
                      //                                               setState(
                      //                                                   () {});
                      //
                      //                                               // checkFunction(, snap, value, allowedM)
                      //                                             },
                      //                                           );
                      //                                         }).toList(),
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                             );
                      //                           }
                      //                         });
                      //                   } else {
                      //                     return Text(
                      //                       'Network Error',
                      //                       style:
                      //                           BeHealthyTheme.kMainTextStyle,
                      //                     );
                      //                   }
                      //                 }
                      //               },
                      //             )
                      //           : Text(''),
                      //       mealsTypeList.contains(1402)
                      //           ? FutureBuilder(
                      //               future: getMenuFromMealtType('1402'),
                      //               builder: (context, snapshot) {
                      //                 if (snapshot.connectionState ==
                      //                     ConnectionState.waiting) {
                      //                   return Center(
                      //                       child:
                      //                           CircularProgressIndicator());
                      //                 } else {
                      //                   if (snapshot.hasData) {
                      //                     int am = allowedMealsList[1];
                      //                     selectedMealType = '1402';
                      //                     deliveryId = deliveryIdList[1];
                      //                     return FutureBuilder(
                      //                         future: _querySelected(
                      //                             14,
                      //                             transid,
                      //                             deliveryId,
                      //                             expectedDelDay,
                      //                             widget.planId,
                      //                             snapshot.data[0]
                      //                                 ['MealType']),
                      //                         builder: (context, snap) {
                      //                           if (snap.connectionState ==
                      //                               ConnectionState.waiting) {
                      //                             return CircularProgressIndicator();
                      //                           } else {
                      //                             var switch5 =
                      //                                 snap.data[0]['switch5'];
                      //                             int cnt = 0;
                      //                             snap.data.forEach((value) {
                      //                               if (value['switch5'] !=
                      //                                   '10009') cnt++;
                      //                             });
                      //                             return Padding(
                      //                               padding:
                      //                                   const EdgeInsets.all(
                      //                                       8.0),
                      //                               child: Container(
                      //                                 // decoration: BoxDecoration(
                      //                                 //     borderRadius: BorderRadius.circular(15),
                      //                                 //     color: BeHealthyTheme.kMainOrange
                      //                                 //         .withOpacity(0.11)),
                      //                                 child: Column(
                      //                                   children: [
                      //                                     Center(
                      //                                       child: RichText(
                      //                                         text: TextSpan(
                      //                                             text:
                      //                                                 'Lunch',
                      //                                             style: BeHealthyTheme
                      //                                                 .kMainTextStyle
                      //                                                 .copyWith(
                      //                                                     color:
                      //                                                         BeHealthyTheme.kMainOrange,
                      //                                                     fontSize: 24),
                      //                                             children: [
                      //                                               TextSpan(
                      //                                                 text:
                      //                                                     '  $cnt/$am',
                      //                                                 style: BeHealthyTheme.kMainTextStyle.copyWith(
                      //                                                     color:
                      //                                                         Color(0xff707070),
                      //                                                     fontSize: 24),
                      //                                               )
                      //                                             ]),
                      //                                       ),
                      //                                       // child: Text(
                      //                                       //   'Lunch   $cnt/$am',
                      //                                       //   style: BeHealthyTheme
                      //                                       //       .kMainTextStyle
                      //                                       //       .copyWith(
                      //                                       //           color: BeHealthyTheme
                      //                                       //               .kMainOrange,
                      //                                       //           fontSize:
                      //                                       //               22),
                      //                                       // ),
                      //                                     ),
                      //                                     Divider(
                      //                                       indent: 100,
                      //                                       endIndent: 100,
                      //                                       thickness: 1.5,
                      //                                     ),
                      //                                     Container(
                      //                                       height:
                      //                                           medq.height *
                      //                                               0.25,
                      //                                       width: medq.width,
                      //                                       child: ListView(
                      //                                         scrollDirection:
                      //                                             Axis.horizontal,
                      //                                         children: snapshot
                      //                                             .data
                      //                                             .map<Widget>(
                      //                                                 (var product) {
                      //                                           return CustomGridItem(
                      //                                             title:
                      //                                                 '${product['ProdName1']}',
                      //                                             imageUrl:
                      //                                                 product[
                      //                                                     'ProdName3'],
                      //                                             isCompleted: switch5 ==
                      //                                                     product['ProdName1']
                      //                                                 ? true
                      //                                                 : false,
                      //                                             onTap:
                      //                                                 () async {
                      //                                               deliveryId =
                      //                                                   deliveryIdList[
                      //                                                       1];
                      //                                               //checking the tick icon
                      //                                               if (switch5 !=
                      //                                                   product[
                      //                                                       'ProdName1']) {
                      //                                                 snap.data
                      //                                                     .forEach((value) {
                      //                                                   if (value['switch5'] ==
                      //                                                       '10009') {
                      //                                                     checkMealCount(
                      //                                                         product,
                      //                                                         true,
                      //                                                         am);
                      //                                                   } else {
                      //                                                     Toast.show('Exceeded Allowed Meal',
                      //                                                         context);
                      //                                                   }
                      //                                                 });
                      //                                               } else {
                      //                                                 checkMealCount(
                      //                                                     product,
                      //                                                     false,
                      //                                                     am);
                      //                                               }
                      //                                               setState(
                      //                                                   () {});
                      //
                      //                                               // checkFunction(, snap, value, allowedM)
                      //                                             },
                      //                                           );
                      //                                         }).toList(),
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                             );
                      //                           }
                      //                         });
                      //                   } else {
                      //                     return Text(
                      //                       'Network Error',
                      //                       style:
                      //                           BeHealthyTheme.kMainTextStyle,
                      //                     );
                      //                   }
                      //                 }
                      //               },
                      //             )
                      //           : Text(''),
                      //       mealsTypeList.contains(1403)
                      //           ? FutureBuilder(
                      //               future: getMenuFromMealtType('1403'),
                      //               builder: (context, snapshot) {
                      //                 if (snapshot.connectionState ==
                      //                     ConnectionState.waiting) {
                      //                   return Center(
                      //                       child:
                      //                           CircularProgressIndicator());
                      //                 } else {
                      //                   if (snapshot.hasData) {
                      //                     int am = allowedMealsList[2];
                      //                     selectedMealType = '1403';
                      //                     deliveryId = deliveryIdList[2];
                      //                     return FutureBuilder(
                      //                         future: _querySelected(
                      //                             14,
                      //                             transid,
                      //                             deliveryId,
                      //                             expectedDelDay,
                      //                             widget.planId,
                      //                             snapshot.data[0]
                      //                                 ['MealType']),
                      //                         builder: (context, snap) {
                      //                           if (snap.connectionState ==
                      //                               ConnectionState.waiting) {
                      //                             return CircularProgressIndicator();
                      //                           } else {
                      //                             var switch5 =
                      //                                 snap.data[0]['switch5'];
                      //                             int cnt = 0;
                      //                             snap.data.forEach((value) {
                      //                               if (value['switch5'] !=
                      //                                   '10009') cnt++;
                      //                             });
                      //                             return Padding(
                      //                               padding:
                      //                                   const EdgeInsets.all(
                      //                                       8.0),
                      //                               child: Container(
                      //                                 // decoration: BoxDecoration(
                      //                                 //     borderRadius: BorderRadius.circular(15),
                      //                                 //     color: BeHealthyTheme.kMainOrange
                      //                                 //         .withOpacity(0.11)),
                      //                                 child: Column(
                      //                                   children: [
                      //                                     Center(
                      //                                       child: RichText(
                      //                                         text: TextSpan(
                      //                                             text:
                      //                                                 'Dinner',
                      //                                             style: BeHealthyTheme
                      //                                                 .kMainTextStyle
                      //                                                 .copyWith(
                      //                                                     color:
                      //                                                         BeHealthyTheme.kMainOrange,
                      //                                                     fontSize: 24),
                      //                                             children: [
                      //                                               TextSpan(
                      //                                                 text:
                      //                                                     '  $cnt/$am',
                      //                                                 style: BeHealthyTheme.kMainTextStyle.copyWith(
                      //                                                     color:
                      //                                                         Color(0xff707070),
                      //                                                     fontSize: 24),
                      //                                               )
                      //                                             ]),
                      //                                       ),
                      //                                       // child: Text(
                      //                                       //   'Dinner   $cnt/$am',
                      //                                       //   style: BeHealthyTheme
                      //                                       //       .kMainTextStyle
                      //                                       //       .copyWith(
                      //                                       //           color: BeHealthyTheme
                      //                                       //               .kMainOrange,
                      //                                       //           fontSize:
                      //                                       //               22),
                      //                                       // ),
                      //                                     ),
                      //                                     Divider(
                      //                                       indent: 100,
                      //                                       endIndent: 100,
                      //                                       thickness: 1.5,
                      //                                     ),
                      //                                     Container(
                      //                                       height:
                      //                                           medq.height *
                      //                                               0.25,
                      //                                       width: medq.width,
                      //                                       child: ListView(
                      //                                         scrollDirection:
                      //                                             Axis.horizontal,
                      //                                         children: snapshot
                      //                                             .data
                      //                                             .map<Widget>(
                      //                                                 (var product) {
                      //                                           return CustomGridItem(
                      //                                             title:
                      //                                                 '${product['ProdName1']}',
                      //                                             imageUrl:
                      //                                                 product[
                      //                                                     'ProdName3'],
                      //                                             isCompleted: switch5 ==
                      //                                                     product['ProdName1']
                      //                                                 ? true
                      //                                                 : false,
                      //                                             onTap:
                      //                                                 () async {
                      //                                               deliveryId =
                      //                                                   deliveryIdList[
                      //                                                       2];
                      //                                               //checking the tick icon
                      //                                               if (switch5 !=
                      //                                                   product[
                      //                                                       'ProdName1']) {
                      //                                                 snap.data
                      //                                                     .forEach((value) {
                      //                                                   if (value['switch5'] ==
                      //                                                       '10009') {
                      //                                                     checkMealCount(
                      //                                                         product,
                      //                                                         true,
                      //                                                         am);
                      //                                                   } else {
                      //                                                     Toast.show('Exceeded Allowed Meal',
                      //                                                         context);
                      //                                                   }
                      //                                                 });
                      //                                               } else {
                      //                                                 checkMealCount(
                      //                                                     product,
                      //                                                     false,
                      //                                                     am);
                      //                                               }
                      //                                               setState(
                      //                                                   () {});
                      //
                      //                                               // checkFunction(, snap, value, allowedM)
                      //                                             },
                      //                                           );
                      //                                         }).toList(),
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                             );
                      //                           }
                      //                         });
                      //                   } else {
                      //                     return Text(
                      //                       'Network Error',
                      //                       style:
                      //                           BeHealthyTheme.kMainTextStyle,
                      //                     );
                      //                   }
                      //                 }
                      //               },
                      //             )
                      //           : Text(''),
                      //       mealsTypeList.contains(1404)
                      //           ? FutureBuilder(
                      //               future: getMenuFromMealtType('1404'),
                      //               builder: (context, snapshot) {
                      //                 if (snapshot.connectionState ==
                      //                     ConnectionState.waiting) {
                      //                   return Center(
                      //                       child:
                      //                           CircularProgressIndicator());
                      //                 } else {
                      //                   if (snapshot.hasData) {
                      //                     int am = allowedMealsList[3];
                      //                     selectedMealType = '1404';
                      //                     deliveryId = deliveryIdList[3];
                      //                     return FutureBuilder(
                      //                         future: _querySelected(
                      //                             14,
                      //                             transid,
                      //                             deliveryId,
                      //                             expectedDelDay,
                      //                             widget.planId,
                      //                             snapshot.data[0]
                      //                                 ['MealType']),
                      //                         builder: (context, snap) {
                      //                           if (snap.connectionState ==
                      //                               ConnectionState.waiting) {
                      //                             return CircularProgressIndicator();
                      //                           } else {
                      //                             var switch5 =
                      //                                 snap.data[0]['switch5'];
                      //                             int cnt = 0;
                      //                             snap.data.forEach((value) {
                      //                               if (value['switch5'] !=
                      //                                   '10009') cnt++;
                      //                             });
                      //                             return Padding(
                      //                               padding:
                      //                                   const EdgeInsets.all(
                      //                                       8.0),
                      //                               child: Container(
                      //                                 // decoration: BoxDecoration(
                      //                                 //     borderRadius: BorderRadius.circular(15),
                      //                                 //     color: BeHealthyTheme.kMainOrange
                      //                                 //         .withOpacity(0.11)),
                      //                                 child: Column(
                      //                                   children: [
                      //                                     Center(
                      //                                       child: RichText(
                      //                                         text: TextSpan(
                      //                                             text:
                      //                                                 'Snack',
                      //                                             style: BeHealthyTheme
                      //                                                 .kMainTextStyle
                      //                                                 .copyWith(
                      //                                                     color:
                      //                                                         BeHealthyTheme.kMainOrange,
                      //                                                     fontSize: 24),
                      //                                             children: [
                      //                                               TextSpan(
                      //                                                 text:
                      //                                                     '  $cnt/$am',
                      //                                                 style: BeHealthyTheme.kMainTextStyle.copyWith(
                      //                                                     color:
                      //                                                         Color(0xff707070),
                      //                                                     fontSize: 24),
                      //                                               )
                      //                                             ]),
                      //                                       ),
                      //                                       // child: Text(
                      //                                       //   'Snack   $cnt/$am',
                      //                                       //   style: BeHealthyTheme
                      //                                       //       .kMainTextStyle
                      //                                       //       .copyWith(
                      //                                       //           color: BeHealthyTheme
                      //                                       //               .kMainOrange,
                      //                                       //           fontSize:
                      //                                       //               22),
                      //                                       // ),
                      //                                     ),
                      //                                     Divider(
                      //                                       indent: 100,
                      //                                       endIndent: 100,
                      //                                       thickness: 1.5,
                      //                                     ),
                      //                                     Container(
                      //                                       height:
                      //                                           medq.height *
                      //                                               0.25,
                      //                                       width: medq.width,
                      //                                       child: ListView(
                      //                                         scrollDirection:
                      //                                             Axis.horizontal,
                      //                                         children: snapshot
                      //                                             .data
                      //                                             .map<Widget>(
                      //                                                 (var product) {
                      //                                           return CustomGridItem(
                      //                                             title:
                      //                                                 '${product['ProdName1']}',
                      //                                             imageUrl:
                      //                                                 product[
                      //                                                     'ProdName3'],
                      //                                             isCompleted: switch5 ==
                      //                                                     product['ProdName1']
                      //                                                 ? true
                      //                                                 : false,
                      //                                             onTap:
                      //                                                 () async {
                      //                                               deliveryId =
                      //                                                   deliveryIdList[
                      //                                                       3];
                      //                                               //checking the tick icon
                      //                                               if (switch5 !=
                      //                                                   product[
                      //                                                       'ProdName1']) {
                      //                                                 snap.data
                      //                                                     .forEach((value) {
                      //                                                   if (value['switch5'] ==
                      //                                                       '10009') {
                      //                                                     checkMealCount(
                      //                                                         product,
                      //                                                         true,
                      //                                                         am);
                      //                                                   } else {
                      //                                                     Toast.show('Exceeded Allowed Meal',
                      //                                                         context);
                      //                                                   }
                      //                                                 });
                      //                                               } else {
                      //                                                 checkMealCount(
                      //                                                     product,
                      //                                                     false,
                      //                                                     am);
                      //                                               }
                      //                                               setState(
                      //                                                   () {});
                      //
                      //                                               // checkFunction(, snap, value, allowedM)
                      //                                             },
                      //                                           );
                      //                                         }).toList(),
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                             );
                      //                           }
                      //                         });
                      //                   } else {
                      //                     return Text(
                      //                       'Network Error',
                      //                       style:
                      //                           BeHealthyTheme.kMainTextStyle,
                      //                     );
                      //                   }
                      //                 }
                      //               },
                      //             )
                      //           : Text(''),
                      //       mealsTypeList.contains(1405)
                      //           ? FutureBuilder(
                      //               future: getMenuFromMealtType('1405'),
                      //               builder: (context, snapshot) {
                      //                 if (snapshot.connectionState ==
                      //                     ConnectionState.waiting) {
                      //                   return Center(
                      //                       child:
                      //                           CircularProgressIndicator());
                      //                 } else {
                      //                   if (snapshot.hasData) {
                      //                     int am = allowedMealsList[4];
                      //                     selectedMealType = '1405';
                      //                     deliveryId = deliveryIdList[4];
                      //                     return FutureBuilder(
                      //                         future: _querySelected(
                      //                             14,
                      //                             transid,
                      //                             deliveryId,
                      //                             expectedDelDay,
                      //                             widget.planId,
                      //                             snapshot.data[0]
                      //                                 ['MealType']),
                      //                         builder: (context, snap) {
                      //                           if (snap.connectionState ==
                      //                               ConnectionState.waiting) {
                      //                             return CircularProgressIndicator();
                      //                           } else {
                      //                             var switch5 =
                      //                                 snap.data[0]['switch5'];
                      //                             int cnt = 0;
                      //                             snap.data.forEach((value) {
                      //                               if (value['switch5'] !=
                      //                                   '10009') cnt++;
                      //                             });
                      //                             return Padding(
                      //                               padding:
                      //                                   const EdgeInsets.all(
                      //                                       8.0),
                      //                               child: Container(
                      //                                 // decoration: BoxDecoration(
                      //                                 //     borderRadius: BorderRadius.circular(15),
                      //                                 //     color: BeHealthyTheme.kMainOrange
                      //                                 //         .withOpacity(0.11)),
                      //                                 child: Column(
                      //                                   children: [
                      //                                     Center(
                      //                                       child: RichText(
                      //                                         text: TextSpan(
                      //                                             text:
                      //                                                 'Salad',
                      //                                             style: BeHealthyTheme
                      //                                                 .kMainTextStyle
                      //                                                 .copyWith(
                      //                                                     color:
                      //                                                         BeHealthyTheme.kMainOrange,
                      //                                                     fontSize: 24),
                      //                                             children: [
                      //                                               TextSpan(
                      //                                                 text:
                      //                                                     '  $cnt/$am',
                      //                                                 style: BeHealthyTheme.kMainTextStyle.copyWith(
                      //                                                     color:
                      //                                                         Color(0xff707070),
                      //                                                     fontSize: 24),
                      //                                               )
                      //                                             ]),
                      //                                       ),
                      //                                       // child: Text(
                      //                                       //   'Salad   $cnt/$am',
                      //                                       //   style: BeHealthyTheme
                      //                                       //       .kMainTextStyle
                      //                                       //       .copyWith(
                      //                                       //           color: BeHealthyTheme
                      //                                       //               .kMainOrange,
                      //                                       //           fontSize:
                      //                                       //               22),
                      //                                       // ),
                      //                                     ),
                      //                                     Divider(
                      //                                       indent: 100,
                      //                                       endIndent: 100,
                      //                                       thickness: 1.5,
                      //                                     ),
                      //                                     Container(
                      //                                       height:
                      //                                           medq.height *
                      //                                               0.25,
                      //                                       width: medq.width,
                      //                                       child: ListView(
                      //                                         scrollDirection:
                      //                                             Axis.horizontal,
                      //                                         children: snapshot
                      //                                             .data
                      //                                             .map<Widget>(
                      //                                                 (var product) {
                      //                                           return CustomGridItem(
                      //                                             title:
                      //                                                 '${product['ProdName1']}',
                      //                                             imageUrl:
                      //                                                 product[
                      //                                                     'ProdName3'],
                      //                                             isCompleted: switch5 ==
                      //                                                     product['ProdName1']
                      //                                                 ? true
                      //                                                 : false,
                      //                                             onTap:
                      //                                                 () async {
                      //                                               deliveryId =
                      //                                                   deliveryIdList[
                      //                                                       4];
                      //                                               //checking the tick icon
                      //                                               if (switch5 !=
                      //                                                   product[
                      //                                                       'ProdName1']) {
                      //                                                 snap.data
                      //                                                     .forEach((value) {
                      //                                                   if (value['switch5'] ==
                      //                                                       '10009') {
                      //                                                     checkMealCount(
                      //                                                         product,
                      //                                                         true,
                      //                                                         am);
                      //                                                   } else {
                      //                                                     Toast.show('Exceeded Allowed Meal',
                      //                                                         context);
                      //                                                   }
                      //                                                 });
                      //                                               } else {
                      //                                                 checkMealCount(
                      //                                                     product,
                      //                                                     false,
                      //                                                     am);
                      //                                               }
                      //                                               setState(
                      //                                                   () {});
                      //
                      //                                               // checkFunction(, snap, value, allowedM)
                      //                                             },
                      //                                           );
                      //                                         }).toList(),
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                             );
                      //                           }
                      //                         });
                      //                   } else {
                      //                     return Text(
                      //                       'Network Error',
                      //                       style:
                      //                           BeHealthyTheme.kMainTextStyle,
                      //                     );
                      //                   }
                      //                 }
                      //               },
                      //             )
                      //           : Text(''),
                      //       mealsTypeList.contains(1406)
                      //           ? FutureBuilder(
                      //               future: getMenuFromMealtType('1406'),
                      //               builder: (context, snapshot) {
                      //                 if (snapshot.connectionState ==
                      //                     ConnectionState.waiting) {
                      //                   return Center(
                      //                       child:
                      //                           CircularProgressIndicator());
                      //                 } else {
                      //                   if (snapshot.hasData) {
                      //                     int am = allowedMealsList[4];
                      //                     selectedMealType = '1406';
                      //                     deliveryId = deliveryIdList[5];
                      //                     return FutureBuilder(
                      //                         future: _querySelected(
                      //                             14,
                      //                             transid,
                      //                             deliveryId,
                      //                             expectedDelDay,
                      //                             widget.planId,
                      //                             snapshot.data[0]
                      //                                 ['MealType']),
                      //                         builder: (context, snap) {
                      //                           if (snap.connectionState ==
                      //                               ConnectionState.waiting) {
                      //                             return CircularProgressIndicator();
                      //                           } else {
                      //                             var switch5 =
                      //                                 snap.data[0]['switch5'];
                      //                             int cnt = 0;
                      //                             snap.data.forEach((value) {
                      //                               if (value['switch5'] !=
                      //                                   '10009') cnt++;
                      //                             });
                      //                             return Padding(
                      //                               padding:
                      //                                   const EdgeInsets.all(
                      //                                       8.0),
                      //                               child: Container(
                      //                                 // decoration: BoxDecoration(
                      //                                 //     borderRadius: BorderRadius.circular(15),
                      //                                 //     color: BeHealthyTheme.kMainOrange
                      //                                 //         .withOpacity(0.11)),
                      //                                 child: Column(
                      //                                   children: [
                      //                                     Center(
                      //                                       child: RichText(
                      //                                         text: TextSpan(
                      //                                             text:
                      //                                                 'Soup',
                      //                                             style: BeHealthyTheme
                      //                                                 .kMainTextStyle
                      //                                                 .copyWith(
                      //                                                     color:
                      //                                                         BeHealthyTheme.kMainOrange,
                      //                                                     fontSize: 24),
                      //                                             children: [
                      //                                               TextSpan(
                      //                                                 text:
                      //                                                     '  $cnt/$am',
                      //                                                 style: BeHealthyTheme.kMainTextStyle.copyWith(
                      //                                                     color:
                      //                                                         Color(0xff707070),
                      //                                                     fontSize: 24),
                      //                                               )
                      //                                             ]),
                      //                                       ),
                      //                                       // child: Text(
                      //                                       //   'Soup   $cnt/$am',
                      //                                       //   style: BeHealthyTheme
                      //                                       //       .kMainTextStyle
                      //                                       //       .copyWith(
                      //                                       //           color: BeHealthyTheme
                      //                                       //               .kMainOrange,
                      //                                       //           fontSize:
                      //                                       //               22),
                      //                                       // ),
                      //                                     ),
                      //                                     Divider(
                      //                                       indent: 100,
                      //                                       endIndent: 100,
                      //                                       thickness: 1.5,
                      //                                     ),
                      //                                     Container(
                      //                                       height:
                      //                                           medq.height *
                      //                                               0.25,
                      //                                       width: medq.width,
                      //                                       child: ListView(
                      //                                         scrollDirection:
                      //                                             Axis.horizontal,
                      //                                         children: snapshot
                      //                                             .data
                      //                                             .map<Widget>(
                      //                                                 (var product) {
                      //                                           return CustomGridItem(
                      //                                             title:
                      //                                                 '${product['ProdName1']}',
                      //                                             imageUrl:
                      //                                                 product[
                      //                                                     'ProdName3'],
                      //                                             isCompleted: switch5 ==
                      //                                                     product['ProdName1']
                      //                                                 ? true
                      //                                                 : false,
                      //                                             onTap:
                      //                                                 () async {
                      //                                               deliveryId =
                      //                                                   deliveryIdList[
                      //                                                       5];
                      //                                               //checking the tick icon
                      //                                               if (switch5 !=
                      //                                                   product[
                      //                                                       'ProdName1']) {
                      //                                                 snap.data
                      //                                                     .forEach((value) {
                      //                                                   if (value['switch5'] ==
                      //                                                       '10009') {
                      //                                                     checkMealCount(
                      //                                                         product,
                      //                                                         true,
                      //                                                         am);
                      //                                                   } else {
                      //                                                     Toast.show('Exceeded Allowed Meal',
                      //                                                         context);
                      //                                                   }
                      //                                                 });
                      //                                               } else {
                      //                                                 checkMealCount(
                      //                                                     product,
                      //                                                     false,
                      //                                                     am);
                      //                                               }
                      //                                               setState(
                      //                                                   () {});
                      //
                      //                                               // checkFunction(, snap, value, allowedM)
                      //                                             },
                      //                                           );
                      //                                         }).toList(),
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                             );
                      //                           }
                      //                         });
                      //                   } else {
                      //                     return Text(
                      //                       'Network Error',
                      //                       style:
                      //                           BeHealthyTheme.kMainTextStyle,
                      //                     );
                      //                   }
                      //                 }
                      //               },
                      //             )
                      //           : Text(''),
                      //     ],
                      //   )
                      : Center(
                          child: Container(
                            height: medq.height * 0.4,
                            width: medq.width * 0.7,
                            child: Center(
                              child: Text(
                                'Please Select A Date To Continue',
                                textAlign: TextAlign.center,
                                style: BeHealthyTheme.kMainTextStyle.copyWith(
                                    color: BeHealthyTheme.kMainOrange,
                                    fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void displayBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/images/Group 99.png',
                        width: 30,
                        height: 30,
                        color: BeHealthyTheme.kMainOrange,
                      )),
                  GestureDetector(
                    onTap: () {
                      // _query();
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CartCheckout()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
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
                              'Continue ',
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
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width - 300,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: BeHealthyTheme.kLightOrange,
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'Spicy',
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                            fontSize: 13, color: BeHealthyTheme.kMainOrange),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width - 300,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'Non-Spicy',
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                            fontSize: 13, color: BeHealthyTheme.kMainOrange),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width - 300,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: BeHealthyTheme.kLightOrange,
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'Salt',
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                            fontSize: 13, color: BeHealthyTheme.kMainOrange),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width - 300,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'No Salt',
                        style: BeHealthyTheme.kMainTextStyle.copyWith(
                            fontSize: 13, color: BeHealthyTheme.kMainOrange),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Cooking Directions',
                  style: BeHealthyTheme.kMainTextStyle
                      .copyWith(fontSize: 18, color: Color(0xff707070)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 150,
                  child: TextFormField(
                    maxLines: 5,
                    cursorColor: BeHealthyTheme.kMainOrange,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                            width: 1,
                          )),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                            width: 1, color: BeHealthyTheme.kMainOrange),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                            width: 2, color: BeHealthyTheme.kMainOrange),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class Item {
  Item({
    @required this.title,
    this.isSelected = false,
  });

  String title;
  bool isSelected;
}

List<Item> generateItems(List list) {
  return List<Item>.generate(list.length, (int index) {
    return Item(
      title: '${list[index]['ProdName1']}',
    );
  });
}

class CustomGridItem extends StatefulWidget {
  final String title;
  final String desc;
  final Function onTap;
  final bool isCompleted;
  final String imageUrl;
  final int index;
  final List<Data> dataList;

  CustomGridItem({
    this.title, this.desc, this.onTap, this.isCompleted = false, this.index, this.dataList, this.imageUrl
  });

  @override
  _CustomGridItemState createState() => _CustomGridItemState();
}

class _CustomGridItemState extends State<CustomGridItem> {
  bool mealsCompleted;

  @override
  void initState() {
    setState(() {
      mealsCompleted = widget.isCompleted;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
            color: mealsCompleted ? Color(0x2B88CB67) : BeHealthyTheme.kMainOrange.withOpacity(0.20),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: Image(
                    height: MediaQuery.of(context).size.height * 0.11,
                    width: MediaQuery.of(context).size.width * 0.5,
                    fit: BoxFit.cover,
                    image: widget.imageUrl != null ? NetworkImage(widget.imageUrl) : AssetImage('assets/images/haha2.png'),
                  ),
                ),
                SizedBox(height: 3,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Center(
                    child: Text(
                      widget.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: BeHealthyTheme.kMainTextStyle.copyWith(
                          fontSize: 13,
                          color: mealsCompleted ? Color(0xff88CB67) : BeHealthyTheme.kMainOrange),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onTap();
                    setState(() {
                      mealsCompleted = widget.dataList[widget.index].isSelected;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(70), bottomRight: Radius.circular(20)),
                        color: mealsCompleted ? Color(0x4588CB67) : BeHealthyTheme.kMainOrange.withOpacity(0.27)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Icon(
                        mealsCompleted ? Icons.done : Icons.add,
                        size: 30,
                        color: mealsCompleted ? Color(0xff88CB67) : BeHealthyTheme.kMainOrange,
                      ),
                    ),
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
class MealPlan {
  List<Data> items = List();
}
class DayPlan {
  String nameStr = "";
  PlanDates planDate;
  List<MealPlan> meals = List();
}
class WeekPlan {
  String weekName = '';
  List<DayPlan> days = List(6);
}
class PlanDates {
  String dateStr = '';
  String dateForAPIStr = '';
  var date = DateTime.now();
  var weekday = 0;
  bool isSelected = false;
  String dayNameOfWeek = "";
  String dayTitle = "";

  PlanDates(DateTime date, bool isSelected) {
    this.date = date;
    this.isSelected = isSelected;
    DateFormat formatter = DateFormat('MMM d E', "en_US");
    dateStr = formatter.format(date);
    formatter = DateFormat('MM/dd/yyyy', "en_US");
    dateForAPIStr = formatter.format(date);
    formatter = DateFormat('EEE', "en_US");
    dayNameOfWeek = formatter.format(date);
    formatter = DateFormat('dd MMM', "en_US");
    dayTitle = formatter.format(date);
    weekday = date.weekday;
  }
}
class WholePlan {
 // List<CustomerContractDetailsModel> customerContractDetailsModel;
  //List<MealsOfDayModel> flexibleMeals = List();
  List<WeekPlan> weeks = List();
  List<Data> itemsToDelete = List();
}


