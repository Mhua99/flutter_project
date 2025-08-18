import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/screens/views.dart';
import 'package:flutter_project/demo25/services/datebase.dart';

import '../model/notes.dart';
import '../utils/date.dart';
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
  int _page = 1;
  int _totalCount = 0;
  bool _isLoading = false;
  final List<String> _spaceCategory = ['全部', 'js', 'html', 'vue', 'other'];
  int _selectedCategoryIndex = 0;
  bool _isHasMore = true;

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
  _loadNotes({bool isRefresh = false}) async {
    setState(() {
      !isRefresh && (_isLoading = true);
    });
    try {
      final title = _searchController.text.trim();

      final res = await _databaseHelper.getNotesWithCount(
        category: _selectedCategoryIndex == 0
            ? null
            : _spaceCategory[_selectedCategoryIndex],
        title: title == '' ? null : title,
        page: _page,
      );
      // 添加1秒延时后再更新UI
      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _notes = [..._notes, ...res.notes];
        _totalCount = res.totalCount;
        if (_notes.length >= _totalCount) {
          _isHasMore = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 下拉刷新方法
  Future<void> _refreshNotes() async {
    _page = 1;
    _notes = [];
    _isHasMore = true;
    await _loadNotes(isRefresh: true);
  }

  // 加载更多数据
  void _loadMoreNotes() {
    if (_isHasMore) {
      _page++;
      _loadNotes();
    }
  }

  /// 搜索
  void _searchNotes() {
    _page = 1;
    _notes = [];
    _isHasMore = true;
    _loadNotes();
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
      body: Stack(
        children: [
          Column(
            children: [
              /// 搜索框
              _searchInput(),
              // 分类
              _getCategory(),
              SizedBox(height: 8),
              if (_notes.isEmpty && !_isLoading)
                Expanded(child: Center(child: Text('暂无数据')))
              else
                _getContent(),
              SizedBox(height: 8),
            ],
          ),
          if (_isLoading) _buildLoadingIndicator(),
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

  Expanded _getContent() {
    return Expanded(
      child: RefreshIndicator(
        // strokeWidth: 0.01,
        // color: Colors.transparent, // 设置颜色为透明
        // backgroundColor: Colors.transparent, // 设置背景为透明
        // // 设置位移使其不在可视区域
        // edgeOffset: 900,
        onRefresh: _refreshNotes, // 设置刷新回调方法
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            // 监听滚动事件，实现上拉加载
            if (notification is ScrollEndNotification && _isHasMore) {
              final metrics = notification.metrics;

              if (metrics.pixels == metrics.maxScrollExtent) {
                _loadMoreNotes();
                return true;
              }
            }
            return false;
          },
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
                        style: TextStyle(fontSize: 14, color: Colors.white70),

                        /// 最多显示四行
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Text(
                        DateFormat.formatDateTime(note.dateTime),
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
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Container(
        color: Colors.black.withOpacity(0.4), // 稍深一点的背景
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3.0,
            ),
            SizedBox(height: 16),
            Text(
              '加载中...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchInput() {
    return Padding(
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
                  _searchNotes();
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
    );
  }

  Widget _getCategory() {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_spaceCategory.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
                _searchNotes();
              });
            },
            child: Container(
              height: 40,
              width: 60,
              decoration: BoxDecoration(
                color: _selectedCategoryIndex == index
                    ? Colors.blue
                    : Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _spaceCategory[index],
                  style: TextStyle(
                    color: _selectedCategoryIndex == index
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
