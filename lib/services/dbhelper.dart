import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../loacaldb/notemodel.dart';

mixin Dbhelper {
  static const int _version = 1;
  static const String _dbname = "notes.db";
  static Future<Database> _getdb() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbname),
      onCreate: (db, version) async => await db.execute(
        "CREATE TABLE NOTES id TEXT PRIMAR KEY, title TEXT NOT NULL,content TEXT NOT NULL,importance INT NOT NULL,created  TEXT NOT NULL,updated TEXT NOT NULL ",
      ),
      version: _version,
    );
  }

  static Future<int> addnote(Note note) async {
    final db = await _getdb();
    return await db.insert(
      'NOTES',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> updateNote(Note note) async {
    final db = await _getdb();
    return await db.update(
      'NOTES',
      note.toMap(),
      where: 'id =?',
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> deletenote(Note note) async {
    final db = await _getdb();
    return await db.delete('NOTES', where: 'id =?', whereArgs: [note.id]);
  }

  static Future<List<Note>?> fetch() async {
    final db = await _getdb();
    final List<Map<String, dynamic>> maps = await db.query("NOTES");
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(maps.length, (index) => Note.fromMap(maps[index]));
  }
}
