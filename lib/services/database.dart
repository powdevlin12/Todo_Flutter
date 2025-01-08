import 'dart:async';
import 'dart:io';

import 'package:learn_fluter/models/collection_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static const _databaseName = "dat_manager.db";
  static const _databaseVersion = 1;

  static const tableCollections = 'collections';
  static const columnId = '_id';
  static const columnName = 'name';

  static const tableAccesses = 'accesses';
  static const columnAccessId = '_id';
  static const columnCollectionId = 'collection_id';
  static const columnNameAccess = 'name';
  static const columnIsChecked = 'is_checked';

  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableCollections (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableAccesses (
            $columnAccessId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnCollectionId INTEGER,
            $columnNameAccess TEXT,
            $columnIsChecked INTEGER
          )
          ''');
  }

  static Future<void> insertCollection(CollectionModel collection) async {
    final db = DBProvider._database;
    await db?.insert(DBProvider.tableCollections, collection.toMap());
  }
}
