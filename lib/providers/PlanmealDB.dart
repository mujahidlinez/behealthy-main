import 'dart:io';
import 'package:behealthy/models/planmealcustominvoiceHDSave.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class PlanMealciHDdb {
  static Database _database;
  static final PlanMealciHDdb db = PlanMealciHDdb._();

  PlanMealciHDdb._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If not create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Data table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'beHealthy.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE planmealcustinvoiceHD('
          'id TEXT,'
          'tenentId INTEGER,'
          'mytransid INTEGER,'
          'locationId INTEGER,'
          'customerId INTEGER,'
          'planid INTEGER,'
          'dayNumber INTEGER,'
          'transId INTEGER,'
          'contractId TEXT,'
          'defaultDriverId INTEGER,'
          'contractDate TEXT,'
          'weekofDay TEXT,'
          'startDate TEXT,'
          'endDate TEXT,'
          'totalSubDays INTEGER,'
          'deliveredDays INTEGER,'
          'nExtDeliveryDate TEXT,'
          'nExtDeliveryNum INTEGER,'
          'week1TotalCount INTEGER,'
          'week1Count INTEGER,'
          'week2Count INTEGER,'
          'week2TotalCount INTEGER,'
          'week3Count INTEGER,'
          'week3TotalCount INTEGER,'
          'week4Count INTEGER,'
          'week4TotalCount INTEGER,'
          'week5Count INTEGER,'
          'week5TotalCount INTEGER,'
          'contractTotalCount INTEGER,'
          'contractSelectedCount INTEGER,'
          'isFullPlanCopied TEXT,'
          'subscriptionOnHold TEXT,'
          'holdDate TEXT,'
          'unHoldDate TEXT,'
          'holdbyuser INTEGER,'
          'holdREmark TEXT,'
          'subscriptonDayNumber INTEGER,'
          // 'totalPrice DOUBLE,'
          'shortRemark TEXT,'
          'active TEXT,'
          // 'crupId INTEGER,'
          'changesDate TEXT,'
          'driverId INTEGER,'
          'cStatus TEXT,'
          'uploadDate TEXT,'
          'uploadby TEXT,'
          'syncDate TEXT,'
          'syncby TEXT,'
          'synId INTEGER,'
          'paymentStatus TEXT,'
          'syncStatus TEXT,'
          'localId INTEGER,'
          'offlineStatus TEXT,'
          'allergies TEXT,'
          'carbs INTEGER,'
          'protein INTEGER,'
          'remarks TEXT'
          ')');
    });
  }

  // Insert Data on database
  createData(PlanMealCIHDSModel newData) async {
    await deleteAllPackages();
    final db = await database;
    // print(newData.contractDate);
    final res = await db.insert('planmealcustinvoiceHD', newData.toMap());
    return res;
  }

  insertData(PlanMealCIHDSModel newData) async {
    final db = await database;
    final res = db.update('planmealcustinvoiceHD', newData.toMap());
    return res;
  }

  // Delete all Datas
  Future<int> deleteAllPackages() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM planmealcustinvoiceHD');
    return res;
  }

  // Future<List<GetPackage>>
  getAllPackages() async {
    final db = await database;
    final res = await db.rawQuery("SELECT startDate FROM planmealcustinvoiceHD");
    List list = [];
    print(res);
    res.isNotEmpty
        ? res.forEach((element) {
            list.add(element);
            // list.add(GetPackage.fromJson(element));
          })
        : null;
    // res.isNotEmpty ? res.map((c) => GetPackage.fromJson(c)).toList() : [];
    return list;
  }
}
