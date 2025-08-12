import 'package:flutter/material.dart';
import 'views/home/home.dart';
import 'views/my/my.dart';
import 'components/tab_item.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        splashColor: Colors.transparent, // 去除底部tab水波纹
        highlightColor: Colors.transparent, // 去除高亮色
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green, // 设置 AppBar 背景色
          foregroundColor: Colors.white, // 设置 AppBar 文字和图标颜色
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.green, // 选中项颜色
          unselectedItemColor: Colors.grey, // 未选中项颜色
        ),
      ),
      home: MyStackPage(),
    );
  }
}

class MyStackPage extends StatefulWidget {
  const MyStackPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyStackPageState();
  }
}

class MyStackPageState extends State<MyStackPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // 选中颜色
        // selectedItemColor: Colors.blue,
        // 未选中颜色
        // unselectedItemColor: Colors.grey,
        // 未选中字体大小
        // unselectedFontSize: 14,
        // type: BottomNavigationBarType.fixed,
        items: [
          TabItem(icon: Icon(Icons.home), label: "首页"),
          TabItem(icon: Icon(Icons.person), label: "我的"),
        ],
        onTap: (index) {
          setState(() {
            // 改变当前选中项
            setState(() {
              _currentIndex = index;
            });
          });
        },
      ),
      /**
       * IndexedStack 所有子组件都会被构建并保留在内存中
       * 只有 index 指定的子组件会显示在屏幕上
       * 当底部导航栏切换时，只改变显示的页面，而不重新构建页面
       */
      body: IndexedStack(index: _currentIndex, children: [Home(), My()]),
    );
  }
}
