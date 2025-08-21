import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/screens/tabs/home/views.dart';
import 'package:flutter_project/demo25/services/datebase.dart';
import 'package:provider/provider.dart';

import '../../model/notes.dart';
import '../../provider/global_state.dart';
import '../../utils/date.dart';
import 'home/note_add_edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  var _userInfo;

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];
  int _page = 1;
  int _totalCount = 0;
  bool _isLoading = false;
  List<String> _categoryList = ['全部'];
  int _selectedCategoryIndex = 0;
  bool _isHasMore = true;

  /// 1. HomeScreen initState - 页面初始化
  /// 2. HomeScreen build - 页面构建
  /// 3. 跳转其他页面后，HomeScreen 暂停，但不销毁
  /// 4. 返回上一页 HomeScreen 恢复，但不会重新 build
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        final globalState = Provider.of<GlobalState>(context, listen: false);
        final currentUser = globalState.currentUser;

        if (currentUser != null) {
          setState(() {
            _userInfo = currentUser;
          });
          _loadNotes(createdUserId: currentUser.id!);
          _getCategoryList(currentUser.id!);
        }
      } catch (e) {
        /// 处理可能的异常
        print('加载用户信息失败: $e');
      }
    });
  }

  @override
  void dispose() {
    /// 释放资源
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _getCategoryList(int currentUserId) async {
    final categoryList = await _databaseHelper.getAllCategories(currentUserId);
    var temp = categoryList.map((category) {
      return category.name;
    }).toList();
    setState(() {
      _categoryList = ['全部', ...temp];
    });
  }

  /// 刷新分类
  void refreshCategoryList() {
    _getCategoryList(_userInfo.id);
  }

  /// 查询数据
  _loadNotes({bool isRefresh = false, required int createdUserId}) async {
    setState(() {
      !isRefresh && (_isLoading = true);
    });
    try {
      final title = _searchController.text.trim();

      final res = await _databaseHelper.getNotesWithCount(
        category: _selectedCategoryIndex == 0
            ? null
            : _categoryList[_selectedCategoryIndex],
        title: title == '' ? null : title,
        page: _page,
        createdUserId: createdUserId,
      );

      /// 添加1秒延时后再更新UI
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

  /// 下拉刷新方法
  Future<void> _refreshNotes() async {
    if (_totalCount > 10) {
      _page = 1;
      _notes = [];
      _isHasMore = true;
      await _loadNotes(isRefresh: true, createdUserId: _userInfo.id);
    }
  }

  /// 加载更多数据
  void _loadMoreNotes() {
    if (_isHasMore) {
      _page++;
      _loadNotes(createdUserId: _userInfo.id);
    }
  }

  /// 搜索
  void _searchNotes() {
    _page = 1;
    _notes = [];
    _isHasMore = true;
    _loadNotes(createdUserId: _userInfo.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text("记事本", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              /// 搜索框
              _searchInput(),

              /// 分类
              _getCategory(),
              SizedBox(height: 8),
              if (_notes.isEmpty && !_isLoading)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.note_alt_outlined,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          '暂无笔记',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '点击右下角"+"创建新笔记',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
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
          final res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (content) =>
                  AddEditScreen(categoryList: _categoryList.sublist(1)),
            ),
          );
          if (res is Note) {
            _page = 1;
            _notes = [];
            _isHasMore = true;
            _loadNotes(createdUserId: _userInfo.id);
          }
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }

  Expanded _getContent() {
    return Expanded(
      /// RefreshIndicator 下拉刷新
      child: RefreshIndicator(
        // strokeWidth: 0.01,
        // color: Colors.transparent, // 设置颜色为透明
        // backgroundColor: Colors.transparent, // 设置背景为透明
        // // 设置位移使其不在可视区域
        // edgeOffset: 900,
        onRefresh: _refreshNotes,
        // 设置刷新回调方法
        /// NotificationListener 是一个 Widget，用于监听从子组件树中冒泡上来的通知。它允许你在通知冒泡过程中捕获并处理这些通知
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            /// 监听滚动事件，实现上拉加载
            if (notification is ScrollEndNotification) {
              final metrics = notification.metrics;

              if (metrics.pixels == metrics.maxScrollExtent && _isHasMore) {
                _loadMoreNotes();

                /// 通知被消费，停止传递
                return true;
              } else if (metrics.pixels == metrics.maxScrollExtent &&
                  !_isHasMore) {
                /// 使用 SnackBar 提示
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.info, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          "数据已全部加载完毕",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 1),
                    backgroundColor: Colors.black54,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.fromLTRB(100, 0, 100, 16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

                    /// elevation 属性定义了组件相对于其父组件的z轴高度，值越大组件看起来越"浮"在屏幕上，阴影也越明显。
                    elevation: 6,
                  ),
                );
                return true;
              }
            }
            return false;
          },
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
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
                      builder: (context) => ViewsPage(
                        note: note,
                        categoryList: _categoryList.sublist(1),
                      ),
                    ),
                  );
                  if (res == true) {
                    _loadNotes(createdUserId: _userInfo.id);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[200] ?? Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题行 - 左侧小圆点
                        Row(
                          children: [
                            // 颜色小圆点
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 10),
                            // 标题
                            Expanded(
                              child: Text(
                                note.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // 内容预览
                        Text(
                          note.content,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 16),
                        // 底部信息
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            SizedBox(width: 4),
                            Text(
                              DateFormat.formatDateTime(note.dateTime),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.folder_outlined,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            SizedBox(width: 4),
                            Text(
                              note.category,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                            ),
                            // 更多操作按钮
                            // Icon(
                            //   Icons.more_horiz,
                            //   size: 20,
                            //   color: Colors.grey[400],
                            // ),
                          ],
                        ),
                      ],
                    ),
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
        color: Colors.black.withOpacity(0.1),
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
                  _searchNotes();
                },
              ),
              // 聚焦时的边框颜色
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blue, width: 1.5),
              ),
              // 未聚焦时的边框颜色
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.grey[300] ?? Colors.grey,
                  width: 1,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
                _searchNotes();
              });
            },
            child: Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: _selectedCategoryIndex == index
                    ? Colors.blue
                    : Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _categoryList[index],
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
        },
      ),
    );
  }
}
