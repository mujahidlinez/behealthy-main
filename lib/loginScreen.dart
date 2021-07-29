
import 'dart:convert';
import 'package:behealthy/basicplan.dart';
import 'package:behealthy/constants.dart';
import 'package:behealthy/homePage.dart';
import 'package:behealthy/signup.dart';
import 'package:behealthy/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'database/dbhelper.dart';
import 'database/table_fields.dart';
import 'models/sync_one_way2.dart';
import 'models/sync_one_way4.dart';
import 'package:get/get.dart' hide Response;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  final DatabaseHelper dataBaseHelperInstance = DatabaseHelper.instance;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    username.dispose();
    password.dispose();
  }

  Future<void> insertSynchronizationDataInDB(custID) async {
    Map requestBody = {
      'TenentID': TenentID.toString(),
      'CustomerID': custID.toString()
    };
    print('in insertSynchronizationDataInDB');
    var response = await http.post(
        Uri.parse(
            'https://foodapi.pos53.com/api/Food/SynchronizationProcess_GetData'),
        body: requestBody);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var invoiceHD = responseBody['data']['lstPlanmealcustinvoiceHD'];
      if (invoiceHD != null) await insertIntoPlanMealInvoiceHDDB(invoiceHD);
      var invoice = responseBody['data']['lstPlanmealcustinvoice'];
      if (invoice != null) await insertIntoPlanMealInvoiceDB(invoice);
      var invoiceMoreHD = responseBody['data']['lstPlanmealcustinvoiceMoreHD'];
      if (invoiceMoreHD != null) await insertIntoPlanMealInvoiceMoreHDDB(invoiceMoreHD);
      var planMeal = responseBody['data']['lstPlanMeal'];
      if (planMeal != null) await insertIntoPlanMeal(planMeal);

    } else {
      print('ERROR');
    }
  }
  Future<void> getSyncOneWay4(cUserId) async {
     Map requestBody = {
       'TenentID': TenentID.toString(),
       'CustomerID': cUserId.toString()
     };
     var response = await http.post(
         Uri.parse('https://foodapi.pos53.com/api/Synchronization/SynchOneWay4_GetData'),
         body: requestBody);
     if (response.statusCode == 200) {
       var responseBody = jsonDecode(response.body);
       var sync1Response = SyncOneWay4Response.fromJson(responseBody);
       final syncOneWay4 = sync1Response.synchOneWay4Model.lstplanmeal;
       dataBaseHelperInstance.insertToSyncOneWay4(syncOneWay4);

     } else {
       print('ERROR');
     }
  }
  Future<void> getSyncOneWay2(cUserId) async {
    Map requestBody = {
      'TenentID': TenentID.toString(),
      'CustomerID': cUserId.toString()
    };
    var response = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Synchronization/SynchOneWay2_GetData'),
        body: requestBody);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var sync2Response = SyncOneWay2Response.fromJson(responseBody);
      List <LstRefTable> refTable = sync2Response.syncOneWay2Model.lstRefTable;
      insertIntoRefTable(refTable);
    } else {
      print('ERROR');
    }
  }

  Future<void> insertIntoPlanMealInvoiceDB(List allData) async {
    allData.forEach((element) async {
      Map<String, dynamic> newRow = {
        TableFields.tenentId: element['TenentID'],
        TableFields.mytransid: element['MYTRANSID'],
        TableFields.deliveryId: element['DeliveryID'],
        TableFields.myprodid: element['MYPRODID'],
        TableFields.uom: element['UOM'],
        TableFields.locationId: element['LOCATION_ID'],
        TableFields.customerId: element['CustomerID'],
        TableFields.planid: element['planid'],
        TableFields.mealType: element['MealType'],
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
        TableFields.fat: element['Fat'],
        TableFields.itemWeight: element['ItemWeight'],
        TableFields.carbs: element['Carbs'],
        TableFields.qty: element['Qty'],
        TableFields.itemCost: element['Item_cost'],
        TableFields.itemPrice: element['Item_price'],
        TableFields.totalprice: element['Totalprice'],
        TableFields.shortRemark: element['ShortRemark'],
        TableFields.active: element['ACTIVE'].toString(),
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
        TableFields.mealUom: element['MealUOM'],
        TableFields.basicCustom: 'Fixed',
        TableFields.fixFlexible: 'Fixed',
      };
      try {
        final id =
            await dataBaseHelperInstance.insertToPlanMealCustInvoice(newRow);
        print('Row inserted in planmealcustinvoice db:$id');
      } catch (e) {
        print(e.toString());
      }
    });
  }
  Future<void> insertIntoPlanMealInvoiceHDDB(List rows) async {
    rows.forEach((dataForSql) async {
      Map<String, dynamic> row = {
        // DatabaseHelper.columnId: 1,
        DatabaseHelper.columntenentId: dataForSql['TenentID'],
        DatabaseHelper.columnmytransid: dataForSql['MYTRANSID'],
        DatabaseHelper.columnlocationId: dataForSql['LOCATION_ID'],
        DatabaseHelper.columncustomerId: dataForSql['CustomerID'],
        DatabaseHelper.columnplanid: dataForSql['planid'],
        DatabaseHelper.columndayNumber: dataForSql['TotalSubDays'],
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
        DatabaseHelper.columncontractTotalCount:
            dataForSql['ContractTotalCount'],
        DatabaseHelper.columncontractSelectedCount:
            dataForSql['ContractSelectedCount'],
        DatabaseHelper.columnisFullPlanCopied:
            dataForSql['IsFullPlanCopied'] ? 1 : 0,
        DatabaseHelper.columnsubscriptionOnHold:
            dataForSql['SubscriptionOnHold'] ? 1 : 0,
        DatabaseHelper.columnholdDate: dataForSql['HoldDate'],
        DatabaseHelper.columnunHoldDate: dataForSql['UnHoldDate'],
        DatabaseHelper.columnholdbyuser: dataForSql['Holdbyuser'],
        DatabaseHelper.columnholdREmark: dataForSql['HoldREmark'],
        DatabaseHelper.columnsubscriptonDayNumber:
            dataForSql['SubscriptonDayNumber'],
        DatabaseHelper.columntotalPrice: dataForSql['Total_price'],
        DatabaseHelper.columnshortRemark: dataForSql['ShortRemark'],
        DatabaseHelper.columnactive: dataForSql['ACTIVE'] ? 1 : 0,
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
      final id =
          await dataBaseHelperInstance.insertToplanMealCustInvoiceHD(row);
      print('Inserted row in hd at id: $id');
    });
  }
  Future<void> insertIntoPlanMealInvoiceMoreHDDB(List rList) async {
    rList.forEach((element) async {
      Map<String, dynamic> newRow = {
        TableFields.tenentid: element['TenentID'],
        TableFields.mytransid: element['MYTRANSID'],
        TableFields.mealtype: element['MealType'],
        TableFields.planid: element['planid'],
        TableFields.customized: element['MealFixFlexible'],
        TableFields.totalmealallowed: element['TotalMealAllowed'],
        TableFields.weekmealallowed: element['WeekMealAllowed'],
        TableFields.planingram: element['PlanInGram'],
        TableFields.mealfixflexible: element['MealFixFlexible'],
        TableFields.uom: element['UOM'],
        TableFields.mealingram: element['MealInGram'],
        TableFields.planbasecost: element['PlanBasecost'],
        TableFields.itembasecost: element['ItemBasecost'],
        TableFields.basemeal: element['BaseMeal'],
        TableFields.extrameal: element['ExtraMeal'],
        TableFields.extramealcost: element['ExtraMealCost'],
        TableFields.amt: element['Amt'],
        TableFields.uploaddate: '',
        TableFields.uploadby: element['Uploadby'],
        TableFields.syncdate: '',
        TableFields.syncby: element['Syncby'],
        TableFields.synid: element['SynID'],
        TableFields.totalamount: element['TotalAmount'],
        TableFields.paidamount: element['PaidAmount'],
        TableFields.alloweekend: element['AlloWeekend'],
        TableFields.updatedate: element['UpdateDate']
      };
      try {
        final id = await dataBaseHelperInstance.insertInToMoreHD(newRow);
        print('inserted row in more hd id: $id');
      } catch (e) {
        print(e.toString());
      }
    });
  }
  Future<void> insertIntoPlanMeal(List planMeal) async {
    dataBaseHelperInstance.deletePlanMeal().then((value) {
      planMeal.forEach((element) async {
        Map<String, dynamic> newRow = {
          "TenentID": element['TenentID'],
          "LOCATION_ID": element['LOCATION_ID'],
          "planid": element['planid'],
          "MealType": element['MealType'],
          "UOM": element['UOM'],
          "plandays": element['plandays'],
          "CustomAllow": element['CustomAllow'],
          "PlanInGram": element['PlanInGram'],
          "MealInGram": element['MealInGram'],
          "GroupID": element['GroupID'],
          "GroupName": element['GroupName'],
          "Calories": element['Calories'],
          "Protein": element['Protein'],
          "Carbs": element['Carbs'],
          "Fat": element['Fat'],
          "plandesc": element['plandesc'],
          "ItemWeight": element['ItemWeight'],
          "PlanBasecost": element['PlanBasecost'],
          "ItemBasecost": element['ItemBasecost'],
          "ItemExtraCost": element['ItemExtraCost'],
          "ShortRemark": element['ShortRemark'],
          "MealFixFlexible": element['MealFixFlexible'],
          "MealAllowed": element['MealAllowed'],
          "switch1": element['switch1'],
          "switch2": element['switch2'],
          "switch3": element['switch3'],
          "ACTIVE": element['ACTIVE'],
          "CRUP_ID": element['CRUP_ID'],
          "ChangesDate": element['ChangesDate'],
          "UploadDate": element['UploadDate'],
          "Uploadby": element['Uploadby'],
          "SyncDate": element['SyncDate'],
          "Syncby": element['Syncby'],
          "SynID": element['GrSynIDoupName'],
          "UpdateDate": element['UpdateDate'],
        };
        try {
          final id = await dataBaseHelperInstance.insertToPlanMeal(newRow);
          print('inserted row planMeal: $id');
        } catch (e) {
          print(e.toString());
        }
      });
    });
  }
  Future<void> insertIntoRefTable(List<LstRefTable> refTable) async {
    dataBaseHelperInstance.deleteRefTable().then((value) {
      refTable.forEach((element) async {
        Map<String, dynamic> newRow = {
          "TenentID" : element.tenentID
          ,"REFID"  : element.rEFID
          ,"REFTYPE"  : element.rEFTYPE
          ,"REFSUBTYPE"  : element.rEFSUBTYPE
          ,"SHORTNAME"  : element.sHORTNAME
          ,"REFNAME1"  : element.rEFNAME1
          ,"REFNAME2"  : element.rEFNAME2
          ,"REFNAME3"  : element.rEFNAME3
          ,"SWITCH1"  : element.sWITCH1
          ,"SWITCH2"  : element.sWITCH2
          ,"SWITCH3"  : element.sWITCH3
          ,"SWITCH4"  : element.sWITCH4
          ,"Remarks"  : element.remarks
          ,"ACTIVE"  : element.aCTIVE
          ,"CRUP_ID"  : element.cRUPID
          ,"Infrastructure"  : element.infrastructure
          ,"REF_Image"  : element.rEFImage
          ,"UploadDate"  : element.uploadDate
          ,"Uploadby"  : element.uploadby
          ,"SyncDate"  : element.syncDate
          ,"Syncby"  : element.syncby
          ,"SynID"  : element.synID
          ,"SMSTableMapped"  : element.sMSTableMapped
          ,"SMSColumnMapped"  : element.sMSColumnMapped
        };
        try {
          final id = await dataBaseHelperInstance.insertToRefTable(newRow);
          print('inserted row ref table: $id');
        } catch (e) {
          print(e.toString());
        }
      });
    });
  }

  Future<void> insertSubscriptionSetupData() async {
    print('Entered insertSubscriptionSetupData');
    try {
      Map body = {
        'TenentID': TenentID.toString(),
      };
      var response = await http.post(
          Uri.parse(
              'https://foodapi.pos53.com/api/Food/GettblSubscriptionSetup'),
          body: body);
      if (response.statusCode == 200) {
        var values = jsonDecode(response.body)['data'] as List;
        values.forEach((element) async {
          Map<String, dynamic> row = {
            TableFields.tenentid: element['TenentID'],
            TableFields.locationId: element['locationID'],
            TableFields.localId: element['LocalID'],
            TableFields.daysInWeek: element['days_in_week'],
            TableFields.displayWeek: element['DisplayWeek'],
            TableFields.allowCopyFullPlan: element['AllowCopyFullPlan'],
            TableFields.loadFullOrDayitem: element['LoadFullOrDayitem'],
            TableFields.defaultDeliveryTime: element['DefaultDeliveryTime'],
            TableFields.defaultDriverId: element['DefaultDriverID'],
            TableFields.defaultTotWeek: element['DefaultTotWeek'],
            TableFields.defaultDayB4PlanStart: element['DefaultDayB4PlanStart'],
            TableFields.whitchDayDelivery: element['Whitch_day_delivery'],
            TableFields.weekStartWithDay: element['Week_Start_With_Day'],
            TableFields.deliveryInDay: element['Delivery_in_day'],
            TableFields.deliveryTimeBegin: element['Delivery_time_begin'],
            TableFields.changesAllowed: element['Changes_Allowed'] ? 1 : 0,
            TableFields.beforeHowManyHours: element['Before_how_many_Hours'],
            TableFields.refundAllowed: element['Refund_Allowed'] ? 1 : 0,
            TableFields.afterCompletionOfHowManyPercentageOfDelivery:
                element['After_Completion_of_how_many_Percentage_of_Delivery'],
            TableFields.created: element['Created'],
            TableFields.createdDate: element['CreatedDate'],
            TableFields.active: element['Active'] ? 1 : 0,
            TableFields.deleted: element['Deleted'] ? 1 : 0,
            TableFields.kitchenRequestingStore:
                element['KitchenRequestingStore'],
            TableFields.mainStore: element['MainStore'],
            TableFields.incomingKitchenAutoAccept:
                element['IncomingKitchenAutoAccept'],
            TableFields.planImageLocation: element['planImageLocation'],
            TableFields.mealimageLocation: element['mealimageLocation'],
            TableFields.uploadDate: element['UploadDate'],
            TableFields.uploadby: element['Uploadby'],
            TableFields.syncDate: element['SyncDate'],
            TableFields.syncby: element['Syncby'],
            TableFields.synId: element['SynID'],
            TableFields.permsyncdate: element['permsyncdate'],
            TableFields.permversion: element['permversion'],
            TableFields.setMytransid: element['SetMYTRANSID'],
            TableFields.countryid: element['COUNTRYID'],
            TableFields.lifeCycle: element['LifeCycle'],
            TableFields.weekHoliday: element['Week_Holiday'],
          };
          int value =
              await dataBaseHelperInstance.insertToSubscriptionSetup(row);
          print('Subscription Table : $value');
        });
      } else {
        print('Bad response');
      }
      // print(await dataBaseHelperInstance.querySubscriptionSetup()) ;
    } catch (e) {
      print(e.toString());

    }
  }

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Image(
              image: AssetImage('assets/images/semi-circle.png'),
            ),
            Positioned(
              top: medq.height / 20,
              left: medq.width / 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تسجيل الدخول',
                    style: BeHealthyTheme.kMainTextStyle
                        .copyWith(fontSize: 33, color: Colors.white),
                  ),
                  Text(
                    'login'.tr,
                    style: BeHealthyTheme.kMainTextStyle
                        .copyWith(color: Colors.white, fontSize: 25),
                  )
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 50,
                      child: TextFormField(
                        controller: username,
                        cursorColor: BeHealthyTheme.kMainOrange,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  width: 1,
                                )),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                  width: 1, color: BeHealthyTheme.kMainOrange),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                  width: 2, color: BeHealthyTheme.kMainOrange),
                            ),
                            labelText: "ephone".tr,
                            labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 50,
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                        cursorColor: BeHealthyTheme.kMainOrange,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  width: 1,
                                )),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                  width: 1, color: BeHealthyTheme.kMainOrange),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                  width: 2, color: BeHealthyTheme.kMainOrange),
                            ),
                            labelText: "epass".tr,
                            labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text('dontaccount'.tr,
                            style: BeHealthyTheme.kDhaaTextStyle),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SignUpScreen();
                            }));
                          },
                          child: Text(
                            'signup'.tr,
                            style: BeHealthyTheme.kDhaaTextStyle
                                .copyWith(color: BeHealthyTheme.kMainOrange),
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (username.text.isNotEmpty && password.text.isNotEmpty) {
                          showDialog(barrierDismissible: false, context: context, builder: (context) {
                            var dataToPostMap  = {'TenentID': TenentID.toString(), 'EMAIL': username.text, 'CPASSWRD': password.text, 'MOBPHONE': username.text,
                            'FCNToken': fcmToken, 'action': 'AppLogin'
                            };
                            print(dataToPostMap);
                            Future.delayed(Duration(seconds: 3), () async {
                              try {
                                http.Response response = await http.post( Uri.parse("https://foodapi.pos53.com/api/Food/AuthenticateUser"),
                                      body: dataToPostMap,);

                                SharedPreferences preferences = await SharedPreferences.getInstance();
                                    // print(response.body);
                                var data = jsonDecode(response.body);
                                await insertSynchronizationDataInDB(data['data']['COMPID']);
                                await insertSubscriptionSetupData();
                                if (jsonDecode(response.body)['status'] == 200) {
                                  getSyncOneWay4(data['data']['COMPID']);
                                  getSyncOneWay2(data['data']['COMPID']);
                                  preferences.setString('email', data['data']['EMAIL']);
                                  preferences.setString('compName', data['data']['COMPNAME1']);
                                  preferences.setString('number', data['data']['MOBPHONE']);
                                  preferences.setString('state', data['data']['STATE']);
                                  preferences.setString('gender', data['data']['GENDER']);
                                  preferences.setInt('custID', data['data']['COMPID']);
                                  Navigator.pop(context);
                                  preferences.get('planTitle') != null ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BasicPlan()))
                                      : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                                    } else {
                                      Navigator.pop(context);
                                      username.clear();
                                      password.clear();
                                      showDialog(context: context, builder: (BuildContext context) {
                                          return AlertDialog(title: Text('error'.tr), content: Text(jsonDecode(response.body)['message']),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('ok'.tr),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  } catch (e) {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('error'.tr),
                                          content: Text('wrong_cred'.tr),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('ok'.tr),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                    // Toast.show(e.toString(), context,
                                    //     duration: 2,
                                    //     backgroundColor: BeHealthyTheme
                                    //         .kMainOrange
                                    //         .withOpacity(0.27),
                                    //     textColor: Colors.black);
                                  }
                                });
                                return Center(
                                    child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      BeHealthyTheme.kMainOrange),
                                ));
                              });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('error'.tr),
                                content: Text('enter_detail'.tr),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('ok'.tr),
                                  )
                                ],
                              );
                            },
                          );
                          // Toast.show('Please Enter your Details first', context,
                          //     duration: 3,
                          //     backgroundColor:
                          //         BeHealthyTheme.kMainOrange.withOpacity(0.27),
                          //     textColor: Colors.black);
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: BeHealthyTheme.kMainOrange,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'LOGIN',
                          style: BeHealthyTheme.kMainTextStyle
                              .copyWith(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
