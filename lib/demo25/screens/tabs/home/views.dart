import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/model/notes.dart';
import 'package:flutter_project/demo25/screens/tabs/home/note_add_edit.dart';
import 'package:flutter_project/demo25/services/datebase.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';

import '../../../utils/date.dart';
import 'image_edit_preview.dart';

class ViewsPage extends StatefulWidget {
  final Note note;
  final List<String> categoryList;

  const ViewsPage({super.key, required this.note, required this.categoryList});

  @override
  State<ViewsPage> createState() => _ViewsPageState();
}

class _ViewsPageState extends State<ViewsPage> with TickerProviderStateMixin {
  late Note _currentNote;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final FlutterTts ttsService = FlutterTts();
  final ScreenshotController _screenshotController = ScreenshotController();

  /// 添加播放状态管理
  bool _isPlaying = false;

  /// 是否修改了数据
  bool isModified = false;

  /// 添加循环播放状态
  bool _isLooping = false;
  double _speechRate = 1.0;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;

    /// 初始化动画控制器
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    /// 监听TTS完成事件，实现循环播放
    ttsService.setCompletionHandler(() {
      if (_isLooping) {
        /// 如果是循环播放状态，重新开始播放
        _isPlaying = false;
        _toggleSpeak();
      } else if (_isPlaying) {
        /// 如果不是循环播放，停止播放状态
        setState(() {
          _isPlaying = false;
        });
        _animationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    ttsService.stop();
    super.dispose();
  }

  /// 切换音速度
  void _toggleSpeechRate() {
    setState(() {
      if (_speechRate == 1.0) {
        _speechRate = 1.5;
      } else if (_speechRate == 1.5) {
        _speechRate = 2.0;
      } else if (_speechRate == 2.0) {
        _speechRate = 2.5;
      } else if (_speechRate == 2.5) {
        _speechRate = 3.0;
      } else {
        _speechRate = 1.0;
      }
    });

    /// 如果正在播放，更新语速
    if (_isPlaying) {
      ttsService.setSpeechRate(_speechRate);

      /// 重新开始播放以应用新的语速
      ttsService.stop();
      ttsService.speak(widget.note.content);
    }
  }

  /// 播放/暂停文本
  void _toggleSpeak() async {
    if (_isPlaying) {
      // 正在播放，点击停止
      ttsService.stop();
      setState(() {
        _isPlaying = false;
      });
      _animationController.stop();
    } else {
      /// 未播放，开始播放
      ttsService.setSpeechRate(_speechRate);
      ttsService.speak(widget.note.content);
      setState(() {
        _isPlaying = true;
      });
      _animationController.repeat(reverse: true);
    }
  }

  /// 切换循环播放状态
  void _toggleLoop() {
    setState(() {
      _isLooping = !_isLooping;
    });
  }

  /// 分享为文本
  void _shareAsText() {
    Share.share(_currentNote.content);
  }

  void _shareAsImage() async {
    try {
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
    return WillPopScope(
      onWillPop: () async {
        // 处理返回逻辑
        Navigator.pop(context, isModified);
        return false; // 阻止默认的返回行为
      },
      child: Scaffold(
        backgroundColor: Color(int.parse(_currentNote.color)),
        appBar: AppBar(
          backgroundColor: Color(int.parse(_currentNote.color)),
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context, isModified),
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            // 循环播放按钮
            IconButton(
              onPressed: _toggleLoop,
              icon: Icon(
                _isLooping ? Icons.repeat_one : Icons.repeat_one_outlined,
                color: _isLooping ? Colors.green : Colors.white,
              ),
              tooltip: _isLooping ? "关闭循环播放" : "开启循环播放",
            ),
            // 播放按钮
            IconButton(
              onPressed: () => _toggleSpeak(),
              icon: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isPlaying ? _pulseAnimation.value : 1.0,
                    child: Icon(
                      _isPlaying ? Icons.stop : Icons.volume_up,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            // 音速度按钮
            GestureDetector(
              onTap: _toggleSpeechRate,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.speed, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text(
                      _speechRate.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () => _showShareOptions(),
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

                  isModified = true;
                  // 如果正在播放，停止播放
                  if (_isPlaying) {
                    ttsService.stop();
                    setState(() {
                      _isPlaying = false;
                    });
                    _animationController.stop();
                  }
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
    // 如果正在播放，先停止
    if (_isPlaying) {
      ttsService.stop();
      setState(() {
        _isPlaying = false;
      });
      _animationController.stop();
    }

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
