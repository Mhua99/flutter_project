import "../model/category.dart";
import "../model/notes.dart";
import "../model/result.dart";
import "../model/user.dart";
import "base_database.dart";
import "note_database.dart";
import "user_database.dart";
import "cagetory_database.dart";

/// 作为统一入口协调各个模块
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  final NoteDatabase _noteDb = NoteDatabase();
  final UserDatabase _userDb = UserDatabase();
  final CategoryDatabase _categoryDb = CategoryDatabase();

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

  Future<int> getNoteCount(int currentUserId) => _noteDb.getNoteCount(currentUserId);

  // Future<void> resetNotesTable() => _noteDb.resetNotesTable();

  // Users 相关方法
  /// 插入
  Future<int> insertUser(User user) => _userDb.insertUser(user);
  /// 更新
  Future<int> updateUser(User user) => _userDb.updateUser(user);
  /// 根据用户名和密码查找 用户
  Future<User?> getUserByUsernameAndPassword(
    String username,
    String password,
  ) => _userDb.getUserByUsernameAndPassword(username, password);
  /// 根据用户名查找 用户
  Future<User?> getUserByUsername(String username) =>
      _userDb.getUserByUsername(username);
  /// 根据id删除 用户
  Future<int> deleteUser(int id) => _userDb.deleteUser(id);
  Future<User?> getUserById(int id) => _userDb.getUserById(id);


  /**
   * 分类相关方法
   */
  /// 插入
  Future<int> insertCategory(Category category) => _categoryDb.insertCategory(category);

  /// 更新
  Future<int> updateCategory(Category category) => _categoryDb.updateCategory(category);

  /// 列表
  Future<List<Category>> getAllCategories(int currentUserId) => _categoryDb.getAllCategories(currentUserId);

  /// 根据id删除 分类
  Future<int> deleteCategory(int id) => _categoryDb.deleteCategory(id);

  /// 根据id查找 分类
  Future<Category?> getCategoryById(int id) => _categoryDb.getCategoryById(id);

  /// 查询指定用户的分类总数
  Future<int> getCategoryCount(int currentUserId) => _categoryDb.getCategoryCount(currentUserId);


  /// 数据库初始化和关闭
  Future<void> initDatabase() async {
    await BaseDatabase.getInstance().database;
  }

  Future<void> close() async {
    await _noteDb.close();
    await _userDb.close();
  }
}
