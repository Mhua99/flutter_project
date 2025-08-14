import 'package:flutter/material.dart';

class PageViewBuilderPage extends StatefulWidget {
  const PageViewBuilderPage({super.key});

  @override
  State<PageViewBuilderPage> createState() => _PageViewBuilderPageState();
}

class _PageViewBuilderPageState extends State<PageViewBuilderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PageViewBuilder')),
      /**
       * PageView.builder 采用懒加载方式，只在需要时构建页面，提高性能
       * 动态页面生成：通过 itemBuilder 回调函数，根据索引动态创建页面内容
       * 内存优化：只保持当前页面和相邻页面在内存中，减少内存占用 （距离当前页面较远的页面会被销毁以节省内存）
       */
      body: PageView.builder(
        // 设置滚动方向为垂直
        scrollDirection: Axis.vertical,
        // 设置总共有10个页面
        itemCount: 10,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              "第${index + 1}屏",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          );
        },
      ),
    );
  }
}
