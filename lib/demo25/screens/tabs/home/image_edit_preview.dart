import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_project/demo25/model/notes.dart';

import 'more_option.dart';

class ImageEditPreview extends StatefulWidget {
  final Note note;

  const ImageEditPreview({super.key, required this.note});

  @override
  State<ImageEditPreview> createState() => _ImageEditPreviewState();
}

class _ImageEditPreviewState extends State<ImageEditPreview> {
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? _capturedImage;
  bool _isGenerating = false;

  /// 可自定义的样式参数
  late Color _backgroundColor;
  double _cornerRadius = 20.0;
  double _padding = 24.0;
  Color _textColor = Colors.white;
  final Color _contentBgColor = Colors.white;
  double _titleFontSize = 24.0;
  double _contentFontSize = 16.0;

  /// 预定义的背景选项
  final List<Map<String, dynamic>> _backgroundOptions = [
    {'name': '背景1', 'color': Color(0xFF448AFF)},
    {'name': '背景2', 'color': Color(0xFFFFD700)},
    {'name': '背景3', 'color': Color(0xFF50C878)},
    {'name': '背景4', 'color': Color(0xFFFF5252)},
    {'name': '背景5', 'color': Color(0xFF3F51B5)},
    {'name': '背景6', 'color': Color(0xFFE040FB)},
    {'name': '背景7', 'color': Color(0xFFF50057)},
  ];

  @override
  void initState() {
    super.initState();
    _backgroundColor = Color(int.parse(widget.note.color));
    // 页面加载后自动生成初始图片
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateImage();
    });
  }

  /// 生成图片
  Future<void> _generateImage() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      await Future.delayed(Duration(milliseconds: 200));

      final image = await _screenshotController.captureFromLongWidget(
        RepaintBoundary(child: _buildImageContent()),
        delay: Duration(milliseconds: 100),
        pixelRatio: 2.0,
      );

      setState(() {
        _capturedImage = image;
        _isGenerating = false;
      });
    } catch (e) {
      print("生成图片失败: $e");
      setState(() {
        _isGenerating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("生成图片失败: ${e.toString()}")));
      }
    }
  }

  /// 构建图片内容
  Widget _buildImageContent() {
    // 获取当前时间并格式化
    final now = DateTime.now();
    final formattedTime =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    Widget content = Container(
      width: 350,
      constraints: BoxConstraints(
        minHeight: 600, // 最小高度
      ),
      padding: EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(_cornerRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            widget.note.title,
            style: TextStyle(
              fontSize: _titleFontSize,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          SizedBox(height: 8),
          // 时间
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                formattedTime,
                style: TextStyle(
                  fontSize: 12,
                  color: _textColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),

          // 内容区域
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: 600 - _padding * 2, // 设置一个合适的最小高度
            ),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _contentBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.note.content,
              style: TextStyle(
                fontSize: _contentFontSize,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );

    return Material(color: Colors.transparent, child: content);
  }

  /// 分享图片
  void _shareImage() async {
    if (_capturedImage == null) return;

    try {
      final xFile = XFile.fromData(
        _capturedImage!,
        mimeType: 'image/png',
        name: 'note_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await Share.shareXFiles([xFile]);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('分享成功')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('分享失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('分享图片', style: TextStyle(color: Colors.white)),
        actions: [
          if (_capturedImage != null)
            TextButton(
              onPressed: _shareImage,
              child: Text(
                '分享',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // 预览区域
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black87,
              child: Center(
                child: _isGenerating
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '正在生成预览...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : _capturedImage != null
                    ? ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          InteractiveViewer(
                            child: Image.memory(
                              _capturedImage!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      )
                    : Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          '预览生成失败',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
              ),
            ),
          ),

          /// 样式编辑区域
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '自定义样式',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    // 背景选项
                    Text(
                      '背景样式',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _backgroundOptions.length,
                        itemBuilder: (context, index) {
                          final option = _backgroundOptions[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _backgroundColor = option['color'];
                              });
                              _generateImage();
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: _backgroundColor == option['color']
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  option['name'],
                                  style: TextStyle(
                                    color: _backgroundColor == option['color']
                                        ? Colors.blue
                                        : Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),

                    // 文字颜色选项
                    Text(
                      '标题颜色',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _textColor = Colors.white;
                              });
                              _generateImage();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _textColor == Colors.white
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: _textColor == Colors.white
                                  ? Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.blue,
                                    )
                                  : null,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _textColor = Colors.black;
                              });
                              _generateImage();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _textColor == Colors.black
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: _textColor == Colors.black
                                  ? Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.blue,
                                    )
                                  : null,
                            ),
                          ),
                          ..._backgroundOptions.map((item) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _textColor = item['color'];
                                });
                                _generateImage();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: item["color"],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _textColor == item["color"]
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: _textColor == item["color"]
                                    ? Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.blue,
                                      )
                                    : null,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // 操作按钮
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _backgroundColor = Color(
                                int.parse(widget.note.color),
                              );
                              _cornerRadius = 20.0;
                              _padding = 24.0;
                              _textColor = Colors.white;
                              _titleFontSize = 24.0;
                              _contentFontSize = 16.0;
                              _generateImage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('初始化'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _showMoreOptions();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[600]!),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('更多选项'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoreOptionsPage(
          onValueChanged:
              (cornerRadius, padding, titleFontSize, contentFontSize) {
                setState(() {
                  _cornerRadius = cornerRadius;
                  _padding = padding;
                  _titleFontSize = titleFontSize;
                  _contentFontSize = contentFontSize;
                });
                _generateImage();
              },
          initialCornerRadius: _cornerRadius,
          initialPadding: _padding,
          initialTitleFontSize: _titleFontSize,
          initialContentFontSize: _contentFontSize,
        ),
      ),
    );
  }
}
