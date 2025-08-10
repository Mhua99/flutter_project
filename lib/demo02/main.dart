import 'package:flutter/material.dart';
import 'package:flutter_project/demo02/pages/onboard.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     // 禁用调试横幅。在调试模式下，Flutter 默认会在应用右上角显示一个调试 banner，设置为 false 可以隐藏这个 banner。
     debugShowCheckedModeBanner: false,
     // 应用首页界面 作为应用启动后显示的第一个页面。
     home: PetsOnBoardingScreen()
   );
  }
}