import 'package:packages_persistencia/models/anuncio_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _db;

  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database?> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'anuncioDatabase.db');

    try {
      return _db = await openDatabase(path,
          version: 1, onCreate: _onCreateDb, onUpgrade: _onUpgradeDb);
    } catch (e) {
      print(e);
    }
  }

  Future _onCreateDb(Database db, int newVersion) async {
    await db.execute(AnuncioHelper.createScript);
  }

  Future _onUpgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute("DROP TABLE ${AnuncioHelper.tableName};");
      await _onCreateDb(db, newVersion);
    }
  }
}
