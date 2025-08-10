import 'package:flutter/material.dart';
import "listData.dart";

class Demo01 extends StatelessWidget {
  const Demo01({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo01',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("首页", style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: const HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: listData.map((value) {
        return Card(
          // 设置 card 圆角角度
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          // 明确指定裁剪行为 （添加这一行，card 顶部两个角才会有圆角的效果）
          clipBehavior: Clip.antiAlias,
          // 表示设置阴影高度为 10 个逻辑像素
          elevation: 10,
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(value["imageUrl"], fit: BoxFit.cover),
              ),
              ListTile(
                // ClipOval 设置图片为圆形
                leading: ClipOval(
                  child: Image.network(
                    value["imageUrl"],
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  ),
                ),
                title: Text(value["title"]),
                subtitle: Text(value["author"]),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
