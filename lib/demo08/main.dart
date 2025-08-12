import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({super.key});

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage>
    with SingleTickerProviderStateMixin {
  // _tabController 是用来关联 TabBar 和 TabBarView 的控制器
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          // 左侧的按钮图标
          icon: Icon(Icons.menu),
          onPressed: () {
            print("左侧的按钮图标");
          },
        ),
        // 导航背景颜色
        backgroundColor: Colors.blue,
        // 文字颜色
        foregroundColor: Colors.white,
        // 标题
        title: Text("Flutter App"),
        // 居中
        centerTitle: true,
        actions: [
          //右侧的按钮图标
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print("搜索图标");
            },
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              print("更多");
            },
          ),
        ],
        bottom: TabBar(
          // 是否可滚动
          isScrollable: true,
          // 下方指示器颜色
          indicatorColor: Colors.white,
          // 下方指示器高度
          indicatorWeight: 2,
          indicatorPadding: EdgeInsets.all(5),
          // 选中文字下方横线的长度
          // indicatorSize:TabBarIndicatorSize.tab,
          // 选中文字颜色
          labelColor: Colors.yellow,
          // 未选中文字颜色
          unselectedLabelColor: Colors.white,
          // 选中文字
          labelStyle: TextStyle(fontSize: 14),
          // 未选中文字
          unselectedLabelStyle: TextStyle(fontSize: 12),
          // indicator: BoxDecoration(
          //   color: Colors.red,
          //   borderRadius: BorderRadius.circular(10),
          // ),
          controller: _tabController,
          tabs: [
            Tab(child: Text("关注1")),
            Tab(child: Text("关注2")),
            Tab(child: Text("关注3")),
            Tab(child: Text("关注4")),
            Tab(child: Text("关注5")),
            Tab(child: Text("关注6")),
            Tab(child: Text("关注7")),
            Tab(child: Text("关注8")),
            Tab(child: Text("关注9")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Text("我是关注1"),
          Text("我是关注2"),
          Text("我是关注3"),
          Text("我是关注4"),
          Text("我是关注5"),
          Text("我是关注6"),
          Text("我是关注7"),
          ListView(
            children: [
              ListTile(title: Text("我是热门列表")),
              ListTile(title: Text("我是热门列表")),
              ListTile(title: Text("我是热门列表")),
              ListTile(title: Text("我是热门列表")),
              ListTile(title: Text("我是热门列表")),
              ListTile(title: Text("我是热门列表")),
              ListTile(title: Text("我是热门列表")),
            ],
          ),
          ListView(children: [ListTile(title: Text("我是视频列表"))]),
        ],
      ),
    );
  }
}
