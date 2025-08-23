import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/screens/tabs/my/profile.dart';
import 'package:flutter_project/demo25/services/datebase.dart';
import 'package:flutter_project/demo25/utils/token.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../provider/global_state.dart';
import '../../utils/date.dart';
import '../login.dart';
import 'my/about.dart';
import 'my/backup.dart';
import 'my/category.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  var _userInfo;
  int _categoryCount = 0;
  int _noteCount = 0;
  int _dayCount = 0;

  /// 是否新增编辑了分类数据
  bool isAddCategory = false;

  @override
  void initState() {
    super.initState();

    /// 使用 Future.microtask 确保在下一帧执行，避免 context 问题
    /// 在 initState 中直接使用 context 可能导致问题。initState 在 widget 完全构建之前执行，此时 context 可能还没有完全准备好
    Future.microtask(() async {
      try {
        final globalState = Provider.of<GlobalState>(context, listen: false);
        final currentUser = globalState.currentUser;

        if (currentUser != null) {
          setState(() {
            _userInfo = currentUser;
          });
          await _loadData(currentUser);
        }
      } catch (e) {
        /// 处理可能的异常
        print('加载用户信息失败: $e');
      }
    });
  }

  Future<void> _loadData(User user) async {
    try {
      /// 并行执行数据库查询以提高性能
      final results = await Future.wait([
        _databaseHelper.getCategoryCount(user.id ?? 0),
        _databaseHelper.getNoteCount(user.id ?? 0),
      ]);

      final categoryCount = results[0];
      final noteCount = results[1];
      final dayCount = DateFormat.calculateRegistrationDays(user.createdAt);

      /// 只在数据发生变化时更新UI
      if (mounted) {
        setState(() {
          _categoryCount = categoryCount;
          _noteCount = noteCount;
          _dayCount = dayCount;
        });
      }
    } catch (e) {
      print('加载统计数据失败: $e');
    }
  }

  void onPageVisible() {
    _loadData(_userInfo);
  }

  @override
  Widget build(BuildContext context) {
    /// 每次构建页面时都清除焦点
    FocusManager.instance.primaryFocus?.unfocus();

    if (_userInfo == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text("个人中心", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 用户信息区域
            _buildUserInfoSection(_userInfo),

            /// 功能列表区域
            _buildFunctionListSection(_userInfo),

            /// 退出登录按钮
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  /// 获取头像图片提供器
  ImageProvider _getAvatarImageProvider(userInfo) {
    String? avatarPath = userInfo.avatar;

    /// 如果没有头像路径，使用默认资源图片
    if (avatarPath == null || avatarPath.isEmpty) {
      return AssetImage('assets/demo25/logo1.png');
    }

    /// 判断路径类型
    if (avatarPath.startsWith('/') || avatarPath.startsWith('file:')) {
      /// 文件路径
      try {
        File file = File(avatarPath);
        if (file.existsSync()) {
          return FileImage(file);
        } else {
          return AssetImage('assets/demo25/logo1.png');
        }
      } catch (e) {
        return AssetImage('assets/demo25/logo1.png');
      }
    } else {
      /// 资源路径
      return AssetImage(avatarPath);
    }
  }
  Widget _buildUserInfoSection(userInfo) {
    return Container(
      /// double.infinity 表示一个无限大的数值，在 Flutter 中用来表示"尽可能大"或"填充可用空间"。
      /// Widget 将尽可能占据其父容器的全部宽度 让组件横向撑满可用空间
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          /// 用户信息区域
          Row(
            children: [
              /// 头像
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _getAvatarImageProvider(userInfo),
                  backgroundColor: Colors.grey[200],
                  child: userInfo.avatar == null
                      ? Icon(Icons.person, size: 40, color: Colors.grey[400])
                      : null,
                ),
              ),

              SizedBox(width: 20),

              /// 用户基本信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 用户名
                    Text(
                      userInfo.username ?? '未知用户',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),

                    /// 用户信息标签
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '普通用户',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    /// 邮箱信息
                    if (userInfo.email != null && userInfo.email.isNotEmpty)
                      Text(
                        userInfo.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          /// 分隔线
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 20),
            color: Colors.grey[200],
          ),

          /// 统计信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(_noteCount.toString(), '笔记'),
              _buildVerticalDivider(),
              _buildStatItem(_categoryCount.toString(), '分类'),
              _buildVerticalDivider(),
              _buildStatItem(_dayCount.toString(), '注册天数'),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建统计项目
  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 垂直分隔线
  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }

  /// 构建功能列表区域
  Widget _buildFunctionListSection(userInfo) {
    List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.person_outline,
        'title': '个人资料',
        'subtitle': '查看和编辑个人信息',
        'onTap': () => _navigateToProfile(userInfo),
      },
      {
        'icon': Icons.category_outlined,
        'title': '分类管理',
        'subtitle': '管理笔记分类',
        'onTap': () => _navigateToCategories(),
      },
      {
        'icon': Icons.backup_outlined,
        'title': '数据备份',
        'subtitle': '备份和恢复数据',
        'onTap': () => _navigateToBackup(),
      },
      {
        'icon': Icons.info_outline,
        'title': '关于我们',
        'subtitle': '版本信息和应用介绍',
        'onTap': () => _navigateToAbout(),
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: menuItems.map((item) => _buildMenuItem(item)).toList(),
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item['icon'], color: Colors.blue),
          ),
          title: Text(
            item['title'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            item['subtitle'],
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[400],
          ),
          onTap: item['onTap'],
        ),
        Divider(height: 1, indent: 70, endIndent: 20, color: Colors.grey[100]),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: ElevatedButton(
        onPressed: _logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          '退出登录',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// 导航方法
  void _navigateToProfile(userInfo) {
    print(userInfo.email);
    print("hello world");

    /// 跳转到个人资料页面
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen(userInfo: userInfo)),
    );
  }

  /// 分类
  void _navigateToCategories() async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CategoryListScreen()),
    );
    isAddCategory = res ?? false;
  }

  /// 数据备份
  void _navigateToBackup() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => BackupScreen()));
  }

  void _navigateToAbout() {
    /// 跳转到关于我们页面
    Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
  }

  /// 退出登录
  void _logout() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("确认退出"),
          content: Text("您确定要退出登录吗？"),
          actions: [
            TextButton(
              /// pop 传入的值，会赋值给 confirm 变量
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
      /// 先导航到登录页面
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );

      /**
       * WidgetsBinding.instance.addPostFrameCallback
       * 作用：将回调函数推迟到当前帧渲染完成后的下一帧执行
       * 时机：在当前build过程完成后，UI渲染完毕后再执
       * 目的：避免在widget构建过程中修改状态导致的冲突
       */
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        /// 清除全局用户信息
        final globalState = Provider.of<GlobalState>(context, listen: false);

        /// notifyListeners() 会通知所有监听者
        /// MyScreen 会收到通知并重新执行 build() 方法
        await globalState.clearUser();

        /// 清除token
        TokenManager.removeToken();
      });
    }
  }
}
