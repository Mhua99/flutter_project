import 'package:flutter/material.dart';
import './screens/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tesla Animated App",
      /**
         * 配置共同定义了应用的视觉主题，包括整体的明暗风格和主色调
         */
      theme: ThemeData(
        /** brightness
           * 设置主题的亮度模式为浅色（亮色）模式
           * Flutter支持 Brightness.light 和 Brightness.dark 两种模式，这会影响应用的整体外观，包括默认的背景色、文字颜色等。
           */
        brightness: Brightness.light,
        /**
           * primarySwatch
           * 设置应用程序的主要颜色调色板为蓝色。primarySwatch 是一个颜色组，包含从浅到深的不同色调，Flutter会根据这个调色板自动为应用的各个组件生成协调的颜色方案。
           */
        primarySwatch: Colors.blue,
        /**
           * scaffoldBackgroundColor
           * 将背景色设置为纯黑色，这会覆盖主题默认的背景色。
           */
        scaffoldBackgroundColor: Colors.black,
      ),
      home: HomePage(),
    );
  }
}
