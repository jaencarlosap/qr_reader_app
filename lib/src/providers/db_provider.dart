import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

export 'package:qrreaderapp/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE scans ('
            'id INTEGER PRIMARY KEY,'
            ' type TEXT,'
            ' value TEXT'
            ')');
      },
    );
  }

  newScanRaw(ScanModel newScan) async {
    final db = await database;
    final res = await db.rawInsert('INSERT INTO scans (id,tipo,valor) '
        "VALUES (${newScan.id},'${newScan.type}','${newScan.value}')");

    return res;
  }

  newScan(ScanModel newScan) async {
    final db = await database;
    final res = await db.insert('scans', newScan.toJson());

    return res;
  }

  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('scans', where: 'id=?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getScans() async {
    final db = await database;
    final res = await db.query('scans');

    List<ScanModel> list = res.isNotEmpty
        ? res.map((scanItem) => ScanModel.fromJson(scanItem)).toList()
        : [];

    return list;
  }

  Future<int> updateScan(ScanModel newValues) async {
    final db = await database;
    final res = await db.update(
      'scans',
      newValues.toJson(),
      where: 'id=?',
      whereArgs: [newValues.id],
    );

    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('scans', where: 'id=?', whereArgs: [id]);

    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.delete('scans');

    return res;
  }
}
