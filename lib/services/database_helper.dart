import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/prayer_program.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    _database ??= await _initDB('prayer.db');
    return _database!;
  }

  Future<Database> _initDB(String file) async {
    final path = join(await getDatabasesPath(), file);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE programs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        theme TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<PrayerProgram> create(PrayerProgram p) async {
    final db = await instance.database;
    final id = await db.insert('programs', p.toMap());
    return p.copyWith(id: id);
  }

  Future<List<PrayerProgram>> readAll() async {
    final db = await instance.database;
    final result = await db.query('programs', orderBy: 'created_at DESC');
    return result.map(PrayerProgram.fromMap).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete('programs', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(PrayerProgram p) async {
    final db = await instance.database;
    return db.update('programs', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }
}
