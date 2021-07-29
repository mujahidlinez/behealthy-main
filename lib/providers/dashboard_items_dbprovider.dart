import 'dart:io';
import 'package:behealthy/models/dashboardItems_model.dart';
import 'package:behealthy/models/planmealcustominvoiceHDSave.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Data table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Data_manager.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE GetPackage('
          'id TEXT PRIMARY KEY,'
          'planID INTEGER,'
          'planName TEXT,'
          'arabicName TEXT,'
          'planWeight TEXT,'
          'planImage TEXT,'
          'sortBy TEXT,'
          'planPrice INTEGER'
          ')');
    }
    );
  }

  // Insert Data on database
  createData(GetPackage newData) async {
    await deleteAllPackages();
    final db = await database;
    final res = await db.insert('GetPackage', newData.toJson());
    return res;
  }

  // Delete all Datas
  Future<int> deleteAllPackages() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM GetPackage');
    return res;
  }

  // Future<List<GetPackage>>
  getAllPackages() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM GetPackage");
    List list = [];
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
