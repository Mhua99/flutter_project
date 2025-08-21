import 'package:flutter/material.dart';

class MoreOptionsPage extends StatefulWidget {
  final Function(double, double, double, double) onValueChanged;
  final double initialCornerRadius;
  final double initialPadding;
  final double initialTitleFontSize;
  final double initialContentFontSize;

  const MoreOptionsPage({
    super.key,
    required this.onValueChanged,
    required this.initialCornerRadius,
    required this.initialPadding,
    required this.initialTitleFontSize,
    required this.initialContentFontSize,
  });

  @override
  State<MoreOptionsPage> createState() => _MoreOptionsPageState();
}

class _MoreOptionsPageState extends State<MoreOptionsPage> {
  late double _cornerRadius;
  late double _padding;
  late double _titleFontSize;
  late double _contentFontSize;

  /// 文字大小选项
  final Map<String, double> _fontSizeOptions = {
    '小': 16.0,
    '中': 24.0,
    '大': 32.0,
  };

  @override
  void initState() {
    super.initState();
    _cornerRadius = widget.initialCornerRadius;
    _padding = widget.initialPadding;
    _titleFontSize = widget.initialTitleFontSize;
    _contentFontSize = widget.initialContentFontSize;
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
        title: Text('自定义选项', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              '更多自定义选项',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            /// 圆角设置
            Text('圆角大小', style: TextStyle(color: Colors.white70)),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: Colors.blue,
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.grey[700],
              ),
              child: Slider(
                value: _cornerRadius.clamp(0.0, 50.0),
                min: 0,
                max: 50,
                divisions: 50,
                onChanged: (value) {
                  setState(() {
                    _cornerRadius = value;
                  });
                },
              ),
            ),
            Text(
              _cornerRadius.toStringAsFixed(1),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),

            /// 内边距设置
            Text('内边距', style: TextStyle(color: Colors.white70)),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: Colors.blue,
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.grey[700],
              ),
              child: Slider(
                value: _padding.clamp(10.0, 50.0),
                min: 10,
                max: 50,
                divisions: 40,
                onChanged: (value) {
                  setState(() {
                    _padding = value;
                  });
                },
              ),
            ),
            Text(
              _padding.toStringAsFixed(1),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),

            /// 标题文字大小设置
            Text('标题文字大小', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 4),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _fontSizeOptions.entries.map((entry) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _titleFontSize = entry.value;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _titleFontSize == entry.value
                            ? Colors.blue
                            : Colors.grey[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            color: _titleFontSize == entry.value
                                ? Colors.white
                                : Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            /// 内容文字大小设置
            Text('内容文字大小', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 4),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _fontSizeOptions.entries.map((entry) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _contentFontSize = entry.value;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _contentFontSize == entry.value
                            ? Colors.blue
                            : Colors.grey[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            color: _contentFontSize == entry.value
                                ? Colors.white
                                : Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                widget.onValueChanged(
                  _cornerRadius,
                  _padding,
                  _titleFontSize,
                  _contentFontSize,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('应用更改'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
