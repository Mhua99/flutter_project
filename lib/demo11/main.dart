import 'package:flutter/material.dart';
import './pages/tabs.dart';
import './pages/search.dart';
import './pages/news.dart';
import './pages/form.dart';
import './pages/shop.dart';

class MyApp extends StatelessWidget {
  // 定义路由
  static final Map<String, Function> routes = {
    "/": (contxt) => const Tabs(),
    "/news": (contxt) => const NewsPage(),
    "/search": (contxt) => const SearchPage(),
    "/form": (contxt, {arguments}) => FormPage(arguments: arguments),
    "/shop": (contxt, {arguments}) => ShopPage(arguments: arguments),
  };

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      // 初始路由
      initialRoute: "/",
      /**
       * onGenerateRoute 用于自定义路由生成逻辑
       */
      onGenerateRoute: (RouteSettings settings) {
        // 路由路径 /news
        final String? name = settings.name;
        // 获取路径
        final Function? pageContentBuilder = routes[name];

        if (pageContentBuilder != null) {
          if (settings.arguments != null) {
            // 跳转页面带参数
            final Route route = MaterialPageRoute(
              builder: (context) => pageContentBuilder(context, arguments: settings.arguments),
            );
            return route;
          } else {
            // 1. 创建 MaterialPageRoute 实例
            final Route route = MaterialPageRoute(
              // builder 函数定义如何构建目标页面
              builder: (context) => pageContentBuilder(context),
            );

            return route;
          }
        }
        return null;
      },
    );
  }
}
