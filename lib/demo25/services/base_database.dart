import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "package:path_provider/path_provider.dart";

/// 负责数据库连接和基础操作
class BaseDatabase {
  static final BaseDatabase _instance = BaseDatabase._internal();
  static Database? _database;

  /// 添加默认构造函数
  BaseDatabase();

  /// 保持内部构造函数为私有
  BaseDatabase._internal();

  static BaseDatabase getInstance() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
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
      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, "my_note.db");

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      print('Database initialization error: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // 基类中留空，由子类实现具体的表创建逻辑
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 数据库升级逻辑
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
