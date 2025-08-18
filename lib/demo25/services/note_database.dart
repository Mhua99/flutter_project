import "package:sqflite/sqflite.dart";
import "../model/notes.dart";
import "../model/result.dart";
import "base_database.dart";

class NoteDatabase extends BaseDatabase {
  Future<void> onCreate(Database db, int version) async {

    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        title TEXT,
        content TEXT,
        color TEXT,
        dateTime TEXT
      )
    ''');
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<Result<Note>> getNotesWithCount({
    String? category,
    String? title,
    required int page,
    int pageSize = 10,
  }) async {
    final db = await database;
    int offset = (page - 1) * pageSize;

    String? whereClause;
    List<Object?> whereArgs = [];

    if (category != null && title != null) {
      whereClause = 'category = ? AND title LIKE ?';
      whereArgs = [category, '%$title%'];
    } else if (category != null) {
      whereClause = 'category = ?';
      whereArgs = [category];
    } else if (title != null) {
      whereClause = 'title LIKE ?';
      whereArgs = ['%$title%'];
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: whereClause,
      whereArgs: whereArgs,
      limit: pageSize,
      offset: offset,
      orderBy: 'dateTime DESC', // 按日期倒序排列
    );

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notes ${whereClause != null ? "WHERE $whereClause" : ""}',
      whereArgs,
    );

    final totalCount = result.first['count'] as int;
    final notes = List.generate(maps.length, (i) => Note.fromMap(maps[i]));
    return Result(notes: notes, totalCount: totalCount);
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> resetNotesTable() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS notes');
    await onCreate(db, 1);
  }
}
