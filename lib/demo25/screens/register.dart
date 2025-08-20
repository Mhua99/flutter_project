import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/model/user.dart';
import 'package:flutter_project/demo25/screens/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/datebase.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// 添加密码可见性状态
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // 创建控制器
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // 释放资源
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void register() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String username = _usernameController.text;
      String password = _passwordController.text;

      // 检查用户名是否已存在
      User? user = await _databaseHelper.getUserByUsername(username);
      if (user != null) {
        Fluttertoast.showToast(
          msg: "用户名已存在，请选择其他用户名",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      // 创建新用户
      User newUser = User(
        username: username,
        email: email,
        password: password,
        avatar: null,
      );

      int? userId = await _databaseHelper.insertUser(newUser);

      if (userId != null) {
        Fluttertoast.showToast(
          msg: "注册成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // 延迟1秒，再跳转
        await Future.delayed(Duration(seconds: 1));
        // 注册成功，跳转到登录页面
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
          msg: "注册失败，请重试",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                // 使用渐变背景替代纯色背景
                Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xFFB8C3FF), // 淡紫蓝色顶部
                        Color(0xFF95A2FF), // 中紫蓝色中部
                        Color(0xFF7986CB), // 深紫蓝色底部
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Text(
                    "欢迎注册",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 130,
                  left: 0,
                  right: 0,
                  child: Text(
                    "我的记事本账户",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Positioned(
                  top: 180,
                  left: 30,
                  right: 30,
                  child: Column(
                    children: [
                      usernameInput(),
                      SizedBox(height: 20),
                      passwordInput(),
                      SizedBox(height: 20),
                      confirmPasswordInput(),
                      SizedBox(height: 35), // 增加间距
                      Container(
                        width: double.infinity,
                        height: 52, // 稍微增加高度
                        decoration: BoxDecoration(
                          color: Colors.white, // 改为白色背景
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              // 调整阴影颜色和透明度
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 13), // 调整内边距
                          child: GestureDetector(
                            onTap: register,
                            child: Text(
                              "注册",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF6B75CE), // 使用主题色
                                fontSize: 21, // 增大字体
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25), // 调整间距
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "已有账户？",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white70, // 调整颜色
                                  ),
                                ),
                                TextSpan(
                                  text: " 立即登录",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // 使用白色
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  usernameInput() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Icon(
              Icons.person_outline,
              color: Color(0xFF6B75CE),
              size: 22,
            ), // 使用主题色
          ),
          Expanded(
            child: TextFormField(
              controller: _usernameController,
              style: TextStyle(fontSize: 16, color: Colors.black87), // 调整文字颜色
              decoration: InputDecoration(
                hintText: "请输入用户名",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '用户名不能为空';
                }
                if (value.length < 3) {
                  return '用户名长度不能少于3位';
                }
                if (value.length > 20) {
                  return '用户名长度不能超过20位';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  passwordInput() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Icon(
              Icons.lock_outline,
              color: Color(0xFF6B75CE),
              size: 22,
            ), // 使用主题色
          ),
          Expanded(
            child: TextFormField(
              obscureText: !_isPasswordVisible,
              controller: _passwordController,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              // 调整文字颜色
              decoration: InputDecoration(
                hintText: "请输入密码",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '密码不能为空';
                }
                if (value.length < 6) {
                  return '密码长度不能少于6位';
                }
                if (value.length > 20) {
                  return '密码长度不能超过20位';
                }
                return null;
              },
            ),
          ),
          IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ],
      ),
    );
  }

  confirmPasswordInput() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Icon(
              Icons.lock_outline,
              color: Color(0xFF6B75CE),
              size: 22,
            ), // 使用主题色
          ),
          Expanded(
            child: TextFormField(
              obscureText: !_isConfirmPasswordVisible,
              controller: _confirmPasswordController,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              // 调整文字颜色
              decoration: InputDecoration(
                hintText: "请确认密码",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请确认密码';
                }
                if (value != _passwordController.text) {
                  return '两次输入的密码不一致';
                }
                return null;
              },
            ),
          ),
          IconButton(
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey[600],
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
        ],
      ),
    );
  }
}
