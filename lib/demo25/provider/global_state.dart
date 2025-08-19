// global_state.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class GlobalState extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  // 初始化用户信息（应用启动时调用）
  Future<void> init() async {
    await _loadUserFromStorage();
  }

  // 从持久化存储加载用户信息
  Future<void> _loadUserFromStorage() async {
    /// SharedPreferences 是Flutter提供的轻量级键值对存储系统
    /// 数据会持久化保存在设备本地，即使应用关闭也不会丢失
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');
    final username = prefs.getString('username');
    final password = prefs.getString('password');
    final avatar = prefs.getString('avatar');

    if (userId != null && username != null && password != null) {
      _currentUser = User(
        id: int.tryParse(userId),
        username: username,
        password: password,
        avatar: avatar,
      );
    }

    notifyListeners();
  }

  // 保存用户信息到持久化存储
  Future<void> _saveUserToStorage(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id?.toString() ?? '');
    await prefs.setString('username', user.username);
    await prefs.setString('password', user.password);
    await prefs.setString('avatar', user.avatar ?? '');
    await prefs.setString('createdAt', user.createdAt ?? '');
  }

  // 设置当前用户并保存到持久化存储
  void setCurrentUser(User user) {
    _currentUser = user;
    _saveUserToStorage(user);
    notifyListeners();
  }

  // 清除用户信息
  Future<void> clearUser() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('avatar');
    notifyListeners();
  }
}
