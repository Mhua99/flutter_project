import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../provider/global_state.dart';
import '../../../services/datebase.dart';
import '../../../model/category.dart' as CategoryModal;

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<CategoryModal.Category> _categories = [];
  bool _isLoading = true;
  /// 数据是否有变化
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();

    // 在下一帧执行，确保 context 可用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  Future<void> _loadCategories() async {
    try {
      // 在这里可以安全地使用 Provider
      final globalState = Provider.of<GlobalState>(context, listen: false);
      final userInfo = globalState.currentUser;

      final categories = await _databaseHelper.getAllCategories(userInfo?.id as int);
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "加载分类失败");
    }
  }

  Future<void> _refreshCategories() async {
    await _loadCategories();
  }

  void _addAndEditCategory({
    bool isAdd = false,
    CategoryModal.Category? category,
  }) async {
    final TextEditingController _controller = TextEditingController();

    if (category != null) {
      _controller.text = category.name;
    }

    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16.0),
          contentPadding: EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
          title: Row(
            children: [
              Text(
                isAdd ? "添加分类" : "编辑分类",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                Divider(color: Colors.grey[300]),
                SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "请输入分类名称",
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                // SizedBox(height: 10),
                // Divider(color: Colors.grey[300],),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("取消"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  Navigator.of(context).pop(_controller.text.trim());
                }
              },
              child: Text("确定"),
            ),
          ],
        );
      },
    );

    if (result != null) {
      try {
        /// 获取当前用户信息
        /// 在调用 Provider.of 时不希望触发 rebuild 的地方添加 listen: false 参数
        final globalState = Provider.of<GlobalState>(context, listen: false);
        final userInfo = globalState.currentUser;

        final CategoryModal.Category currentCategory = CategoryModal.Category(
          id: category?.id,
          name: _controller.text.trim(),
          createdUserId: userInfo?.id,
        );

        if (isAdd) {
          await _databaseHelper.insertCategory(currentCategory);
        } else {
          await _databaseHelper.updateCategory(currentCategory);
        }
        _hasChanged = true;
        await _loadCategories();
        Fluttertoast.showToast(msg: isAdd ? "分类添加成功" : "分类修改成功");
      } catch (e) {
        Fluttertoast.showToast(msg: "添加分类失败: 分类可能已存在");
      }
    }
  }

  void _deleteCategory(int id, String name) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("确认删除"),
          content: Text("确定要删除分类 \"$name\" 吗？"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("确定", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _databaseHelper.deleteCategory(id);
        await _loadCategories();
        Fluttertoast.showToast(msg: "分类删除成功");
      } catch (e) {
        Fluttertoast.showToast(msg: "删除分类失败");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text("分类管理", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // 返回时传递 true 表示有数据变化
            Navigator.pop(context, _hasChanged);
            _hasChanged = false;
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshCategories,
              child: _categories.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(15),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return _buildCategoryItem(category);
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addAndEditCategory(isAdd: true),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text("暂无分类", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          SizedBox(height: 10),
          Text(
            "点击右下角按钮添加分类",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModal.Category category) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        title: Text(
          category.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          "创建时间: ${category.createdAt ?? '未知'}",
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue, size: 20),
              onPressed: () => _addAndEditCategory(category: category),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () =>
                  _deleteCategory(category.id as int, category.name),
            ),
          ],
        ),
        onTap: () => _addAndEditCategory(category: category),
      ),
    );
  }
}
