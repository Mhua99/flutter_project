import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tab.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<Widget> _navigationFuture;

  @override
  void initState() {
    super.initState();
    _navigationFuture = _checkAndDetermineNextScreen();
  }

  Future<Widget> _checkAndDetermineNextScreen() async {
    try {
      // 立即开始检查登录状态
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      // 可以添加最小等待时间，确保动画完整播放
      final checkResult = (token != null && token.isNotEmpty)
          ? TabsScreen()
          : LoginScreen();

      // 确保至少等待 2 秒（动画时间）
      // await Future.delayed(Duration(seconds: 2));
      return checkResult;
    } catch (e) {
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// AnimatedSplashScreen 第三方启动屏幕组件
    return AnimatedSplashScreen(
      /// 动画
      splash: Center(child: Lottie.asset("assets/demo25/animation/bird.json")),
      /// 动画结束后跳转的页面，使用 FutureBuilder 动态决定
      nextScreen: FutureBuilder<Widget>(
        future: _navigationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // 跳转的页面
            return snapshot.data ?? LoginScreen();
          }
          return LoginScreen();
        },
      ),
      duration: 2000,
      backgroundColor: Colors.white,
      splashIconSize: 260,
    );
  }
}
