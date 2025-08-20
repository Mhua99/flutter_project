import "../model/notes.dart";
import "../model/result.dart";
import "base_database.dart";

class NoteDatabase extends BaseDatabase {
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
    required int createdUserId,
  }) async {
    final db = await database;
    int offset = (page - 1) * pageSize;

    String? whereClause = 'createdUserId = ? ';
    List<Object?> whereArgs = [createdUserId];

    if (category != null && title != null) {
      whereClause += 'And category = ? AND title LIKE ?';
      whereArgs.addAll([category, '%$title%']);
    } else if (category != null) {
      whereClause += 'And category = ?';
      whereArgs.addAll([category]);
    } else if (title != null) {
      whereClause += 'And title LIKE ?';
      whereArgs.addAll(['%$title%']);
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

  /// 查询指定笔记的分类总数
  Future<int> getNoteCount(int currentUserId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notes WHERE createdUserId = ?',
      [currentUserId],
    );
    return result.first['count'] as int;
  }
}
