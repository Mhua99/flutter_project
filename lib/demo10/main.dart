import 'package:flutter/material.dart';
import './pages/tabs.dart';
import './pages/search.dart';
import './pages/news.dart';
import './pages/form.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      /**
       * initialRoute 默认路由
       * 当应用启动时，Flutter 会查找 routes 表中与 initialRoute 值匹配的路由
       * 如果未设置 initialRoute，默认值为 "/"
       */
      initialRoute: "/",
      // 路由规则
      routes: {
        "/": (contxt) => const Tabs(),
        "/news": (contxt) => const NewsPage(),
        "/search": (contxt) => const SearchPage(),
        "/form": (contxt) {
          return const FormPage();
        },
      },
    );
  }
}
