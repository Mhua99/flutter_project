import "../model/category.dart";
import "base_database.dart";

class CategoryDatabase extends BaseDatabase {
  // 分类相关操作
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('category', category.toMap());
  }

  Future<List<Category>> getAllCategories(int currentUserId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'category',
      where: 'createdUserId = ?',
      whereArgs: [currentUserId],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete('category', where: 'id = ?', whereArgs: [id]);
  }

  Future<Category?> getCategoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllCategoriesSimple() async {
    final db = await database;
    return await db.query(
      'category',
      orderBy: 'createdAt DESC',
    );
  }

  // 查询指定用户的分类总数
  Future<int> getCategoryCount(int currentUserId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM category WHERE createdUserId = ?',
      [currentUserId],
    );

    return result.first['count'] as int;
  }
}
