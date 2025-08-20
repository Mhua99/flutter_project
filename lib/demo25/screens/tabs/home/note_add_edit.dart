import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/screens/tabs/home.dart';
import 'package:flutter_project/demo25/services/datebase.dart';
import 'package:provider/provider.dart';

import '../../../model/notes.dart';
import '../../../provider/global_state.dart';

class AddEditScreen extends StatefulWidget {
  final Note? note;
  final List<String> categoryList;

  const AddEditScreen({super.key, this.note, required this.categoryList});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  /// 用于调用 form 组件上的方法
  final _formKey = GlobalKey<FormState>();

  /// TextEditingController
  /// 1. 用于控制 TextField 或 TextFormField 组件的文本内容
  /// 2. 可以读取用户输入的文本
  /// 3. 可以设置文本框的初始值
  /// 4. 可以监听文本变化
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Color _selectedColor = Color(0xFF448AFF);

  /// 添加类型字段  默认类型
  String _selectedCategory = 'vue';

  final List<Color> _colors = [
    Color(0xFF448AFF),
    Color(0xFFFFD700),
    Color(0xFF50C878),
    Color(0xFFFF5252),
    Color(0xFF3F51B5),
    Color(0xFFE040FB),
    Color(0xFFF50057),
  ];

  @override
  void initState() {
    super.initState();

    /// 编辑的时候获取数据
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
      _selectedCategory = widget.note!.category ?? 'js';
    }
  }

  @override
  Widget build(BuildContext context) {

    final globalState = Provider.of<GlobalState>(context, listen: false);
    final user = globalState.currentUser;
    final List<String> _categories = widget.categoryList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.note == null ? '添加笔记' : '编辑笔记'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "标题",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "请输入标题";
                      }
                      return null;
                    },
                  ),
                  // 添加类型选择区域 - 使用Radio组件
                  Wrap(
                    // spacing: 2, // 主轴间距
                    // runSpacing: 0, // 交叉轴间距
                    children: _categories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: category,
                              groupValue: _selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                              },
                            ),
                            Text(category),
                            SizedBox(width: 16),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: "内容",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "请输入内容";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),

                    /// 可滚动组件
                    child: Row(
                      children: _colors.map((color) {
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            // 屏幕宽度的12%
                            width: MediaQuery.of(context).size.width * 0.10,
                            // 保持正方形
                            height: MediaQuery.of(context).size.width * 0.10,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor.value == color.value
                                    ? Colors.black45
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  /// InkWell 用于给子组件添加点击效果（水波纹效果）和点击交互功能。
                  InkWell(
                    onTap: () async {
                      try {
                        final note = await _saveNote(user);
                        Navigator.pop(context, note);
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF50C878),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "保存",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Note> _saveNote(user) async {
    if (_formKey.currentState!.validate()) {
      /// note 对象创建后不应该改变，使用 final 更符合语义
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        color: _selectedColor.value.toString(),
        dateTime: DateTime.now().toString(),
        category: _selectedCategory,
        createdUserId: user.id,
      );

      if (widget.note == null) {
        await _databaseHelper.insertNote(note);
      } else {
        await _databaseHelper.updateNote(note);
      }

      return note;
    } else {
      throw "请填写标题和内容";
    }
  }
}
