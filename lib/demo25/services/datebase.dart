import "package:path/path.dart";
import "package:sqflite/sqflite.dart"; // 改为使用标准 sqflite
import "package:path_provider/path_provider.dart";
import "../model/notes.dart";
import "../model/result.dart";

class DatabaseHelper {
  /// 创建一个唯一的 DatabaseHelper 实例
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static Database? _database;

  /// 使用 factory 构造函数确保整个应用只有一个数据库实例
  factory DatabaseHelper() => _instance;

  /// 私有的命名构造函数，只能在类内部调用
  DatabaseHelper._internal();

  /// 数据库初始化
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, "my_note.db");

      // 确保目录存在
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      return await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (e) {
      print('Database initialization error: $e');
      rethrow;
    }
  }

  /// 表结构创建
  Future<void> _onCreate(Database db, int version) async {
    /**
     * 情况一
     *  1. my_note.db 文件不存在
        2. openDatabase 创建新的数据库文件
        3. 调用 _onCreate 方法创建表结构
        4. 后续操作都使用这个已创建的数据库

        情况二
        1. my_note.db 文件已存在
        2. openDatabase 直接打开现有数据库
        3. 不会调用 _onCreate
        4. 表结构已经存在，直接使用
     */
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

  /// 分页查询数据并返回总数
  Future<Result<Note>> getNotesWithCount({
    String? category,
    String? title,
    required int page,
    int pageSize = 10,
  }) async {
    final db = await database;

    // 计算偏移量
    int offset = (page - 1) * pageSize;

    // 构建查询条件
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

    // 查询当前页的数据
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: whereClause,
      whereArgs: whereArgs,
      limit: pageSize,
      offset: offset,
    );

    // 查询总数量
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notes ${whereClause != null ? "WHERE $whereClause" : ""}',
      whereArgs,
    );


    final totalCount = result.first['count'] as int;
    final notes = List.generate(maps.length, (i) => Note.fromMap(maps[i]));
    return Result(notes: notes, totalCount: totalCount);
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

  /// 关闭数据库连接
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
