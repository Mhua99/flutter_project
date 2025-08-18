import "../model/notes.dart";
import "../model/result.dart";
import "../model/user.dart";
import "note_database.dart";
import "user_database.dart";

/// 作为统一入口协调各个模块
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  final NoteDatabase _noteDb = NoteDatabase();
  final UserDatabase _userDb = UserDatabase();

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Notes 相关方法
  Future<int> insertNote(Note note) => _noteDb.insertNote(note);
  Future<List<Note>> getNotes() => _noteDb.getNotes();
  Future<Result<Note>> getNotesWithCount({
    String? category,
    String? title,
    required int page,
    int pageSize = 10,
  }) => _noteDb.getNotesWithCount(
    category: category,
    title: title,
    page: page,
    pageSize: pageSize,
  );
  Future<int> updateNote(Note note) => _noteDb.updateNote(note);
  Future<int> deleteNote(int id) => _noteDb.deleteNote(id);
  Future<void> resetNotesTable() => _noteDb.resetNotesTable();

  // Users 相关方法
  Future<int> insertUser(User user) => _userDb.insertUser(user);
  Future<User?> getUserByUsernameAndPassword(String username, String password) =>
      _userDb.getUserByUsernameAndPassword(username, password);
  Future<User?> getUserByUsername(String username) =>
      _userDb.getUserByUsername(username);
  Future<int> updateUser(User user) => _userDb.updateUser(user);
  Future<int> deleteUser(int id) => _userDb.deleteUser(id);

  // 数据库初始化和关闭
  Future<void> initDatabase() async {
    await _noteDb.database;
  }

  Future<void> close() async {
    await _noteDb.close();
    await _userDb.close();
  }
}
