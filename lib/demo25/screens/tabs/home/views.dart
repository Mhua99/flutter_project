import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/model/notes.dart';
import 'package:flutter_project/demo25/screens/tabs/home/note_add_edit.dart';
import 'package:flutter_project/demo25/services/datebase.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';

import '../../../utils/date.dart';
import '../../../utils/tts.dart';
import 'image_edit_preview.dart';

class ViewsPage extends StatefulWidget {
  final Note note;
  final List<String> categoryList;

  const ViewsPage({super.key, required this.note, required this.categoryList});

  @override
  State<ViewsPage> createState() => _ViewsPageState();
}

class _ViewsPageState extends State<ViewsPage> {
  late Note _currentNote;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TtsService ttsService = TtsService();
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();

    /// 初始化局部变量
    _currentNote = widget.note;
  }

  @override
  dispose() {
    super.dispose();
  }

  void speak() {
    ttsService.speak(widget.note.content);
  }

  /// 分享为文本
  void _shareAsText() {
    Share.share(_currentNote.content);
  }

  void _shareAsImage() async {
    try {
      /// 直接跳转到图片编辑预览页面，传递笔记数据
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditPreview(note: _currentNote),
        ),
      );
    } catch (e) {
      print("跳转到图片编辑页面失败: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("操作失败: ${e.toString()}")));
      }
    }
  }

  /// 显示分享选项对话框
  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "分享笔记",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  icon: Icons.text_snippet,
                  label: "文本",
                  onTap: () {
                    Navigator.pop(context);
                    _shareAsText();
                  },
                ),
                _buildShareOption(
                  icon: Icons.image,
                  label: "图片",
                  onTap: () {
                    Navigator.pop(context);
                    _shareAsImage();
                  },
                ),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "取消",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建分享选项按钮
  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.blue),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(_currentNote.color)),
      appBar: AppBar(
        backgroundColor: Color(int.parse(_currentNote.color)),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => speak(), // 添加阅读功能按钮
            icon: Icon(Icons.volume_up, color: Colors.white),
          ),
          IconButton(
            onPressed: () => _showShareOptions(), // 分享按钮
            icon: Icon(Icons.share, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              final res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditScreen(
                    note: _currentNote,
                    categoryList: widget.categoryList,
                  ),
                ),
              );
              if (res != null) {
                setState(() {
                  _currentNote = res;
                });
              }
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
          IconButton(
            onPressed: () => _deleteNote(context),
            icon: Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Screenshot(
          controller: _screenshotController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentNote.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              DateFormat.formatDateTime(_currentNote.dateTime),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          _currentNote.category,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Text(
                      _currentNote.content,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withAlpha(204),
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteNote(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("删除", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          "确定要删除吗？",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "取消",
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "确定",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _databaseHelper.deleteNote(widget.note.id!);
      Navigator.pop(context, true);
    }
  }
}
