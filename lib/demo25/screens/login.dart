import 'package:flutter/material.dart';
import 'package:flutter_project/demo25/model/user.dart';
import 'package:flutter_project/demo25/screens/tab.dart';
import 'package:flutter_project/demo25/utils/token.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../provider/global_state.dart';
import '../services/datebase.dart';
import './tabs/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // 创建控制器
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // 设置默认值
    _usernameController.text = 'admin'; // 默认用户名
    _passwordController.text = '123456'; // 默认密码
  }

  @override
  void dispose() {
    // 释放资源
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
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
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // 延迟1秒，再跳转
      await Future.delayed(Duration(seconds: 1));
      // 登录成功，跳转到主页面并清除所有之前的页面
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TabsScreen()),
        (route) => false, // 删除所有之前的页面
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
                    "欢迎登录，我的记事本",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black, // 阴影颜色
                          offset: Offset(2, 2), // 阴影偏移量 (x, y)
                          blurRadius: 2, // 阴影模糊半径
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 180,
                  left: 65,
                  child: Column(
                    children: [
                      usernameInput(),
                      SizedBox(height: 20),
                      passwordInput(),
                      SizedBox(height: 55),
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF6B75CE),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                login();
                              }
                            },
                            child: Text(
                              "登录",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        width: 300,
                        child: Text(
                          "忘记密码",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(color: Colors.black12, height: 2)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "提示",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black12,
                      width: 100,
                      height: 2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 177,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(Icons.wechat, size: 30, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          "微信",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 177,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFF6B75CE),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(Icons.paypal, size: 30, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          "测试",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "没有账号？"),
                  TextSpan(
                    text: " 立即注册",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B75CE),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  usernameInput() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Icon(Icons.person_outline, color: Colors.black45),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 18, bottom: 3),
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "请输入用户名",
                  hintStyle: TextStyle(color: Colors.black45),
                  border: InputBorder.none,
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
          ),
          // Padding(
          //   padding: EdgeInsets.only(right: 15),
          //   child: Icon(Icons.check_circle, color: Colors.green),
          // ),
        ],
      ),
    );
  }

  passwordInput() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Icon(Icons.lock_open_outlined, color: Colors.black45),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 18, bottom: 3),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "请输入密码",
                  hintStyle: TextStyle(color: Colors.black45),
                  border: InputBorder.none,
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
          ),
        ],
      ),
    );
  }
}
