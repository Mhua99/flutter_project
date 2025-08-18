import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/screens/views.dart';
import 'package:flutter_project/demo25/services/datebase.dart';

import '../model/notes.dart';
import 'add_edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // 创建 FocusNode

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];
  List<Note> _notesOrign = [];

  /// 1. HomeScreen initState - 页面初始化
  /// 2. HomeScreen build - 页面构建
  /// 3. 跳转其他页面后，HomeScreen 暂停，但不销毁
  /// 4. 返回上一页 HomeScreen 恢复，但不会重新 build
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    // 释放资源
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // 查询数据
  _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notesOrign = notes;
      _notes = notes;
    });
  }

  /// 搜索
  void _filterNotes() {
    String keyworkd = _searchController.text.trim();
    final notes = _notesOrign
        .where((note) => note.title.contains(keyworkd))
        .toList();
    setState(() {
      _notes = notes;
    });
  }

  /// 格式化时间
  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return "今天，${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    }
    return "${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text("我的记事本", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// 搜索框
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 46,
              child: Align(
                alignment: Alignment.center,
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: "请输入关键词",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        print('点击了搜索图标');
                        _filterNotes();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _notes.isEmpty
              ? Expanded(child: Center(child: Text("暂无笔记")))
              : Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 16),

                    /// 创建了一个2列的网格布局，每个网格项之间有16像素的间距，形成整齐的笔记卡片展示效果。
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      /// 每行显示2列
                      crossAxisCount: 2,

                      /// 交叉轴上子元素之间的间距为16像素
                      crossAxisSpacing: 16,

                      /// 主轴上子元素之间的间距为16像素
                      mainAxisSpacing: 16,
                    ),

                    /// 生成网格数量
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      final color = Color(int.parse(note.color));
                      return GestureDetector(
                        /// 查看笔记
                        onTap: () async {
                          if (_searchFocusNode.hasFocus) {
                            /// 取消聚焦
                            _searchFocusNode.unfocus();

                            /// 等待键盘收起
                            await Future.any([
                              /// 等待一小段时间确保键盘收起
                              Future.delayed(Duration(milliseconds: 300)),

                              /// 设置超时
                              Future.delayed(Duration(seconds: 1)),
                            ]);
                          }

                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViewsPage(note: note),
                            ),
                          );
                          if (res == true) {
                            _loadNotes();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),

                                /// 最多显示一行
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Text(
                                note.content,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),

                                /// 最多显示四行
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Spacer(),
                              Text(
                                _formatDateTime(note.dateTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),

      /// 右下角添加按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (content) => AddEditScreen()),
          );
          _loadNotes();
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
