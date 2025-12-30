import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../loacaldb/notemodel.dart';

mixin Dbhelper {
  static const int _version = 1;
  static const String _dbname = "notes.db";
  static Future<Database> _getdb() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbname),
      version: _version,
      onCreate: (db, version) async => await db.execute(
        'CREATE TABLE NOTES (id TEXT PRIMARY KEY,userId TEXT NOT NULL, title TEXT NOT NULL,content TEXT NOT NULL,importance INTEGER NOT NULL,created  TEXT NOT NULL,updated TEXT NOT NULL ,deletedat TEXT)',
      ),
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
      where: 'id =? AND userId=?',
      whereArgs: [note.id, note.userId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deletenote(Note note) async {
    final db = await _getdb();
    final deletedNote = note.copyWith(deletedat: DateTime.now());
    await db.update(
      'NOTES',
      deletedNote.toMap(),
      where: 'id=?AND userId=?',
      whereArgs: [note.id, note.userId],
    );
  }

  static Future<List<Note>> fetch(String userId) async {
    final db = await _getdb();
    final List<Map<String, dynamic>> maps = await db.query(
      "NOTES",
      where: 'userId=? AND deletedat IS NULL',
      whereArgs: [userId],
      orderBy: 'importance ASC,updated ASC',
    );
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (index) => Note.fromMap(maps[index]));
  }
}
