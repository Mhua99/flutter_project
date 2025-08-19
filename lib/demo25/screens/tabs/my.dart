import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/screens/tabs/my/profile.dart';
import 'package:flutter_project/demo25/services/datebase.dart';
import 'package:flutter_project/demo25/utils/token.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../provider/global_state.dart';
import '../../utils/date.dart';
import '../login.dart';
import 'my/about.dart';
import 'my/category.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  var _userInfo;
  int _categoryCount = 0;
  int _noteCount = 0;
  int _dayCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final globalState = Provider.of<GlobalState>(context, listen: false);
      setState(() {
        _userInfo = globalState.currentUser;
        print(_userInfo.createdAt);
      });
      _loadData(_userInfo);
    });
  }

  void _loadData(User user) async {
    _categoryCount = await _databaseHelper.getCategoryCount(user.id!);
    _noteCount = await _databaseHelper.getNoteCount(user.id!);
    _dayCount = DateFormat.calculateRegistrationDays(user.createdAt);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            // 用户信息区域
            _buildUserInfoSection(_userInfo),

            // 功能列表区域
            _buildFunctionListSection(_userInfo),

            // 退出登录按钮
            _buildLogoutButton(),
          ],
        ),
      ),
    );
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
          // 头像
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
              userInfo.avatar ?? 'assets/demo25/logo1.png',
            ),
            backgroundColor: Colors.grey[200],
            child: userInfo.avatar == null
                ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                : null,
          ),
          SizedBox(height: 15),

          // 用户名
          Text(
            userInfo.username ?? '未知用户',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),

          // 用户信息
          Text('普通用户', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          SizedBox(height: 15),

          // 统计信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(_noteCount.toString(), '笔记'),
              _buildStatItem(_categoryCount.toString(), '分类'),
              _buildStatItem(_dayCount.toString(), '注册天数'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 3),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  // 构建功能列表区域
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
      // {
      //   'icon': Icons.settings_outlined,
      //   'title': '系统设置',
      //   'subtitle': '应用设置和偏好',
      //   'onTap': () => _navigateToSettings(),
      // },
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

  // 导航方法
  void _navigateToProfile(userInfo) {
    // 跳转到个人资料页面
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen(userInfo: userInfo)),
    );
  }

  /// 分类
  void _navigateToCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CategoryListScreen()),
    );
  }

  void _navigateToSettings() {
    // 跳转到系统设置页面
    Fluttertoast.showToast(msg: "跳转到系统设置页面");
  }

  void _navigateToAbout() {
    // 跳转到关于我们页面
    Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
  }

  // 退出登录
  void _logout() async {
    // 显示确认对话框
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
