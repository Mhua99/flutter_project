import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/model/user.dart';
import 'package:flutter_project/demo25/screens/register.dart';
import 'package:flutter_project/demo25/screens/tab.dart';
import 'package:flutter_project/demo25/utils/token.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../provider/global_state.dart';
import '../services/datebase.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// 添加密码可见性状态
  bool _isPasswordVisible = false;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // 创建控制器
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    /// 设置默认值
    _usernameController.text = 'admin'; // 默认用户名
    _passwordController.text = '123456'; // 默认密码
  }

  @override
  void dispose() {
    /// 释放资源
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login(String username, String password) async {
    User? user = await _databaseHelper.getUserByUsernameAndPassword(
      username,
      password,
    );
    if (user != null) {
      /// 保存token
      TokenManager.saveToken(user.id.toString());

      /// 全局保存用户信息
      final globalState = Provider.of<GlobalState>(context, listen: false);
      globalState.setCurrentUser(user);

      Fluttertoast.showToast(
        msg: "登录成功",
        // toastLength: Toast.LENGTH_SHORT,
        // gravity: ToastGravity.TOP,
        // backgroundColor: Colors.blue,
        // textColor: Colors.white,
        // fontSize: 16.0,
      );
      // Fluttertoast.showToast(msg: "个人资料保存成功");

      /// 延迟1秒，再跳转
      await Future.delayed(Duration(seconds: 1));

      /// 登录成功，跳转到主页面并清除所有之前的页面
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TabsScreen()),
        (route) => false,

        /// 删除所有之前的页面
      );
    } else {
      /// 提示密码错误
      Fluttertoast.showToast(
        msg: "用户名或密码错误",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
                SizedBox(
                  width: size.width,
                  height: size.height / 1.4,
                  child: Image.asset("assets/demo21/1.png", fit: BoxFit.cover),
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Text(
                    "欢迎登录，记事本",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(1, 1),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 180,
                  left: 40,
                  right: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      usernameInput(),
                      SizedBox(height: 20),
                      passwordInput(),
                      SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF6B75CE),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                String username = _usernameController.text;
                                String password = _passwordController.text;
                                login(username, password);
                              }
                            },
                            child: Text(
                              "登录",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "忘记密码？",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(color: Colors.black12, height: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "其他登录方式",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Container(color: Colors.black12, height: 1)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Fluttertoast.showToast(msg: "功能开发中...");
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 90) / 2,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wechat, size: 24, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "微信登录",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      login('test', '123456');
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 90) / 2,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFF6B75CE),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: 24,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "游客访问",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "没有账号？",
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    " 立即注册",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B75CE),
                    ),
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
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Icon(Icons.person_outline, color: Colors.black45, size: 22),
          ),
          Expanded(
            child: TextFormField(
              controller: _usernameController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: "请输入用户名",
                hintStyle: TextStyle(color: Colors.black45, fontSize: 15),
                border: InputBorder.none,

                /// 设置垂直内边距
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '用户名不能为空';
                }
                if (value.length < 3) {
                  return '用户名长度不能少于3位';
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
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Icon(Icons.lock_outline, color: Colors.black45, size: 22),
          ),
          Expanded(
            child: TextFormField(
              obscureText: !_isPasswordVisible,
              controller: _passwordController,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: "请输入密码",
                hintStyle: TextStyle(color: Colors.black45, fontSize: 15),
                border: InputBorder.none,

                /// 设置垂直内边距
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '密码不能为空';
                }
                if (value.length < 6) {
                  return '密码长度不能少于6位';
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
}
