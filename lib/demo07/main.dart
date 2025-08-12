import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text("Flutter App")),
        drawer: Drawer(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DrawerHeader(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/demo07/2.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 26,
                              backgroundImage: AssetImage(
                                "assets/demo07/3.png",
                              ),
                            ),
                            title: Text(
                              "张三",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "邮箱：xxxx@qq.com",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.people)),
                title: Text("个人中心"),
              ),
              Divider(),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.settings)),
                title: Text("系统设置"),
              ),
              Divider(),
            ],
          ),
        ),
        endDrawer: Drawer(child: Text("右侧侧边栏")),
        body: Text("hello world"),
      ),
    );
  }
}
