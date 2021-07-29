import 'dart:io';
import 'package:behealthy/database/table_fields.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class PlanmealCustInvoiceDB {
  // static final _databaseName = "beHealthy.db";
  // static final _databaseVersion = 1;
  // static final tablePlanMealCustInvoice = 'planMealCustInvoice';
  // static final columnId = '_id';
  // static final tenentId = 'tenentId';
  // static final mytransid = 'mytransid';
  // static final deliveryId = 'deliveryId';
  // static final myprodid = 'myprodid';
  // static final uom = 'uom';
  // static final locationId = 'locationId';
  // static final customerId = 'customerId';
  // static final planid = 'planid';
  // static final basicCustom = 'basicCustom';
  // static final fixFlexible = 'fixFlexible';
  // static final mealType = 'mealType';
  // static final mealUom = 'mealUom';
  // static final prodName1 = 'prodName1';
  // static final oprationDay = 'oprationDay';
  // static final dayNumber = 'dayNumber';
  // static final transId = 'transId';
  // static final contractId = 'contractId';
  // static final weekofDay = 'weekofDay';
  // static final nameOfDay = 'nameOfDay';
  // static final totalWeek = 'totalWeek';
  // static final noOfWeek = 'noOfWeek';
  // static final displayWeek = 'displayWeek';
  // static final totalDeliveryDay = 'totalDeliveryDay';
  // static final actualDeliveryDay = 'actualDeliveryDay';
  // static final expectedDeliveryDay = 'expectedDeliveryDay';
  // static final deliveryTime = 'deliveryTime';
  // static final deliveryMeal = 'deliveryMeal';
  // static final driverId = 'driverId';
  // static final startDate = 'startDate';
  // static final endDate = 'endDate';
  // static final expectedDelDate = 'expectedDelDate';
  // static final actualDelDate = 'actualDelDate';
  // static final nExtDeliveryDate = 'nExtDeliveryDate';
  // static final returnReason = 'returnReason';
  // static final reasonDate = 'reasonDate';
  // static final productionDate = 'productionDate';
  // static final chiefId = 'chiefId';
  // static final subscriptonDayNumber = 'subscriptonDayNumber';
  // static final calories = 'calories';
  // static final protein = 'protein';
  // static final fat = 'fat';
  // static final itemWeight = 'itemWeight';
  // static final carbs = 'carbs';
  // static final qty = 'qty';
  // static final itemCost = 'item_cost';
  // static final itemPrice = 'item_price';
  // static final totalprice = 'totalprice';
  // static final shortRemark = 'shortRemark';
  // static final active = 'aCTIVE';
  // static final crupid = 'cRUP_ID';
  // static final changesDate = 'changesDate';
  // static final deliverySequence = 'deliverySequence';
  // static final switch1 = 'switch1';
  // static final switch2 = 'switch2';
  // static final switch3 = 'switch3';
  // static final switch4 = 'switch4';
  // static final switch5 = 'switch5';
  // static final status = 'status';
  // static final uploadDate = 'uploadDate';
  // static final uploadby = 'uploadby';
  // static final syncDate = 'syncDate';
  // static final syncby = 'syncby';
  // static final synId = 'synId';
  // static final syncStatus = 'syncStatus';
  // static final localId = 'localId';
  // static final offlineStatus = 'offlineStatus';
  // static final updateDate = 'updateDate';
  //
  // // make this a singleton class
  // PlanmealCustInvoiceDB._privateConstructor();
  //
  // static final PlanmealCustInvoiceDB instance =
  //     PlanmealCustInvoiceDB._privateConstructor();
  //
  // // only have a single app-wide reference to the database
  // static Database _database;
  //
  // Future<Database> get database async {
  //   if (_database != null) return _database;
  //   // lazily instantiate the db the first time it is accessed
  //   _database = await _initDatabase();
  //   return _database;
  // }
  //
  // // this opens the database (and creates it if it doesn't exist)
  // _initDatabase() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(documentsDirectory.path, _databaseName);
  //   return await openDatabase(path,
  //       version: _databaseVersion, onCreate: _onCreate);
  // }
  //
  // // SQL code to create the database table
  // Future _onCreate(Database db, int version) async {
  //   await db.execute('''
  //         CREATE TABLE $tablePlanMealCustInvoice (
  //         ${TableFields.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
  //         ${TableFields.tenentId} INTEGER,
  //         ${TableFields.mytransid} INTEGER,
  //         ${TableFields.deliveryId} INTEGER,
  //         ${TableFields.myprodid} INTEGER,
  //         ${TableFields.uom} INTEGER,
  //         ${TableFields.locationId} INTEGER,
  //         ${TableFields.customerId} INTEGER,
  //         ${TableFields.planid} INTEGER,
  //         ${TableFields.basicCustom} TEXT,
  //         ${TableFields.fixFlexible} TEXT,
  //         ${TableFields.mealType} INTEGER,
  //         ${TableFields.mealUom} INTEGER,
  //         ${TableFields.prodName1} TEXT,
  //         ${TableFields.oprationDay} INTEGER,
  //         ${TableFields.dayNumber} INTEGER,
  //         ${TableFields.transId} INTEGER,
  //         ${TableFields.contractId} TEXT,
  //         ${TableFields.weekofDay} TEXT,
  //         ${TableFields.nameOfDay} TEXT,
  //         ${TableFields.totalWeek} INTEGER,
  //         ${TableFields.noOfWeek} INTEGER,
  //         ${TableFields.displayWeek} INTEGER,
  //         ${TableFields.totalDeliveryDay} INTEGER,
  //         ${TableFields.actualDeliveryDay} INTEGER,
  //         ${TableFields.expectedDeliveryDay} INTEGER,
  //         ${TableFields.deliveryTime} INTEGER,
  //         ${TableFields.deliveryMeal} INTEGER,
  //         ${TableFields.driverId} INTEGER,
  //         ${TableFields.startDate} TEXT,
  //         ${TableFields.endDate} TEXT,
  //         ${TableFields.expectedDelDate} TEXT,
  //         ${TableFields.actualDelDate} TEXT,
  //         ${TableFields.nExtDeliveryDate} TEXT,
  //         ${TableFields.returnReason} INTEGER,
  //         ${TableFields.reasonDate} TEXT,
  //         ${TableFields.productionDate} TEXT,
  //         ${TableFields.chiefId} INTEGER,
  //         ${TableFields.subscriptonDayNumber} INTEGER,
  //         ${TableFields.calories} DOUBLE,
  //         ${TableFields.protein} DOUBLE,
  //         ${TableFields.carbs} DOUBLE,
  //         ${TableFields.fat} DOUBLE,
  //         ${TableFields.itemWeight} DOUBLE,
  //         ${TableFields.qty} INTEGER,
  //         ${TableFields.itemCost} DOUBLE,
  //         ${TableFields.itemPrice} DOUBLE,
  //         ${TableFields.totalprice} DOUBLE,
  //         ${TableFields.shortRemark} TEXT,
  //         ${TableFields.active} TEXT,
  //         ${TableFields.crupid} INTEGER,
  //         ${TableFields.changesDate} TEXT,
  //         ${TableFields.deliverySequence} INTEGER,
  //         ${TableFields.switch1}INTEGER,
  //         ${TableFields.switch2} INTEGER,
  //         ${TableFields.switch3} TEXT,
  //         ${TableFields.switch4} TEXT,
  //         ${TableFields.switch5} TEXT,
  //         ${TableFields.status} TEXT,
  //         ${TableFields.uploadDate} TEXT,
  //         ${TableFields.uploadby} TEXT,
  //         ${TableFields.syncDate} TEXT,
  //         ${TableFields.syncby} TEXT,
  //         ${TableFields.synId} INTEGER,
  //         ${TableFields.syncStatus} TEXT,
  //         ${TableFields.localId} INTEGER,
  //         ${TableFields.offlineStatus} TEXT,
  //         ${TableFields.updateDate} TEXT
  //         )
  //         ''');
  // }
  //
  // // Helper methods
  //
  // // Inserts a row in the database where each key in the Map is a column name
  // // and the value is the column value. The return value is the id of the
  // // inserted row.
  // Future<int> insertToPlanMealCustInvoice(Map<String, dynamic> row) async {
  //   Database db = await instance.database;
  //   return await db.insert(tablePlanMealCustInvoice, row);
  // }
  //
  // // All of the rows are returned as a list of maps, where each map is
  // // a key-value list of columns.
  // Future<List<Map<String, dynamic>>> queryAllRowsFromPlanMealCustInvoice(
  //     int weekNumber, int rplanid, int rMyTransID) async {
  //   Database db = await instance.database;
  //   // return await db.rawQuery(
  //   //     'SELECT DISTINCT $expectedDelDate, $nameOfDay, $totalWeek, $expectedDeliveryDay, $deliveryId FROM $table WHERE $noOfWeek=$weekNumber AND $mealType=$rMealType AND $planid=$rplanid');
  //   print(weekNumber);
  //
  //   print(rplanid);
  //   print(rMyTransID);
  //
  //   if (weekNumber == 1) {
  //     return await db.rawQuery(
  //         'SELECT DISTINCT $expectedDelDate, $nameOfDay, $totalWeek, $expectedDeliveryDay, $deliveryId FROM $tablePlanMealCustInvoice WHERE $displayWeek=1 AND $mealType=1402 AND $planid=$rplanid AND $mytransid=$rMyTransID');
  //   } else {
  //     return await db.rawQuery(
  //         'SELECT DISTINCT $expectedDelDate, $nameOfDay, $totalWeek, $expectedDeliveryDay, $deliveryId FROM $tablePlanMealCustInvoice WHERE $noOfWeek=$weekNumber AND $mealType=1402 AND $planid=$rplanid AND $mytransid=$rMyTransID');
  //   }
  // }
  //
  // queryDeliveryID(rEDDay, int rplanid) async {
  //   Database db = await instance.database;
  //   return await db.rawQuery(
  //       'SELECT DISTINCT $deliveryId FROM $tablePlanMealCustInvoice WHERE $expectedDeliveryDay=$rEDDay AND $planid=$rplanid');
  // }
  //
  // queryMealTypes(int rplanid) async {
  //   Database db = await instance.database;
  //   return await db.rawQuery(
  //       'SELECT DISTINCT $mealType FROM $tablePlanMealCustInvoice WHERE $planid=$rplanid');
  // }
  //
  // Future<List<Map<String, dynamic>>> querySelectedPlanMealCustInvoice(
  //     int rTenentId,
  //     int rMyTransId,
  //     // int rDeliveryId,
  //     int rExpectedDeliveryDay,
  //     int rPlanid,
  //     int rMealtype) async {
  //   Database db = await instance.database;
  //   // print('Received Tenent Id=$rTenentId');
  //   // print('Received TransId=$rMyTransId');
  //   // print('Received Delivery Id=$rDeliveryId');
  //   // print('Received Expected Del Day=$rExpectedDeliveryDay');
  //   // print('Received Plan Id=$rPlanid');
  //   // print('Received Meal Type=$rMealtype');
  //   return await db.rawQuery('''SELECT * FROM $tablePlanMealCustInvoice WHERE
  //          $expectedDeliveryDay = $rExpectedDeliveryDay AND
  //          $tenentId = $rTenentId AND
  //          $mytransid = $rMyTransId AND
  //          $planid = $rPlanid AND
  //          $mealType = $rMealtype''');
  // }
  //
  // Future<List<Map<String, dynamic>>> querySomeRowsPlanMealCustInvoice(int rplanid) async {
  //   Database db = await instance.database;
  //   return await db.rawQuery(
  //       '''SELECT DISTINCT $expectedDeliveryDay, $tenentId, $mytransid $planid, $mealType, $deliveryId FROM $tablePlanMealCustInvoice WHERE $planid=$rplanid''');
  // }
  //
  // // All of the methods (insert, query, update, delete) can also be done using
  // // raw SQL commands. This method uses a raw query to give the row count.
  // Future<int> queryRowCount() async {
  //   Database db = await instance.database;
  //   return Sqflite.firstIntValue(
  //       await db.rawQuery('SELECT COUNT(*) FROM $tablePlanMealCustInvoice'));
  //}

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  // Future<int> update(Map<String, dynamic> row) async {
  //   Database db = await instance.database;
  //   int id = row[columnId];
  //   return await db.update(tablePlanMealCustInvoice, row,
  //       where: '$columnId = ?', whereArgs: [id]);
  // }
  //
  // giveFirstWeekData() async {
  //   Database db = await instance.database;
  //   return await db.rawQuery(
  //       'SELECT * FROM $tablePlanMealCustInvoice WHERE $displayWeek=1');
  // }
  //
  // Future getFirstWeekUniqueData() async {
  //   Database db = await instance.database;
  //   return await db.rawQuery(
  //       'SELECT DISTINCT $expectedDelDate , $dayNumber FROM $tablePlanMealCustInvoice WHERE $noOfWeek=1');
  // }
  //
  // queryDate(int date) async {
  //   Database db = await instance.database;
  //   print(date);
  //   return await db.rawQuery(
  //       'SELECT * FROM $tablePlanMealCustInvoice WHERE $dayNumber=$date');
  // }
  //
  // Future getAllDistinctDate() async {
  //   Database db = await instance.database;
  //   return await db.rawQuery(
  //       'SELECT DISTINCT $expectedDelDate , $dayNumber FROM $tablePlanMealCustInvoice ');
  // }
  //
  // updateUsingRawQuery(
  //     int rProdId,
  //     int rUOM,
  //     double rItemCost,
  //     double rCalories,
  //     double rProtein,
  //     double rCarbs,
  //     double rFat,
  //     double rItemWeight,
  //     var rSwitch5,
  //     String rProdName1,
  //     String rShortRemark,
  //     int rTenentId,
  //     int rMyTransId,
  //     // int rDeliveryId,
  //     int rExpectedDeliveryDay,
  //     int rPlanid,
  //     int rMealtype) async {
  //   Database db = await instance.database;
  //   // print(rTenentId);
  //   // print(rMyTransId);
  //   // print(rDeliveryId);
  //   // print(rExpectedDeliveryDay);
  //   // print(rPlanid);
  //   // print(rMealtype);
  //   return await db.rawUpdate('''UPDATE $tablePlanMealCustInvoice
  //          SET
  //          $myprodid = ?,
  //          $uom = ?,
  //          $itemCost = ?,
  //          $calories = ?,
  //          $protein = ?,
  //          $carbs = ?,
  //          $fat = ?,
  //          $itemWeight = ?,
  //          $switch5 = ?,
  //          $prodName1 = ?,
  //          $shortRemark = ?
  //          WHERE
  //          $expectedDeliveryDay = ? AND
  //          $tenentId = ? AND
  //          $mytransid = ? AND
  //          $planid = ? AND
  //          $mealType = ?
  //        ''', [
  //     '$rProdId',
  //     '$rUOM',
  //     '$rItemCost',
  //     '$rCalories',
  //     '$rProtein',
  //     '$rCarbs',
  //     '$rFat',
  //     '$rItemWeight',
  //     '$rSwitch5',
  //     '$rProdName1',
  //     '$rShortRemark',
  //     '$rExpectedDeliveryDay',
  //     '$rTenentId',
  //     '$rMyTransId',
  //     '$rPlanid',
  //     '$rMealtype',
  //     // '$rDeliveryId'
  //   ]);
  // }
  //
  // // Deletes the row specified by the id. The number of affected rows is
  // // returned. This should be 1 as long as the row exists.
  // delete(int id) async {
  //   Database db = await instance.database;
  //   return await db
  //       .rawQuery("DELETE FROM $tablePlanMealCustInvoice WHERE $columnId=$id");
  // }
  //
  // deleteAllRows(int rMyTransId) async {
  //   Database db = await instance.database;
  //   return await db.rawQuery(
  //       'DELETE FROM $tablePlanMealCustInvoice WHERE $mytransid=$rMyTransId');
  // }
  //
  // deleteTable() async {
  //   Database db = await instance.database;
  //   return await db.rawQuery('DELETE FROM $tablePlanMealCustInvoice');
  // }
}
