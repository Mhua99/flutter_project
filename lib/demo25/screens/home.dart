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
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // 查询数据
  _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
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
      body: GridView.builder(
        padding: EdgeInsets.all(16),

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
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ViewsPage(note: note)),
              );
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
                      fontSize: 18,
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
                    style: TextStyle(fontSize: 14, color: Colors.white70),

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
