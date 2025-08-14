//ios风格的路由
import 'package:flutter/cupertino.dart';
import '../pages/tabs.dart';
import '../pages/dialog.dart';
import '../pages/shop.dart';

//1、配置路由
Map routes = {
  "/": (contxt) => const Tabs(),
  "/dialog": (contxt) => const DialogPage(),
  "/shop": (contxt, {arguments}) => ShopPage(arguments: arguments),
};

var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  final Function? pageContentBuilder = routes[name];

  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = CupertinoPageRoute(
        builder: (context) =>
            pageContentBuilder(context, arguments: settings.arguments),
      );
      return route;
    } else {
      final Route route = CupertinoPageRoute(
        builder: (context) => pageContentBuilder(context),
      );

      return route;
    }
  }
  return null;
};
