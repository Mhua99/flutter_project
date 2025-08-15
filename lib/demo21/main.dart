import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(title: const Text('login page')),
      body: Column(
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
                left: 170,
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.grey, // 阴影颜色
                        offset: Offset(2, 2), // 阴影偏移量 (x, y)
                        blurRadius: 3, // 阴影模糊半径
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
                    SizedBox(height: 20),
                    Text(
                      "忘记密码",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
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
                  child: Text("提示", style: TextStyle(fontSize: 14, color: Colors.black54),)
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
              child: TextField(
                decoration: InputDecoration(
                  hintText: "请输入用户名",
                  hintStyle: TextStyle(color: Colors.black45),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.check_circle, color: Colors.green),
          ),
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
              child: TextField(
                decoration: InputDecoration(
                  hintText: "请输入密码",
                  hintStyle: TextStyle(color: Colors.black45),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
