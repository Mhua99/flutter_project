import "package:path/path.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "package:path_provider/path_provider.dart";

import "../model/notes.dart";

class DatabaseHelper {
  /// 创建一个唯一的 DatabaseHelper 实例
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static Database? _database;

  /// 使用 factory 构造函数确保整个应用只有一个数据库实例
  factory DatabaseHelper() => _instance;

  /// 声明命名构造函数，这里是定义，而不是调用
  /// DatabaseHelper._internal(){};
  DatabaseHelper._internal();

  /// 数据库初始化
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // 使用应用文档目录确保在所有平台上都有正确的访问权限
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "my_note.db");
    return await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
    );
  }

  /// 表结构创建
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        create table notes(
          id integer primary key autoincrement,
          title text,
          content text,
          color text,
          dateTime text 
         )
    ''');
  }

  /// 插入数据
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  /// 更新数据
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  /// 查询所有数据
  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  /// 删除数据
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  /// 清空表并重新创建
  Future<void> resetNotesTable() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS notes');
    // 重新创建表
    await _onCreate(db, 1);
  }
}
