
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/quote_model.dart';

import '../helper/const.dart';

class QuoteDatabase {
  QuoteDatabase._internal();
  static final QuoteDatabase _db = QuoteDatabase._internal();
  static QuoteDatabase get instance => _db;
  static Database? _database;
  Future<Database> get database async
  {
    if (_database != null) {
      return _database!;
    }
    _database = await _createDataBase();
    return _database!;
  }
  Future<Database> _createDataBase() async
  {
    return openDatabase(
      join(await getDatabasesPath(),'quotes.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE $tableName ($id INTEGER PRIMARY KEY AUTOINCREMENT ,'
                '$content TEXT UNIQUE ,$author TEXT)');
        },
      version: 1,
    );
  }

}