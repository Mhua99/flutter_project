import 'package:flutter/material.dart';
import '../pages/tabs.dart';
import '../pages/search.dart';
import '../pages/news.dart';
import '../pages/form.dart';
import '../pages/shop.dart';

//1、配置路由
Map routes = {
  "/": (contxt) => const Tabs(),
  "/news": (contxt) => const NewsPage(),
  "/search": (contxt) => const SearchPage(),
  "/form": (contxt, {arguments}) => FormPage(arguments: arguments),
  "/shop": (contxt, {arguments}) => ShopPage(arguments: arguments),
};

//2、配置onGenerateRoute  固定写法  这个方法也相当于一个中间件，这里可以做权限判断
var onGenerateRoute = (RouteSettings settings) {
  // 路径 /news
  final String? name = settings.name;
  // 获取跳转页面的方法
  final Function? pageContentBuilder = routes[name];

  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      // 有参跳转
      final Route route = MaterialPageRoute(
        builder: (context) =>
            pageContentBuilder(context, arguments: settings.arguments),
      );
      return route;
    } else {
      // 无参跳转
      final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context),
      );
      return route;
    }
  }
  return null;
};
