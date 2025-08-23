import "dart:io";

import "package:flutter_project/demo25/utils/const.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "package:path_provider/path_provider.dart";

/// 负责数据库连接和基础操作
class BaseDatabase {
  static final BaseDatabase _instance = BaseDatabase._internal();
  static Database? _database;
  static Directory? _getBackUpPath;

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

  Future<Directory?> get getBackUpPath async {
    if (_getBackUpPath != null) return _getBackUpPath;
    _getBackUpPath = await initBackUpPath();
    return _getBackUpPath!;
  }

  /// 初始化备份路径
  Future<Directory> initBackUpPath() async {
    Directory? backupDir;

    try {
      if (Platform.isAndroid) {
        backupDir = Directory(ConstUtils.backupPath);
      }
    } catch (e) {
      print('无法访问Downloads目录: $e');
    }

    /// 如果无法访问Downloads目录，回退到应用特定目录
    if (backupDir == null) {
      final appDocDir = await getApplicationDocumentsDirectory();
      backupDir = Directory('${appDocDir.path}/backup');
    }

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    return backupDir;
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
        version: 3,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      print('Database initialization error: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    /// 创建日记表
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        title TEXT,
        content TEXT,
        color TEXT,
        dateTime TEXT,
        createdUserId INTEGER,
        createdAt TEXT DEFAULT (datetime('now', 'localtime'))
      )
    ''');

    // 创建分类表
    await db.execute('''
      CREATE TABLE category(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        createdUserId INTEGER,
        createdAt TEXT DEFAULT (datetime('now', 'localtime'))
      )
    ''');

    /// 床脚用户表
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        avatar TEXT,
        email TEXT,
        createdAt TEXT DEFAULT (datetime('now', 'localtime'))
      )
    ''');

    /// 插入默认用户数据
    /// 使用批处理插入多条数据
    Batch batch = db.batch();
    batch.insert('users', {
      'username': 'admin',
      'password': '123456',
      'avatar': 'assets/demo25/logo1.png',
      'email': 'admin@example.com',
    });
    batch.insert('users', {
      'username': 'test',
      'password': '123456',
      'avatar': 'assets/demo25/logo1.png',
      'email': 'user@example.com',
    });
    await batch.commit();

    /// 为已存在的默认用户添加默认分类
    final users = await db.query('users');

    /// 创建新的批处理对象用于插入分类
    Batch categoryBatch = db.batch();
    for (var user in users) {
      final userId = user['id'] as int;

      /// 为每个用户添加默认分类
      final defaultCategories = ['vue', 'javascript', 'html', 'other'];
      for (String categoryName in defaultCategories) {
        categoryBatch.insert('category', {
          'name': categoryName,
          'createdUserId': userId,
        });
      }
    }

    /// 提交分类批处理
    await categoryBatch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 数据库升级逻辑
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<String> getDatabasePath() async {
    final db = await database;
    return db.path;
  }

  /// 备份整个数据库文件
  Future<String> backupDatabase() async {
    try {
      final dbPath = await getDatabasePath();
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        throw Exception('数据库文件不存在');
      }

      Directory? backupDir = await getBackUpPath;

      /// 生成备份文件名
      final now = DateTime.now();
      final timestamp =
          "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
      final fileName = '笔记备份_$timestamp.db';
      final backupPath = '${backupDir?.path}/$fileName';

      /// 复制数据库文件
      await dbFile.copy(backupPath);

      print('备份文件已创建: $backupPath');
      return backupPath;
    } catch (e) {
      print('备份数据库失败: $e');
      throw Exception('备份数据库失败: $e');
    }
  }

  Future<void> restoreDatabase(String backupPath) async {
    try {
      /// 备份文件路径
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        throw Exception('备份文件不存在');
      }

      /// 获取数据库路径
      final appDocDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDocDir.path, 'my_note.db');

      /// 关闭当前数据库连接
      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      /// 用备份文件替换当前数据库
      await backupFile.copy(dbPath);

      print('数据库恢复成功: $dbPath');
    } catch (e) {
      print('恢复数据库失败: $e');
      throw Exception('恢复数据库失败: $e');
    }
  }
}
