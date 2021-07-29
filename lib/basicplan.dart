import 'dart:convert';
import 'package:behealthy/package_details.dart';
import 'package:behealthy/utils.dart';
import 'package:behealthy/utils/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:behealthy/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'database/dbhelper.dart';
import 'database/table_fields.dart';

class BasicPlan extends StatefulWidget {

  @override
  _BasicPlanState createState() => _BasicPlanState();
}

class _BasicPlanState extends State<BasicPlan> {


  bool value = false;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  bool showCalendar = false;
  int myTransId;
  final dbHelper = DatabaseHelper.instance;
  int totalMealAllowed = 0;
  List mealPlan = [];

  getInstances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      return prefs;
    } else {
      return null;
    }
  }
  var planDays = 0;
  _selectDate(BuildContext context) async {
    final row = await dbHelper.querySubscriptionSetup();
    int holidayNumber;
    switch (row['Week_Holiday']) {
      case "Monday":{
          setState(() {
            holidayNumber = 1;
          });
        }
        break;
      case "Tuesday":{
          setState(() {
            holidayNumber = 2;
          });
        }
        break;
      case "Wednesday":{
          setState(() {
            holidayNumber = 3;
          });
        }
        break;
      case "Thursday":{
          setState(() {
            holidayNumber = 4;
          });
        }
        break;
      case "Friday":{
          setState(() {
            holidayNumber = 5;
          });
        }
        break;
      case "Saturday":{
          setState(() {
            holidayNumber = 6;
          });
        }
        break;
      case "Sunday":{
          setState(() {
            holidayNumber = 7;
          });
        }
        break;
    }

    final DateTime picked = await showDatePicker(
      selectableDayPredicate: (dateTime) =>
          dateTime.weekday == holidayNumber ? false : true,
      context: context,
      initialDate: _focusedDay.weekday == holidayNumber
          ? _focusedDay.add(Duration(days: 1))
          : _focusedDay, // Refer step 1
      firstDate: kFirstDay,
      lastDate: kLastDay,
    );
    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = picked;
      });
    }
  }
  generateCustomerContract() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime requiredDate = _selectedDay != null ? _selectedDay : _focusedDay;
    DateTime beginDate = requiredDate.add(const Duration(days: 2));

    var planId = prefs.get('id');
    var tenentID = TenentID.toString();
    var custID = prefs.get('custID');
    var contractDate = '${requiredDate.month}/${requiredDate.day}/${requiredDate.year}';
    var beginDateStr  = '${beginDate.month}/${beginDate.day}/${beginDate.year}';

    http.Response response = await http.post(Uri.parse('https://foodapi.pos53.com/api/Food/GenerateCustomerContract'),
        body: {'PlanId': '$planId', 'TenentID': tenentID.toString(), 'CustomerId': '$custID', 'ContractDate':'$contractDate',
          'BeginDate': beginDateStr, 'AllowWeekend': '$value'});
    var json = jsonDecode(response.body);
    if (json['status'] == 200) {
      return jsonDecode(response.body);
    } else if (jsonDecode(response.body)['status'] == 400) {
      return jsonDecode(response.body);
    } else {
     return jsonDecode(response.body);
    }
  }

  _insert(var dataForSql) async {

    //var planDays = 26;

    Map<String, dynamic> row = {
      DatabaseHelper.columntenentId: dataForSql['TenentID'],
      DatabaseHelper.columnmytransid: myTransId,
      DatabaseHelper.columnlocationId: dataForSql['LOCATION_ID'],
      DatabaseHelper.columncustomerId: dataForSql['CustomerID'],
      DatabaseHelper.columnplanid: dataForSql['planid'],
      DatabaseHelper.columndayNumber: "$planDays",
      DatabaseHelper.columntransId: dataForSql['TransID'],
      DatabaseHelper.columncontractId: dataForSql['ContractID'],
      DatabaseHelper.columndefaultDriverId: dataForSql['DefaultDriverID'],
      DatabaseHelper.columncontractDate: dataForSql['ContractDate'],
      DatabaseHelper.columnweekofDay: dataForSql['WeekofDay'],
      DatabaseHelper.columnstartDate: dataForSql['StartDate'],
      DatabaseHelper.columnendDate: dataForSql['EndDate'],
      DatabaseHelper.columntotalSubDays: dataForSql['TotalSubDays'],
      DatabaseHelper.columndeliveredDays: 0,
      DatabaseHelper.columnnExtDeliveryDate: dataForSql['NExtDeliveryDate'],
      DatabaseHelper.columnnExtDeliveryNum: dataForSql['NExtDeliveryNum'],
      DatabaseHelper.columnweek1TotalCount: dataForSql['Week1TotalCount'],
      DatabaseHelper.columnweek1Count: dataForSql['Week1Count'],
      DatabaseHelper.columnweek2Count: dataForSql['Week2Count'],
      DatabaseHelper.columnweek2TotalCount: dataForSql['Week2TotalCount'],
      DatabaseHelper.columnweek3Count: dataForSql['Week3Count'],
      DatabaseHelper.columnweek3TotalCount: dataForSql['Week3TotalCount'],
      DatabaseHelper.columnweek4Count: dataForSql['Week4Count'],
      DatabaseHelper.columnweek4TotalCount: dataForSql['Week4TotalCount'],
      DatabaseHelper.columnweek5Count: dataForSql['Week5Count'],
      DatabaseHelper.columnweek5TotalCount: dataForSql['Week5TotalCount'],
      DatabaseHelper.columncontractTotalCount: dataForSql['ContractTotalCount'],
      DatabaseHelper.columncontractSelectedCount:
          dataForSql['ContractSelectedCount'],
      DatabaseHelper.columnisFullPlanCopied: dataForSql['IsFullPlanCopied'],
      DatabaseHelper.columnsubscriptionOnHold: dataForSql['SubscriptionOnHold'],
      DatabaseHelper.columnholdDate: dataForSql['HoldDate'],
      DatabaseHelper.columnunHoldDate: dataForSql['UnHoldDate'],
      DatabaseHelper.columnholdbyuser: dataForSql['Holdbyuser'],
      DatabaseHelper.columnholdREmark: dataForSql['HoldREmark'],
      DatabaseHelper.columnsubscriptonDayNumber:
          dataForSql['SubscriptonDayNumber'],
      DatabaseHelper.columntotalPrice: dataForSql['Total_price'],
      DatabaseHelper.columnshortRemark: dataForSql['ShortRemark'],
      DatabaseHelper.columnactive: dataForSql['ACTIVE'],
      DatabaseHelper.columncrupId: dataForSql['CRUP_ID'],
      DatabaseHelper.columnchangesDate: dataForSql['ChangesDate'],
      DatabaseHelper.columndriverId: dataForSql['DriverID'],
      DatabaseHelper.columncStatus: dataForSql['CStatus'],
      DatabaseHelper.columnuploadDate: dataForSql['UploadDate'],
      DatabaseHelper.columnuploadby: dataForSql['Uploadby'],
      DatabaseHelper.columnsyncDate: dataForSql['SyncDate'],
      DatabaseHelper.columnsyncby: dataForSql['Syncby'],
      DatabaseHelper.columnsynId: dataForSql['SynID'],
      DatabaseHelper.columnpaymentStatus: dataForSql['PaymentStatus'],
      DatabaseHelper.columnsyncStatus: dataForSql['syncStatus'],
      DatabaseHelper.columnlocalId: dataForSql['LocalID'],
      DatabaseHelper.columnofflineStatus: dataForSql['OfflineStatus'],
      DatabaseHelper.columnallergies: dataForSql['Allergies'],
      DatabaseHelper.columncarbs: dataForSql['Carbs'],
      DatabaseHelper.columnprotein: dataForSql['Protein'],
      DatabaseHelper.columnremarks: dataForSql['Remarks'],
    };
    final id = await dbHelper.insertToplanMealCustInvoiceHD(row);
    print('Inserted row id: $id');
    dataForSql['MYTRANSID'] = myTransId;
    var prams = {
      "\$id": '2',
    "TenentID": '${dataForSql['TenentID']}',
    "MYTRANSID": '$myTransId',
    "LOCATION_ID": '${dataForSql['LOCATION_ID']}',
    "CustomerID": '${dataForSql['CustomerID']}',
    "planid": '${dataForSql['planid']}',
    "DayNumber": "$planDays",//dataForSql['TotalSubDays'] != null ? '${dataForSql['TotalSubDays']}' : '26',
    "TransID": '$myTransId',
    "ContractID": '$myTransId',
    "DefaultDriverID": '${dataForSql['DefaultDriverID']}',
    "ContractDate": '${dataForSql['ContractDate']}',
    "WeekofDay": '${dataForSql['WeekofDay']}',
    "StartDate": '${dataForSql['StartDate']}',
    "EndDate": '${dataForSql['EndDate']}',
    "TotalSubDays": "$planDays",
    "DeliveredDays": '0',
    "NExtDeliveryDate": '${dataForSql['NExtDeliveryDate']}',
    "NExtDeliveryNum": '${dataForSql['NExtDeliveryNum']}',
    "Week1TotalCount": '${dataForSql['Week1TotalCount']}',
    "Week1Count": '${dataForSql['Week1Count']}',
    "Week2Count": '${dataForSql['Week2Count']}',
    "Week2TotalCount": '${dataForSql['Week2TotalCount']}',
    "Week3Count": '${dataForSql['Week3Count']}',
    "Week3TotalCount": '${dataForSql['Week3TotalCount']}',
    "Week4Count": '${dataForSql['Week4Count']}',
    "Week4TotalCount": '${dataForSql['Week4TotalCount']}',
    "Week5Count": '${dataForSql['Week5Count']}',
    "Week5TotalCount": '${dataForSql['Week5TotalCount']}',
    "ContractTotalCount": '${dataForSql['ContractTotalCount']}',
    "ContractSelectedCount": '${dataForSql['ContractSelectedCount']}',
    "IsFullPlanCopied": '${dataForSql['IsFullPlanCopied']}',
    "SubscriptionOnHold": '${dataForSql['SubscriptionOnHold']}',
    "HoldDate": '${dataForSql['HoldDate']}',
    "UnHoldDate": '${dataForSql['UnHoldDate']}',
    "Holdbyuser": '${dataForSql['Holdbyuser']}',
    "HoldREmark": '${dataForSql['HoldREmark']}',
    "SubscriptonDayNumber": '${dataForSql['SubscriptonDayNumber']}',
    "Total_price": '${dataForSql['Total_price']}',
    "ShortRemark": '${dataForSql['ShortRemark']}',
    "ACTIVE": '${dataForSql['ACTIVE']}',
    "CRUP_ID": '${dataForSql['CRUP_ID']}',
    "ChangesDate": '${dataForSql['ChangesDate']}',
    "DriverID": '${dataForSql['DriverID']}',
    "CStatus": '${dataForSql['CStatus']}',
    "UploadDate": '${dataForSql['UploadDate']}',
    "Uploadby": '${dataForSql['Uploadby']}',
    "SyncDate": '${dataForSql['SyncDate']}',
    "Syncby": '${dataForSql['Syncby']}',
    "SynID": '${dataForSql['SynID']}',
    "PaymentStatus": '${dataForSql['PaymentStatus']}',
    "syncStatus": '${dataForSql['syncStatus']}',
    "LocalID": '${dataForSql['LocalID']}',
    "OfflineStatus": '${dataForSql['OfflineStatus']}',
    "Allergies": '${dataForSql['Allergies']}',
    "Carbs": '${dataForSql['Carbs']}',
    "Protein": '${dataForSql['Protein']}',
    "Remarks": ""
    };
    print(prams);
    try {
      http.Response res = await http.post(Uri.parse('https://foodapi.pos53.com/api/Food/PlanmealcustinvoiceHD_Save'), body: prams);
      print("123 $res");
      // print({"\$id": '2', "TenentID": '${dataForSql['TenentID']}', "MYTRANSID": '$myTransId', "LOCATION_ID": '${dataForSql['LOCATION_ID']}',
      //   "CustomerID": '${dataForSql['CustomerID']}',
      //   "planid": '${dataForSql['planid']}',
      //   "DayNumber": '${dataForSql['DayNumber']}',
      //   "TransID": '$myTransId',
      //   "ContractID": '$myTransId',
      //   "DefaultDriverID": '${dataForSql['DefaultDriverID']}',
      //   "ContractDate": '${dataForSql['ContractDate']}',
      //   "WeekofDay": '${dataForSql['WeekofDay']}',
      //   "StartDate": '${dataForSql['StartDate']}',
      //   "EndDate": '${dataForSql['EndDate']}',
      //   "TotalSubDays": '${dataForSql['TotalSubDays']}',
      //   "DeliveredDays": '0',
      //   "NExtDeliveryDate": '${dataForSql['NExtDeliveryDate']}',
      //   "NExtDeliveryNum": '${dataForSql['NExtDeliveryNum']}',
      //   "Week1TotalCount": '${dataForSql['Week1TotalCount']}',
      //   "Week1Count": '${dataForSql['Week1Count']}',
      //   "Week2Count": '${dataForSql['Week2Count']}',
      //   "Week2TotalCount": '${dataForSql['Week2TotalCount']}',
      //   "Week3Count": '${dataForSql['Week3Count']}',
      //   "Week3TotalCount": '${dataForSql['Week3TotalCount']}',
      //   "Week4Count": '${dataForSql['Week4Count']}',
      //   "Week4TotalCount": '${dataForSql['Week4TotalCount']}',
      //   "Week5Count": '${dataForSql['Week5Count']}',
      //   "Week5TotalCount": '${dataForSql['Week5TotalCount']}',
      //   "ContractTotalCount": '${dataForSql['ContractTotalCount']}',
      //   "ContractSelectedCount": '${dataForSql['ContractSelectedCount']}',
      //   "IsFullPlanCopied": '${dataForSql['IsFullPlanCopied']}',
      //   "SubscriptionOnHold": '${dataForSql['SubscriptionOnHold']}',
      //   "HoldDate": '${dataForSql['HoldDate']}',
      //   "UnHoldDate": '${dataForSql['UnHoldDate']}',
      //   "Holdbyuser": '${dataForSql['Holdbyuser']}',
      //   "HoldREmark": '${dataForSql['HoldREmark']}',
      //   "SubscriptonDayNumber": '${dataForSql['SubscriptonDayNumber']}',
      //   "Total_price": '${dataForSql['Total_price']}',
      //   "ShortRemark": '${dataForSql['ShortRemark']}',
      //   "ACTIVE": '${dataForSql['ACTIVE']}',
      //   "CRUP_ID": '${dataForSql['CRUP_ID']}',
      //   "ChangesDate": '${dataForSql['ChangesDate']}',
      //   "DriverID": '${dataForSql['DriverID']}',
      //   "CStatus": '${dataForSql['CStatus']}',
      //   "UploadDate": '${dataForSql['UploadDate']}',
      //   "Uploadby": '${dataForSql['Uploadby']}',
      //   "SyncDate": '${dataForSql['SyncDate']}',
      //   "Syncby": '${dataForSql['Syncby']}',
      //   "SynID": '${dataForSql['SynID']}',
      //   "PaymentStatus": '${dataForSql['PaymentStatus']}',
      //   "syncStatus": '${dataForSql['syncStatus']}',
      //   "LocalID": '${dataForSql['LocalID']}',
      //   "OfflineStatus": '${dataForSql['OfflineStatus']}',
      //   "Allergies": '${dataForSql['Allergies']}',
      //   "Carbs": '${dataForSql['Carbs']}',
      //   "Protein": '${dataForSql['Protein']}',
      //   "Remarks": '${dataForSql['Remarks']}'
      // });
      //print('Hd Save: ${res.body}');

      // if (jsonDecode(res.body)['status'] == 200) {
      //   Toast.show( "PlanmealcustinvoiceHD_Save Api call message " +jsonDecode(res.body)['message'], context, duration: 3);
      // } else{
      //   Toast.show("error in api status code" + jsonDecode(res.body)['status'] + " message " + jsonDecode(res.body)['message'], context, duration: 3);
      // }
    } catch (e) {
      Toast.show("Error in the API response ${e.toString()}", context, duration: 3);
    }
  }
  _insertMoreHd() async {

    int i = 1;
    dbHelper.deleteAllFromMoreHD();
    mealPlan.forEach((element) async {
      Map<String, dynamic> newRow = {
        TableFields.tenentid: element['TenentID'],
        TableFields.mytransid: myTransId,
        TableFields.mealtype: element['MealType'],
        TableFields.planid: element['planid'],
        TableFields.customized: element['MealFixFlexible'],
        TableFields.totalmealallowed: element['TotalAllowed'],
        TableFields.planingram: element['PlanInGram'],
        TableFields.mealfixflexible: element['MealFixFlexible'],
        TableFields.uom: element['UOM'],
        TableFields.mealingram: element['MealInGram'],
        TableFields.planbasecost: element['PlanBasecost'],
        TableFields.itembasecost: element['ItemBasecost'],
        TableFields.basemeal: mealTypesAndQuantities[mealPlan.indexOf(element)].quantity,//element['MealAllowed'],
        TableFields.extrameal: null,
        TableFields.extramealcost: element['ItemExtraCost'],
        TableFields.amt: element['PlanBasecost'],
        TableFields.uploaddate: element['UploadDate'],
        TableFields.uploadby: element['Uploadby'],
        TableFields.syncdate: element['SyncDate'],
        TableFields.syncby: 'Flutter',
        TableFields.synid: element['SynID'],
        TableFields.totalamount: element['PlanBasecost'],
        TableFields.paidamount: null,
        TableFields.alloweekend: value,
        TableFields.updatedate:'${_focusedDay.month}/${_focusedDay.day}/${_focusedDay.year}'
      };
      try {
        final id = await dbHelper.insertInToMoreHD(newRow);
        print('inserted row in more hd id: $id');
      } catch (e) {
        Toast.show(e.toString(), context, duration: 5);
      }
      var body = {
        "\$id": "${i++}",
        "TenentID": '${element['TenentID']}',
        "MYTRANSID": '$myTransId',
        "MealType": '${element['MealType']}',
        "PlanId": '${element['planid']}',
        "Customized": "No",
        "MealFixFlexible": '${element['MealFixFlexible']}',
        "UOM": '${element['UOM']}',
        "TotalMealAllowed": '$totalMealAllowed',
        //need to change this meal allowed to the actual as used above
        "WeekMealAllowed": '$totalMealAllowed',
        "PlanInGram": '${element['PlanInGram']}',
        "plandays": '$planDays',
        "MealInGram": '${element['MealInGram']}',
        "PlanBasecost": '${element['PlanBasecost']}',
        "ItemBasecost": '${element['ItemBasecost']}',
        "BaseMeal": '${element['MealAllowed']}',
        "ExtraMeal": "null",
        "ExtraMealCost": "${element['ItemExtraCost']}",
        "Amt": '${element['PlanBasecost']}',
        "UploadDate": '${element['UploadDate']}',
        "Uploadby": '${element['Uploadby']}',
        "SyncDate": '${element['SyncDate']}',
        "Syncby": "Flutter",
        "SynID": '${element['SynID']}',
        "TotalAmount": '${element['PlanBasecost']}',
        "PaidAmount": "null",
        "AlloWeekend": '$value',
        "UpdateDate": '${_focusedDay.month}/${_focusedDay.day}/${_focusedDay.year}'
      };
      http.Response res = await http.post(Uri.parse('https://foodapi.pos53.com/api/Food/PlanmealcustinvoiceMoreHD_Save'),
          body: body);
      print('More Hd Save $i :${res.body}');
     //  if (res.statusCode == 200){
     //    Toast.show("Plan meal customer invoice More HD Save Api call message " + jsonDecode(res.body)['message'], context, duration: 5);
     //  }else{
     //    Toast.show("error in api status code" + jsonDecode(res.body)['status'] + " message " + jsonDecode(res.body)['message'], context, duration: 5);
     //  }
    });
  }
  getNextMyTransId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Toast.show("Calling GetNextMyTransId", context, duration: 5);
    http.Response respo = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Food/GetNextMyTransId'),
        body: {'TenantID': '14'});
    if (jsonDecode(respo.body)['status'] == 200) {
      print(jsonDecode(respo.body)['data'][0]['MYTRANSID']);
      prefs.setInt('myTransId', jsonDecode(respo.body)['data'][0]['MYTRANSID']);
      myTransId = jsonDecode(respo.body)['data'][0]['MYTRANSID'];
    } else {
      Toast.show("error in api status code" + jsonDecode(respo.body)['status'] + " message " + jsonDecode(respo.body)['message'], context, duration: 5);
    }
  }
  getpackageWithPlanId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.get('PlanID');
    http.Response response = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Food/GetpackageMeal'),
        body: {'TenentID': '$TenentID', 'PlanId': '${id.toString()}'});
    if (jsonDecode(response.body)['status'] == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
  List<String> mealNames = List();
  planMealCustomerInvoiceMoreHd() async {

    var prefs = await getInstances();
    var planId = prefs.get('id');
    var rowsFuture = dbHelper.selectPlanMealWithPlaId(planId);
    rowsFuture.then((dataList) async {
      if(dataList[0]["CustomAllow"] == "1"){

        mealTypesAndQuantities.forEach((data){
          var mealNameFuture = dbHelper.getMealName(data.mealType);
          mealNameFuture.then((item) {
            mealNames.add(item[0]["REFNAME1"]);
          });
        });

        mealTypesAndQuantities.forEach((mealTypeQuantity){
          dataList.forEach((data){
            if (data['planid'] == planId && mealTypeQuantity.mealType == data["MealType"]) {
            //  data["MealAllowed"] = mealTypeQuantity.quantity;
              mealPlan.add(data);
            }
          });
        });

        mealPlan.forEach((element) {
          totalMealAllowed += element['MealAllowed'];
        });
      }else{
        dataList.forEach((data){
          var mealNameFuture = dbHelper.getMealName(data["MealType"]);
          mealNameFuture.then((item) {
            mealNames.add(item[0]["REFNAME1"]);
          });

          if (data['planid'] == planId) {
            mealPlan.add(data);
          }
        });
        mealPlan.forEach((element) {
          totalMealAllowed += element['MealAllowed'];
        });
      }

    });
  }
  Future<List> getMealsOfAPlan() async {
    var textData = await DefaultAssetBundle.of(context)
        .loadString("assets/json/newplan2.json");
    var preference = await SharedPreferences.getInstance();
    var custId = preference.get('id');
    var json = jsonDecode(textData)['NEwPlanMeal'] as List;
    var filtered = json.where((element) => element['planid'] == custId.toString()).toList().first['switch3'].split(',').toList()
        .where((element) => element != '').map((String element) => element.trim()).toList();

    return filtered;
  }

  @override
  Future<void> initState()  {
    // TODO: implement initState
    super.initState();
    getNextMyTransId();
    planMealCustomerInvoiceMoreHd();
    setPlaDays();
  }
  setPlaDays() async {
    var preferences = await SharedPreferences.getInstance();
    planDays = preferences.getInt('planDays');
  }

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async => true,
          child: Column(
            // alignment: AlignmentDirectional.topCenter,
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Image(
                    image: AssetImage('assets/images/semi-circle.png'),
                  ),
                  Positioned(
                    top: medq.height / 20,
                    left: 0,
                    child: FutureBuilder(
                        future: getInstances(),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            var planTitle = snap.data.get('planTitle');
                            //var arabicName = snap.data.get('arabicName');
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                Container(
                                  width: medq.width * 0.6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        planTitle.toString(),
                                        style: BeHealthyTheme.kMainTextStyle
                                            .copyWith(
                                                fontSize: 19,
                                                color: Colors.white),
                                      ),
                                      Text(
                                        "Menu",
                                        style: BeHealthyTheme.kMainTextStyle
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Text('ERROR');
                          }
                        }),
                  ),
                ],
              ),
              // Positioned(
              //   top: -medq.height * 0.53,
              //   child: Image(
              //     image: AssetImage('assets/images/Path 29.png'),
              //   ),
              // ),
              // Positioned(
              //   top: medq.height / 25,
              //   left: 0,
              // child: IconButton(
              //     icon: Icon(
              //       Icons.arrow_back_ios,
              //       color: Colors.white,
              //       size: 25,
              //     ),
              //     onPressed: () {
              //       // Navigator.pop(context);
              //     }),
              // ),
              SingleChildScrollView(
                child: FutureBuilder(
                    future: generateCustomerContract(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: EdgeInsets.only(top: medq.height * 0.3),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        if (snapshot.data['status'] == 200) {
                          return Container(
                            height: medq.height * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        border: Border.all(
                                            color: BeHealthyTheme.kMainOrange),
                                        color: Colors.white),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Row(
                                            children: [
                                              Image.asset('assets/images/calendar (2).png', width: 30, height: 30,),
                                              SizedBox(width: 10,),
                                              Text('Begin Date', style: BeHealthyTheme.kProfileFont.copyWith(fontSize: 14, fontWeight: FontWeight.w600,),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: Text('${snapshot.data['data']['StartDate']}',style: BeHealthyTheme.kProfileFont.copyWith(fontSize: 13,
                                              fontWeight: FontWeight.w700, color: BeHealthyTheme.kMainOrange),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                FutureBuilder(
                                    future: dbHelper.querySubscriptionSetup(),
                                    builder: (context, snap) {
                                      if (snap.connectionState ==
                                          ConnectionState.done) {
                                        return Text('Delivery starts ${snap.data['Delivery_in_day']} days after the selected Date', style: BeHealthyTheme.kDhaaTextStyle,);
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    }),
                                //non editable field
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.8, height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      border: Border.all(color: BeHealthyTheme.kMainOrange), color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/images/calendar (2).png', width: 30, height: 30,),
                                            SizedBox(width: 10,),
                                            Text('End Date', style: BeHealthyTheme.kProfileFont.copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                      Padding(padding: const EdgeInsets.only(right: 15.0),
                                        child: Text('${snapshot.data['data']['EndDate']}', style: BeHealthyTheme.kProfileFont.copyWith(fontSize: 13,
                                            fontWeight: FontWeight.w700, color: BeHealthyTheme.kMainOrange),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CupertinoSwitch(
                                        activeColor: BeHealthyTheme.kMainOrange,
                                        value: this.value,
                                        onChanged: (value) {
                                          setState(() {
                                            this.value = value;
                                          });
                                        }),
                                    SizedBox(width: 5,), //SizedBox
                                    Text('Deliver me on Holidays', style: BeHealthyTheme.kProfileFont.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 3),
                                          color: Colors.black12,
                                          blurRadius: 12,
                                        )
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('${snapshot.data['data']['TotalWeek']}', style: BeHealthyTheme.kMainTextStyle.copyWith(color:
                                            BeHealthyTheme.kMainOrange, fontSize: 30)),
                                            SizedBox(height: 7,),
                                            Text('Weeks', style: BeHealthyTheme.kDhaaTextStyle.copyWith(color: Colors.black87, fontSize: 20)),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('$planDays', style: BeHealthyTheme.kMainTextStyle.copyWith(color: BeHealthyTheme.kMainOrange, fontSize: 30)),
                                            SizedBox(height: 7,),
                                            Text('Days', style: BeHealthyTheme.kDhaaTextStyle.copyWith(color: Colors.black87, fontSize: 20)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                FutureBuilder(
                                  future: getMealsOfAPlan(),
                                  builder: (context, snap) {
                                    if (snap.data != null) {
                                      var data = snap.data;
                                      return Container(
                                        height: 111,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                            color: BeHealthyTheme.kLightOrange),
                                        margin: EdgeInsets.all(15),
                                        padding: EdgeInsets.all(15),
                                        child:  ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: mealNames != null ? mealNames.length:0 ,
                                          itemBuilder: (context, index) {
                                            String item = "";
                                            mealNames != null ? item = mealNames[index]:item = "";
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image(image: AssetImage('assets/images/$item.png'),),
                                                Text('$item', style: BeHealthyTheme.kAddressStyle.copyWith(fontSize: 15, fontWeight:
                                                FontWeight.bold, color: BeHealthyTheme.kMainOrange)),
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    showDialog(barrierDismissible: false, context: context, builder: (context) {
                                          Future.delayed(Duration(seconds: 5), () {
                                            try {
                                              _insert(snapshot.data['data']['planmealinvoiceHD']);
                                              _insertMoreHd().then((value) {
                                               // mealPlan.clear();
                                              });
                                            } catch (e) {
                                              Toast.show("Your Plan is Already Active", context, duration: 5);
                                            }
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PackageDetails(genratedContract: snapshot.data,
                                              transId: myTransId,)));
                                          });
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: BeHealthyTheme.kMainOrange,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Text('Confirm', style: BeHealthyTheme.kMainTextStyle.copyWith(fontSize: 18, color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.data['status'] == 400) {
                          return Container(
                            alignment: Alignment.center,
                            height: medq.height * 0.6,
                            width: medq.width * 0.6,
                            child: Center(
                              child: Text('${snapshot.data['message']}', textAlign: TextAlign.center, style: BeHealthyTheme.kMainTextStyle,),
                            ),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            height: medq.height * 0.65,
                            child: Center(
                              child: Text('${snapshot.data['message']}'),
                            ),
                          );
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  final int am1;
  final int am2;
  final int am3;
  final int am4;
  final int am5;
  const BottomContainer({
    this.am1,
    this.am2,
    this.am3,
    this.am4,
    this.am5,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              color: Colors.black12,
              blurRadius: 12,
            )
          ],
          color: BeHealthyTheme.kLightOrange),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/Breakfast.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  '$am1',
                  style: BeHealthyTheme.kProfileFont.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BeHealthyTheme.kMainOrange),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/Lunch.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  '$am2',
                  style: BeHealthyTheme.kProfileFont.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BeHealthyTheme.kMainOrange),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/Dinner.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  '$am3',
                  style: BeHealthyTheme.kProfileFont.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BeHealthyTheme.kMainOrange),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/Snack.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  '$am4',
                  style: BeHealthyTheme.kProfileFont.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BeHealthyTheme.kMainOrange),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/Salad.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  '$am5',
                  style: BeHealthyTheme.kProfileFont.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BeHealthyTheme.kMainOrange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
