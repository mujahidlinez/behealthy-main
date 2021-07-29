import 'dart:convert';

import 'package:behealthy/database/dbhelper.dart';
import 'package:behealthy/models/meals_sync_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealsPlanProvider extends ChangeNotifier {
  int tenentID = 14;

  final DatabaseHelper dataBaseHelperInstance = DatabaseHelper.instance;

  Future<void> insertSynchronizationDataInDB(custID) async {
    Map requestBody = {
      'TenentID': tenentID.toString(),
      'CustomerID': custID.toString()
    };
    print('in insertSynchronizationDataInDB');
    var response = await http.post(
        Uri.parse(
            'https://foodapi.pos53.com/api/Food/SynchronizationProcess_GetData'),
        body: requestBody);
    if (response.statusCode == 200) {
      MealsSyncDataModel dataModel =
          MealsSyncDataModel.fromJson(json.decode(response.body));
      //  var responseBody = jsonDecode(response.body);
      var invoiceHD = dataModel.data
          .lstPlanmealcustinvoiceHD; //  responseBody['data']['lstPlanmealcustinvoiceHD'];
      if (invoiceHD != null) await insertIntoPlanMealInvoiceHDDB(invoiceHD);
      var invoice = dataModel.data
          .lstPlanmealcustinvoice; // responseBody['data']['lstPlanmealcustinvoice'];
      if (invoice != null) await insertIntoPlanMealInvoiceDB(invoice);
      var invoiceMoreHD = dataModel.data
          .lstPlanmealcustinvoiceMoreHD; // responseBody['data']['lstPlanmealcustinvoiceMoreHD'];
      if (invoiceMoreHD != null)
        await insertIntoPlanMealInvoiceMoreHDDB(invoiceMoreHD);

      notifyListeners();
    } else {
      print('ERROR');
      notifyListeners();
    }
  }

  Future<void> insertIntoPlanMealInvoiceDB(List<LstPlanmealcustinvoiceHD> allData) async {
    allData.forEach((element) async {
      Map<String, dynamic> newRow = element.toJson();
      //LstPlanmealcustinvoiceHD.fromJson(element);
      // {
      //   TableFields.tenentId: element.tenentID,//   element['TenentID'],
      //   TableFields.mytransid: element.mYTRANSID,// element['MYTRANSID'],
      //   TableFields.deliveryId:  element.driverID //element['DeliveryID'],
      //   TableFields.myprodid:element.MYPRODID// element['MYPRODID'],
      //   TableFields.uom: element['UOM'],
      //   TableFields.locationId: element['LOCATION_ID'],
      //   TableFields.customerId: element['CustomerID'],
      //   TableFields.planid: element['planid'],
      //   TableFields.mealType: element['MealType'],
      //   TableFields.prodName1: element['ProdName1'],
      //   TableFields.oprationDay: element['OprationDay'],
      //   TableFields.dayNumber: element['DayNumber'],
      //   TableFields.transId: element['TransID'],
      //   TableFields.contractId: element['ContractID'],
      //   TableFields.weekofDay: element['WeekofDay'],
      //   TableFields.nameOfDay: element['NameOfDay'],
      //   TableFields.totalWeek: element['TotalWeek'],
      //   TableFields.noOfWeek: element['NoOfWeek'],
      //   TableFields.displayWeek: element['DisplayWeek'],
      //   TableFields.totalDeliveryDay: element['TotalDeliveryDay'],
      //   TableFields.actualDeliveryDay: element['ActualDeliveryDay'],
      //   TableFields.expectedDeliveryDay: element['ExpectedDeliveryDay'],
      //   TableFields.deliveryTime: element['DeliveryTime'],
      //   TableFields.deliveryMeal: element['DeliveryMeal'],
      //   TableFields.driverId: element['DriverID'],
      //   TableFields.startDate: element['StartDate'],
      //   TableFields.endDate: element['EndDate'],
      //   TableFields.expectedDelDate: element['ExpectedDelDate'],
      //   TableFields.actualDelDate: element['ActualDelDate'],
      //   TableFields.nExtDeliveryDate: element['NExtDeliveryDate'],
      //   TableFields.returnReason: element['ReturnReason'],
      //   TableFields.reasonDate: element['ReasonDate'],
      //   TableFields.productionDate: element['ProductionDate'],
      //   TableFields.chiefId: element['chiefID'],
      //   TableFields.subscriptonDayNumber: element['SubscriptonDayNumber'],
      //   TableFields.calories: element['Calories'],
      //   TableFields.protein: element['Protein'],
      //   TableFields.fat: element['Fat'],
      //   TableFields.itemWeight: element['ItemWeight'],
      //   TableFields.carbs: element['Carbs'],
      //   TableFields.qty: element['Qty'],
      //   TableFields.itemCost: element['Item_cost'],
      //   TableFields.itemPrice: element['Item_price'],
      //   TableFields.totalprice: element['Totalprice'],
      //   TableFields.shortRemark: element['ShortRemark'],
      //   TableFields.active: element['ACTIVE'].toString(),
      //   TableFields.crupid: element['CRUPID'],
      //   TableFields.changesDate: element['ChangesDate'],
      //   TableFields.deliverySequence: element['DeliverySequence'],
      //   TableFields.switch1: element['Switch1'],
      //   TableFields.switch2: element['Switch2'],
      //   TableFields.switch3: element['Switch3'],
      //   TableFields.switch4: element['Switch4'],
      //   TableFields.switch5: element['Switch5'],
      //   TableFields.status: element['Status'],
      //   TableFields.uploadDate: element['UploadDate'],
      //   TableFields.uploadby: element['Uploadby'],
      //   TableFields.syncDate: element['SyncDate'],
      //   TableFields.syncby: element['Syncby'],
      //   TableFields.synId: element['SynID'],
      //   TableFields.syncStatus: element['syncStatus'],
      //   TableFields.localId: element['LocalID'],
      //   TableFields.offlineStatus: element['OfflineStatus'],
      //   TableFields.mealUom: element['MealUOM'],
      //   TableFields.basicCustom: 'Fixed',
      //   TableFields.fixFlexible: 'Fixed',
      // };
      try {
        final id =
            await dataBaseHelperInstance.insertToPlanMealCustInvoice(newRow);
        print('Row inserted in planmealcustinvoice db:$id');
      } catch (e) {
        print(e.toString());
      }
    });
  }

  Future<void> insertIntoPlanMealInvoiceHDDB(List<LstPlanmealcustinvoiceHD> rows) async {
    rows.forEach((dataForSql) async {
      Map<String, dynamic> row = dataForSql.toJson();

      // {
      //   // DatabaseHelper.columnId: 1,
      //   DatabaseHelper.columntenentId: dataForSql['TenentID'],
      //   DatabaseHelper.columnmytransid: dataForSql['MYTRANSID'],
      //   DatabaseHelper.columnlocationId: dataForSql['LOCATION_ID'],
      //   DatabaseHelper.columncustomerId: dataForSql['CustomerID'],
      //   DatabaseHelper.columnplanid: dataForSql['planid'],
      //   DatabaseHelper.columndayNumber: dataForSql['TotalSubDays'],
      //   DatabaseHelper.columntransId: dataForSql['TransID'],
      //   DatabaseHelper.columncontractId: dataForSql['ContractID'],
      //   DatabaseHelper.columndefaultDriverId: dataForSql['DefaultDriverID'],
      //   DatabaseHelper.columncontractDate: dataForSql['ContractDate'],
      //   DatabaseHelper.columnweekofDay: dataForSql['WeekofDay'],
      //   DatabaseHelper.columnstartDate: dataForSql['StartDate'],
      //   DatabaseHelper.columnendDate: dataForSql['EndDate'],
      //   DatabaseHelper.columntotalSubDays: dataForSql['TotalSubDays'],
      //   DatabaseHelper.columndeliveredDays: 0,
      //   DatabaseHelper.columnnExtDeliveryDate: dataForSql['NExtDeliveryDate'],
      //   DatabaseHelper.columnnExtDeliveryNum: dataForSql['NExtDeliveryNum'],
      //   DatabaseHelper.columnweek1TotalCount: dataForSql['Week1TotalCount'],
      //   DatabaseHelper.columnweek1Count: dataForSql['Week1Count'],
      //   DatabaseHelper.columnweek2Count: dataForSql['Week2Count'],
      //   DatabaseHelper.columnweek2TotalCount: dataForSql['Week2TotalCount'],
      //   DatabaseHelper.columnweek3Count: dataForSql['Week3Count'],
      //   DatabaseHelper.columnweek3TotalCount: dataForSql['Week3TotalCount'],
      //   DatabaseHelper.columnweek4Count: dataForSql['Week4Count'],
      //   DatabaseHelper.columnweek4TotalCount: dataForSql['Week4TotalCount'],
      //   DatabaseHelper.columnweek5Count: dataForSql['Week5Count'],
      //   DatabaseHelper.columnweek5TotalCount: dataForSql['Week5TotalCount'],
      //   DatabaseHelper.columncontractTotalCount:
      //       dataForSql['ContractTotalCount'],
      //   DatabaseHelper.columncontractSelectedCount:
      //       dataForSql['ContractSelectedCount'],
      //   DatabaseHelper.columnisFullPlanCopied:
      //       dataForSql['IsFullPlanCopied'] ? 1 : 0,
      //   DatabaseHelper.columnsubscriptionOnHold:
      //       dataForSql['SubscriptionOnHold'] ? 1 : 0,
      //   DatabaseHelper.columnholdDate: dataForSql['HoldDate'],
      //   DatabaseHelper.columnunHoldDate: dataForSql['UnHoldDate'],
      //   DatabaseHelper.columnholdbyuser: dataForSql['Holdbyuser'],
      //   DatabaseHelper.columnholdREmark: dataForSql['HoldREmark'],
      //   DatabaseHelper.columnsubscriptonDayNumber:
      //       dataForSql['SubscriptonDayNumber'],
      //   DatabaseHelper.columntotalPrice: dataForSql['Total_price'],
      //   DatabaseHelper.columnshortRemark: dataForSql['ShortRemark'],
      //   DatabaseHelper.columnactive: dataForSql['ACTIVE'] ? 1 : 0,
      //   DatabaseHelper.columncrupId: dataForSql['CRUP_ID'],
      //   DatabaseHelper.columnchangesDate: dataForSql['ChangesDate'],
      //   DatabaseHelper.columndriverId: dataForSql['DriverID'],
      //   DatabaseHelper.columncStatus: dataForSql['CStatus'],
      //   DatabaseHelper.columnuploadDate: dataForSql['UploadDate'],
      //   DatabaseHelper.columnuploadby: dataForSql['Uploadby'],
      //   DatabaseHelper.columnsyncDate: dataForSql['SyncDate'],
      //   DatabaseHelper.columnsyncby: dataForSql['Syncby'],
      //   DatabaseHelper.columnsynId: dataForSql['SynID'],
      //   DatabaseHelper.columnpaymentStatus: dataForSql['PaymentStatus'],
      //   DatabaseHelper.columnsyncStatus: dataForSql['syncStatus'],
      //   DatabaseHelper.columnlocalId: dataForSql['LocalID'],
      //   DatabaseHelper.columnofflineStatus: dataForSql['OfflineStatus'],
      //   DatabaseHelper.columnallergies: dataForSql['Allergies'],
      //   DatabaseHelper.columncarbs: dataForSql['Carbs'],
      //   DatabaseHelper.columnprotein: dataForSql['Protein'],
      //   DatabaseHelper.columnremarks: dataForSql['Remarks'],
      // };
      final id =
          await dataBaseHelperInstance.insertToplanMealCustInvoiceHD(row);
      print('Inserted row in hd at id: $id');
    });
  }

  Future<void> insertIntoPlanMealInvoiceMoreHDDB(List<LstPlanmealcustinvoiceMoreHD> rList) async {
    rList.forEach((element) async {
      Map<String, dynamic> newRow =  element.toJson();

      // {
      //   TableFields.tenentid: element['TenentID'],
      //   TableFields.mytransid: element['MYTRANSID'],
      //   TableFields.mealtype: element['MealType'],
      //   TableFields.planid: element['planid'],
      //   TableFields.customized: element['MealFixFlexible'],
      //   TableFields.totalmealallowed: element['TotalMealAllowed'],
      //   TableFields.weekmealallowed: element['WeekMealAllowed'],
      //   TableFields.planingram: element['PlanInGram'],
      //   TableFields.mealfixflexible: element['MealFixFlexible'],
      //   TableFields.uom: element [ 'UOM'],
      //   TableFields.mealingram: element['MealInGram'],
      //   TableFields.planbasecost: element['PlanBasecost'],
      //   TableFields.itembasecost: element['ItemBasecost'],
      //   TableFields.basemeal: element['BaseMeal'],
      //   TableFields.extrameal: element['ExtraMeal'],
      //   TableFields.extramealcost: element['ExtraMealCost'],
      //   TableFields.amt: element['Amt'],
      //   TableFields.uploaddate: '',
      //   TableFields.uploadby: element['Uploadby'],
      //   TableFields.syncdate: '',
      //   TableFields.syncby: element['Syncby'],
      //   TableFields.synid: element['SynID'],
      //   TableFields.totalamount: element['TotalAmount'],
      //   TableFields.paidamount: element['PaidAmount'],
      //   TableFields.alloweekend: element['AlloWeekend'],
      //   TableFields.updatedate: element['UpdateDate']
      // };
      try {
        final id = await dataBaseHelperInstance.insertInToMoreHD(newRow);
        print('inserted row in more hd id: $id');
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
