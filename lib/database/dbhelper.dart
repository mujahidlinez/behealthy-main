import 'dart:io';
import 'package:behealthy/database/table_fields.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final _databaseName = "beHealthy.db";
  static final _databaseVersion = 1;
  static final tablePlanMealCustInvoiceHD = 'planMealCustInvoiceHD';
  static final tablePlanMealCustInvoice = 'planMealCustInvoice';
  static final tablePlanMealCustInvoiceMoreHD = 'planMealCustInvoiceMoreHD';
  static final tableSubscriptionSetup = 'subscriptionSetup';
  static final tableSyncOneWay4 = 'SyncOneWay4';
  static final tablePlanMeal = 'planMeal';
  static final tableRefTable = 'refTable';
  static final columnId = '_id';
  static final columntenentId = 'tenentId';
  static final columnmytransid = 'mytransid';
  static final columnlocationId = 'locationId';
  static final columncustomerId = 'customerId';
  static final columnplanid = 'planid';
  static final columndayNumber = 'dayNumber';
  static final columntransId = 'transId';
  static final columncontractId = 'contractId';
  static final columndefaultDriverId = 'defaultDriverId';
  static final columncontractDate = 'contractDate';
  static final columnweekofDay = 'weekofDay';
  static final columnstartDate = 'startDate';
  static final columnendDate = 'endDate';
  static final columntotalSubDays = 'totalSubDays';
  static final columndeliveredDays = 'deliveredDays';
  static final columnnExtDeliveryDate = 'nExtDeliveryDate';
  static final columnnExtDeliveryNum = 'nExtDeliveryNum';
  static final columnweek1TotalCount = 'week1TotalCount';
  static final columnweek1Count = 'week1Count';
  static final columnweek2Count = 'week2Count';
  static final columnweek2TotalCount = 'week2TotalCount';
  static final columnweek3Count = 'week3Count';
  static final columnweek3TotalCount = 'week3TotalCount';
  static final columnweek4Count = 'week4Count';
  static final columnweek4TotalCount = 'week4TotalCount';
  static final columnweek5Count = 'week5Count';
  static final columnweek5TotalCount = 'week5TotalCount';
  static final columncontractTotalCount = 'contractTotalCount';
  static final columncontractSelectedCount = 'contractSelectedCount';
  static final columnisFullPlanCopied = 'isFullPlanCopied';
  static final columnsubscriptionOnHold = 'subscriptionOnHold';
  static final columnholdDate = 'holdDate';
  static final columnunHoldDate = 'unHoldDate';
  static final columnholdbyuser = 'holdbyuser';
  static final columnholdREmark = 'holdREmark';
  static final columnsubscriptonDayNumber = 'subscriptonDayNumber';
  static final columntotalPrice = 'totalPrice';
  static final columnshortRemark = 'shortRemark';
  static final columnactive = 'aCTIVE';
  static final columncrupId = 'crup_Id';
  static final columnchangesDate = 'changesDate';
  static final columndriverId = 'driverId';
  static final columncStatus = 'cStatus';
  static final columnuploadDate = 'uploadDate';
  static final columnuploadby = 'uploadby';
  static final columnsyncDate = 'syncDate';
  static final columnsyncby = 'syncby';
  static final columnsynId = 'synId';
  static final columnpaymentStatus = 'paymentStatus';
  static final columnsyncStatus = 'syncStatus';
  static final columnlocalId = 'localId';
  static final columnofflineStatus = 'offlineStatus';
  static final columnallergies = 'allergies';
  static final columncarbs = 'carbs';
  static final columnprotein = 'protein';
  static final columnremarks = 'remarks';
  static final allowWeekEnd = 'AlloWeekend';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {

    await db.execute('''
          CREATE TABLE $tablePlanMealCustInvoiceHD (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columntenentId INTEGER,
          $columnmytransid INTEGER,
          $columnlocationId INTEGER,
          $columncustomerId INTEGER,
          $columnplanid INTEGER,
          $columndayNumber INTEGER,
          $columntransId INTEGER,
          $columncontractId TEXT,
          $columndefaultDriverId INTEGER,
          $columncontractDate TEXT,
          $columnweekofDay TEXT,
          $columnstartDate TEXT,
          $columnendDate TEXT,
          $columntotalSubDays INTEGER,
          $columndeliveredDays INTEGER,
          $columnnExtDeliveryDate TEXT,
          $columnnExtDeliveryNum INTEGER,
          $columnweek1TotalCount INTEGER,
          $columnweek1Count INTEGER,
          $columnweek2Count INTEGER,
          $columnweek2TotalCount INTEGER,
          $columnweek3Count INTEGER,
          $columnweek3TotalCount INTEGER,
          $columnweek4Count INTEGER,
          $columnweek4TotalCount INTEGER,
          $columnweek5Count INTEGER,
          $columnweek5TotalCount INTEGER,
          $columncontractTotalCount INTEGER,
          $columncontractSelectedCount INTEGER,
          $columnisFullPlanCopied INTEGER,
          $columnsubscriptionOnHold INTEGER,
          $columnholdDate TEXT,
          $columnunHoldDate TEXT,
          $columnholdbyuser INTEGER,
          $columnholdREmark TEXT,
          $columnsubscriptonDayNumber INTEGER,
          $columntotalPrice DOUBLE,
          $columnshortRemark TEXT,
          $columnactive INTEGER,
          $columncrupId INTEGER,
          $columnchangesDate TEXT,
          $columndriverId INTEGER,
          $columncStatus TEXT,
          $columnuploadDate TEXT,
          ${TableFields.totalamount} DOUBLE,
          ${TableFields.paidamount} DOUBLE,
           ${TableFields.alloweekend} INTEGER, 
          ${TableFields.updatedate} TEXT,
          ${TableFields.uom} INTEGER,
          $columnuploadby TEXT,
          $columnsyncDate TEXT,
          $columnsyncby TEXT,
          $columnsynId INTEGER,
          $columnpaymentStatus TEXT,
          $columnsyncStatus TEXT,
          $columnlocalId INTEGER,
          $columnofflineStatus TEXT,
          $columnallergies TEXT,
          $columncarbs INTEGER,
          $columnprotein INTEGER,
          $columnremarks TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $tablePlanMealCustInvoice (
          ${TableFields.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${TableFields.tenentId} INTEGER,
          ${TableFields.mytransid} INTEGER,
          ${TableFields.deliveryId} INTEGER,
          ${TableFields.myprodid} INTEGER,
          ${TableFields.uom} INTEGER,
          ${TableFields.locationId} INTEGER,
          ${TableFields.customerId} INTEGER,
          ${TableFields.planid} INTEGER,
          ${TableFields.basicCustom} TEXT,
          ${TableFields.fixFlexible} TEXT,
          ${TableFields.mealType} INTEGER,
          ${TableFields.mealUom} INTEGER,
          ${TableFields.prodName1} TEXT,
          ${TableFields.oprationDay} INTEGER,
          ${TableFields.dayNumber} INTEGER,
          ${TableFields.transId} INTEGER,
          ${TableFields.contractId} TEXT,
          ${TableFields.weekofDay} TEXT,
          ${TableFields.nameOfDay} TEXT,
          ${TableFields.totalWeek} INTEGER,
          ${TableFields.noOfWeek} INTEGER,
          ${TableFields.displayWeek} INTEGER,
          ${TableFields.totalDeliveryDay} INTEGER,
          ${TableFields.actualDeliveryDay} INTEGER,
          ${TableFields.expectedDeliveryDay} INTEGER,
          ${TableFields.deliveryTime} INTEGER,
          ${TableFields.deliveryMeal} INTEGER,
          ${TableFields.driverId} INTEGER,
          ${TableFields.startDate} TEXT,
          ${TableFields.endDate} TEXT,
          ${TableFields.expectedDelDate} TEXT,
          ${TableFields.actualDelDate} TEXT,
          ${TableFields.nExtDeliveryDate} TEXT,
          ${TableFields.returnReason} INTEGER,
          ${TableFields.reasonDate} TEXT,
          ${TableFields.productionDate} TEXT,
          ${TableFields.chiefId} INTEGER,
          ${TableFields.subscriptonDayNumber} INTEGER,
          ${TableFields.calories} DOUBLE,
          ${TableFields.protein} DOUBLE,
          ${TableFields.carbs} DOUBLE,
          ${TableFields.fat} DOUBLE,
          ${TableFields.itemWeight} DOUBLE,
          ${TableFields.qty} INTEGER,
          ${TableFields.itemCost} DOUBLE,
          ${TableFields.itemPrice} DOUBLE,
          ${TableFields.totalprice} DOUBLE,
          ${TableFields.shortRemark} TEXT,
          ${TableFields.active} TEXT,
          ${TableFields.crupid} INTEGER,
          ${TableFields.changesDate} TEXT,
          ${TableFields.deliverySequence} INTEGER,
          ${TableFields.switch1} INTEGER,
          ${TableFields.switch2} INTEGER,
          ${TableFields.switch3} TEXT,
          ${TableFields.switch4} TEXT,
          ${TableFields.switch5} TEXT,
          ${TableFields.status} TEXT,
          ${TableFields.uploadDate} TEXT,
          ${TableFields.uploadby} TEXT,
          ${TableFields.syncDate} TEXT,
          ${TableFields.syncby} TEXT,
          ${TableFields.synId} INTEGER,
          ${TableFields.syncStatus} TEXT,
          ${TableFields.localId} INTEGER,
          ${TableFields.offlineStatus} TEXT,
          ${TableFields.updateDate} TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $tablePlanMealCustInvoiceMoreHD (
          ${TableFields.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${TableFields.tenentid} INTEGER, 
          ${TableFields.mytransid} INTEGER, 
          ${TableFields.mealtype} TEXT, 
          ${TableFields.planid} INTEGER, 
          ${TableFields.customized} TEXT, 
          ${TableFields.uom} INTEGER, 
          ${TableFields.totalmealallowed} INTEGER, 
          ${TableFields.weekmealallowed} INTEGER, 
          ${TableFields.planingram} TEXT, 
          ${TableFields.mealfixflexible} TEXT, 
          ${TableFields.mealingram} TEXT, 
          ${TableFields.planbasecost} DOUBLE, 
          ${TableFields.itembasecost} DOUBLE, 
          ${TableFields.basemeal} INTEGER, 
          ${TableFields.extrameal} INTEGER, 
          ${TableFields.extramealcost} DOUBLE, 
          ${TableFields.amt} DOUBLE, 
          ${TableFields.uploaddate} TEXT, 
          ${TableFields.uploadby} TEXT, 
          ${TableFields.syncdate} TEXT, 
          ${TableFields.syncby} TEXT, 
          ${TableFields.synid} INTEGER,
          ${TableFields.totalamount} DOUBLE, 
          ${TableFields.paidamount} DOUBLE, 
          ${TableFields.alloweekend} INTEGER, 
          ${TableFields.PlanDays} INTEGER, 
          ${TableFields.updatedate} TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableSubscriptionSetup (
          ${TableFields.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${TableFields.tenentid} INTEGER, 
          ${TableFields.locationId} INTEGER, 
          ${TableFields.localId} INTEGER, 
          ${TableFields.daysInWeek} INTEGER, 
          ${TableFields.displayWeek} INTEGER, 
          ${TableFields.allowCopyFullPlan} TEXT, 
          ${TableFields.loadFullOrDayitem} INTEGER, 
          ${TableFields.defaultDeliveryTime} INTEGER, 
          ${TableFields.defaultDriverId} INTEGER, 
          ${TableFields.defaultTotWeek} INTEGER, 
          ${TableFields.defaultDayB4PlanStart} INTEGER, 
          ${TableFields.whitchDayDelivery} TEXT, 
          ${TableFields.weekStartWithDay} TEXT, 
          ${TableFields.deliveryInDay} INTEGER, 
          ${TableFields.deliveryTimeBegin} TEXT, 
          ${TableFields.changesAllowed} INTEGER, 
          ${TableFields.beforeHowManyHours} TEXT, 
          ${TableFields.refundAllowed} INTEGER, 
          ${TableFields.afterCompletionOfHowManyPercentageOfDelivery} INTEGER, 
          ${TableFields.created} INTEGER, 
          ${TableFields.createdDate} TEXT, 
          ${TableFields.active} INTEGER, 
          ${TableFields.deleted} INTEGER, 
          ${TableFields.kitchenRequestingStore} TEXT, 
          ${TableFields.mainStore} TEXT, 
          ${TableFields.incomingKitchenAutoAccept} INTEGER, 
          ${TableFields.planImageLocation} TEXT, 
          ${TableFields.mealimageLocation} TEXT, 
          ${TableFields.uploadDate} TEXT, 
          ${TableFields.uploadby} TEXT, 
          ${TableFields.syncDate} TEXT, 
          ${TableFields.syncby} TEXT, 
          ${TableFields.synId} INTEGER, 
          ${TableFields.permsyncdate} TEXT, 
          ${TableFields.permversion} TEXT, 
          ${TableFields.setMytransid} INTEGER, 
          ${TableFields.countryid} INTEGER, 
          ${TableFields.lifeCycle} INTEGER, 
          ${TableFields.weekHoliday} TEXT
          )
          ''');

    await db.execute('''CREATE TABLE $tableSyncOneWay4 (id INTEGER,TenentID INTEGER,LOCATION_ID INTEGER,planid INTEGER,MealType INTEGER,UOM INTEGER,
          plandays INTEGER, PlanInGram  TEXT,MealInGram TEXT,Calories REAL,Protein REAL,Carbs REAL,
          Fat REAL,ItemWeight REAL,PlanBasecost REAL,ItemBasecost REAL,ItemExtraCost REAL,ShortRemark TEXT,MealFixFlexible TEXT,MealAllowed  INTEGER,
          switch1  INTEGER,switch2 TEXT,switch3 TEXT,ACTIVE INTEGER,CRUP_ID INTEGER,ChangesDate TEXT, UploadDate TEXT,Uploadby TEXT,
          SyncDate TEXT, Syncby TEXT, SynID INTEGER, UpdateDate TEXT)''');

   var queryPlanMeal =  '''CREATE TABLE $tablePlanMeal(
     id INTEGER PRIMARY KEY AUTOINCREMENT
    ,TenentID INTEGER  
    ,LOCATION_ID INTEGER
    ,planid INTEGER
    ,MealType INTEGER
    ,UOM INTEGER
    ,plandays INTEGER
    ,CustomAllow TEXT
    ,PlanInGram INTEGER
    ,MealInGram INTEGER
    ,GroupID TEXT
    ,GroupName TEXT
    ,plandesc TEXT
    ,Calories REAL
    ,Protein REAL
    ,Carbs REAL
    ,Fat REAL
    ,ItemWeight REAL
    ,PlanBasecost REAL
    ,ItemBasecost REAL
    ,ItemExtraCost REAL
    ,ShortRemark TEXT
    ,MealFixFlexible TEXT
    ,MealAllowed INTEGER
    ,switch1 INTEGER
    ,switch2 INTEGER
    ,switch3 TEXT
    ,ACTIVE INTEGER
    ,CRUP_ID INTEGER
    ,ChangesDate TEXT
    ,UploadDate TEXT
    ,Uploadby TEXT
    ,SyncDate TEXT
    ,Syncby TEXT
    ,SynID INTEGER
    ,UpdateDate TEXT
    )''';
    await db.execute(queryPlanMeal);

    String refTableQueryStr  = '''CREATE TABLE $tableRefTable( 
    TenentID INTEGER 
    ,REFID INTEGER
    ,REFTYPE TEXT
    ,REFSUBTYPE TEXT 
    ,SHORTNAME TEXT
    ,REFNAME1 TEXT
    ,REFNAME2 TEXT
    ,REFNAME3 TEXT
    ,SWITCH1 INTEGER
    ,SWITCH2 INTEGER
    ,SWITCH3 INTEGER
    ,SWITCH4 INTEGER
    ,Remarks TEXT
    ,ACTIVE TEXT
    ,CRUP_ID INTEGER
    ,Infrastructure TEXT
    ,REF_Image TEXT
    ,UploadDate TEXT
    ,Uploadby TEXT
    ,SyncDate TEXT
    ,Syncby TEXT
    ,SynID INTEGER
    ,SMSTableMapped TEXT
    ,SMSColumnMapped TEXT
    )''';
    await db.execute(refTableQueryStr);
  }


  // Helper methods

  Future<int> insertToRefTable(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableRefTable, row);
  }

  Future deleteRefTable() async {
    Database db = await instance.database;
    return await db.rawQuery('DELETE FROM $tableRefTable');
  }

  Future getMealName(int mealType) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT REFNAME1 FROM $tableRefTable WHERE REFID = $mealType');
  }


  Future<int> insertToPlanMeal(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tablePlanMeal, row);
  }

  Future deletePlanMeal() async {
    Database db = await instance.database;
    return await db.rawQuery('DELETE FROM $tablePlanMeal');
  }

  Future<int> insertToSubscriptionSetup(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableSubscriptionSetup, row);
  }

  Future<void> insertToSyncOneWay4(List syncOneWay4) async {
    Database db = await instance.database;
    syncOneWay4.forEach((element) async{
      await db.transaction((txn) =>
          txn.insert(tableSyncOneWay4, element.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace));
      print("Plan Meal Saved");
    });
  }

  Future querySubscriptionSetup() async {
    Database db = await instance.database;
    var rows = await db.query(tableSubscriptionSetup);
    return rows[0];
  }

  Future queryPlanMealWithPlanId(String planId) async {
    Database db = await instance.database;
    var rows = await db.rawQuery('SELECT DISTINCT plandays FROM $tableSyncOneWay4 WHERE planid = $planId');
    return rows;
  }

  Future temp() async {
    Database db = await instance.database;
    var rows = await db.rawQuery('SELECT * FROM $tableSyncOneWay4 ');
    return rows;
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertToplanMealCustInvoiceHD(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tablePlanMealCustInvoiceHD, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(tablePlanMealCustInvoiceHD);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tablePlanMealCustInvoiceHD'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(tablePlanMealCustInvoiceHD, row,
        where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  deleteFromTablePlanMealCustInvoiceHD(int id) async {
    Database db = await instance.database;
    return await db.rawQuery(
        "DELETE FROM $tablePlanMealCustInvoiceHD WHERE $columnId=$id");
  }

  deleteTableInvoiceHD() async {
    Database db = await instance.database;
    return await db.rawQuery('DELETE FROM $tablePlanMealCustInvoiceHD');
  }

  Future getAllDistinctDate(int transID) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT DISTINCT ${TableFields.expectedDelDate} , ${TableFields.dayNumber} FROM $tablePlanMealCustInvoice WHERE ${TableFields.transId}=$transID');
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertToPlanMealCustInvoice(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tablePlanMealCustInvoice, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRowsFromPlanMealCustInvoice(int planId, int rMyTransID) async {
    Database db = await instance.database;
    var query =  'SELECT ${TableFields.expectedDelDate}, ${TableFields.nameOfDay}, ${TableFields.totalWeek}, ${TableFields.expectedDeliveryDay} FROM $tablePlanMealCustInvoice WHERE ${TableFields.mytransid}=$rMyTransID AND ${TableFields.mealType}=1402';
    print(query);
    return await db.rawQuery(query);
  }

  queryDaysToDisplay(int weekNumber, int rplanid, int rMyTransID) async {
    Database db = await instance.database;
    if (weekNumber == 1)
      return await db.rawQuery(
          'SELECT DISTINCT ${TableFields.expectedDelDate}, ${TableFields.nameOfDay} FROM $tablePlanMealCustInvoice WHERE ${TableFields.displayWeek}=1 AND ${TableFields.planid}=$rplanid AND ${TableFields.mytransid}=$rMyTransID');
    else
      return await db.rawQuery(
          'SELECT DISTINCT ${TableFields.expectedDelDate}, ${TableFields.nameOfDay} FROM $tablePlanMealCustInvoice WHERE ${TableFields.displayWeek}=$weekNumber AND ${TableFields.planid}=$rplanid AND ${TableFields.mytransid}=$rMyTransID');
  }

  queryDeliveryID(rEDDay, int rplanid) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT DISTINCT ${TableFields.deliveryId} FROM $tablePlanMealCustInvoice WHERE ${TableFields.expectedDeliveryDay}=$rEDDay AND ${TableFields.planid}=$rplanid');
  }


  queryMealTypes(int rplanid) async {
    Database db = await instance.database;
    var rows = await db.rawQuery(
    'SELECT DISTINCT ${TableFields.mealType} FROM $tablePlanMealCustInvoice WHERE ${TableFields.planid}=$rplanid');
    return rows;
  }

  selectPlanMeal() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT* FROM $tablePlanMeal');
  }

  selectPlanMealWithPlaId(var planId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT* FROM $tablePlanMeal WHERE planid = $planId');
  }


  selectPlanMealWithGroupId(var groupId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT* FROM $tablePlanMeal WHERE GroupId = $groupId');
  }



  Future<List<Map<String, dynamic>>> querySelectedPlanMealCustInvoice(int rTenentId, int rMyTransId, int rExpectedDeliveryDay,
      int rPlanid, int rMealtype) async {
    Database db = await instance.database;
    return await db.rawQuery('''SELECT * FROM $tablePlanMealCustInvoice WHERE 
           ${TableFields.expectedDeliveryDay} = $rExpectedDeliveryDay AND 
           ${TableFields.tenentId} = $rTenentId AND  
           ${TableFields.mytransid} = $rMyTransId AND 
           ${TableFields.planid} = $rPlanid AND 
           ${TableFields.mealType} = $rMealtype''');
  }

  updateUsingRawQuery(int rProdId, int rUOM, double rItemCost, double rCalories, double rProtein, double rCarbs, double rFat,
      double rItemWeight, var rSwitch5, String rProdName1, String rShortRemark, int rTenentId, int rMyTransId, String rExpectedDeliveryDate,
      int rPlanid, int rMealtype) async {

    Database db = await instance.database;
    DateFormat  dateFormat = DateFormat("yyyy-MM-ddThh:mm:ss","en-US");
    DateTime expectedDeliveryDate = dateFormat.parse(rExpectedDeliveryDate);
    dateFormat = DateFormat("MM/dd/yyyy","en-US");
    var expectedDeliveryDateFormatted = dateFormat.format(expectedDeliveryDate);


    String query = "UPDATE $tablePlanMealCustInvoice SET ${TableFields.myprodid} = $rProdId, ${TableFields.uom} = $rUOM,${TableFields.itemCost} = $rItemCost,${TableFields.calories} = $rCalories,${TableFields.protein} = $rProtein, ${TableFields.carbs} = $rCarbs, ${TableFields.fat} = $rFat, ${TableFields.itemWeight} = $rItemWeight,${TableFields.switch5} = $rSwitch5, ${TableFields.prodName1} = '${rProdName1 + 'Note by user'}',${TableFields.shortRemark} = '$rShortRemark' WHERE ${TableFields.expectedDelDate} = '$expectedDeliveryDateFormatted' AND  ${TableFields.tenentId} = $rTenentId AND  ${TableFields.mytransid} = $rMyTransId AND ${TableFields.planid} = $rPlanid AND  ${TableFields.mealType} = $rMealtype";
    var id = await db.rawUpdate(query);

    return id;
  }

  deletePlanMealCustInvoice(int id) async {
    Database db = await instance.database;
    return await db
        .rawQuery("DELETE FROM $tablePlanMealCustInvoice WHERE $columnId=$id");
  }

  deleteAllRowsFromPlanMealCustInvoice(int rMyTransId) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'DELETE FROM $tablePlanMealCustInvoice WHERE ${TableFields.mytransid}=$rMyTransId');
  }

  deleteTablePlanMealCustInvoice() async {
    Database db = await instance.database;
    return await db.rawQuery('DELETE FROM $tablePlanMealCustInvoice');
  }

  giveFirstWeekData(int transID) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT * FROM $tablePlanMealCustInvoice WHERE ${TableFields.displayWeek}=1 AND ${TableFields.transId}=$transID');
  }

  Future getFirstWeekUniqueData() async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT DISTINCT ${TableFields.expectedDelDate} , ${TableFields.dayNumber} FROM $tablePlanMealCustInvoice WHERE ${TableFields.noOfWeek}=1');
  }

  queryDate(int date, {int transID}) async {
    Database db = await instance.database;
    print(date);
    if (transID == null) {
      return await db.rawQuery(
          'SELECT * FROM $tablePlanMealCustInvoice WHERE ${TableFields.dayNumber}=$date');
    } else {
      return await db.rawQuery(
          'SELECT * FROM $tablePlanMealCustInvoice WHERE ${TableFields.dayNumber}=$date AND ${TableFields.transId}=$transID');
    }
  }

  Future getAllDistinctTransId() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT DISTINCT ${TableFields.transId} FROM $tablePlanMealCustInvoice ');
  }

  //ModeDB queries

  Future<int> insertInToMoreHD(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tablePlanMealCustInvoiceMoreHD, row);
  }


  deleteAllFromMoreHD() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $tablePlanMealCustInvoiceMoreHD");
  }


  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.

  Future<List<Map<String, dynamic>>> queryAllRowsFromMoreHD() async {
    Database db = await instance.database;
    return await db.query(tablePlanMealCustInvoiceMoreHD);
  }


  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCountFromMoreHD() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM $tablePlanMealCustInvoiceMoreHD'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateMoreHD(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(tablePlanMealCustInvoiceMoreHD, row,
        where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  deleteFromMoreHD(int id) async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $tablePlanMealCustInvoiceMoreHD WHERE $columnId=$id");
  }

  deleteTableMoreHD() async {
    Database db = await instance.database;
    return await db.rawQuery('DELETE FROM $tablePlanMealCustInvoiceMoreHD');
  }
}
