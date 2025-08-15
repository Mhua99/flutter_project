import 'dart:async';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _globalKey = GlobalKey<AnimatedListState>();
  bool flag = true;
  List<String> list = ["第一条", "第二条"];

  Widget _buildItem(index) {
    return ListTile(
      key: ValueKey(index),
      title: Text(list[index]),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          // 执行删除
          _deleteItem(index);
        },
      ),
    );
  }

  _deleteItem(index) {
    if (flag == true) {
      flag = false;
      //执行删除
      _globalKey.currentState!.removeItem(index, (context, animation) {
        var removeItem = _buildItem(index);
        // 数组中删除数据
        list.removeAt(index);
        /**
         * ScaleTransition 是 Flutter 中用于实现缩放动画的组件
         */
        return ScaleTransition(
          // opacity: animation,
          scale: animation,
          // 删除的时候执行动画的元素
          child: removeItem,
        );
      });
      // 500 毫秒后，flag 恢复为 true
      Timer.periodic(const Duration(milliseconds: 500), (timer) {
        flag = true;
        // 停止定时器
        timer.cancel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          list.add("我是新增的数据");
          /**
           * insertItem 的主要作用确实是触发动画插入，而不是直接操作数据。(只是通知 UI 层需要在某个位置显示新项并播放动画)
           * 1. 在指定索引位置插入一个新项
           * 2. 触发从 0 到 1 的动画过程
           * 3. 调用 itemBuilder 来构建要显示的 Widget
           */
          _globalKey.currentState!.insertItem(list.length - 1);
        },
      ),
      /**
       * AnimatedList 是一个可以为列表项的插入和删除操作添加动画效果的组件。与普通的 ListView 不同，它专门设计用于需要动态添加或删除列表项并带有动画效果的场景
       */
      body: AnimatedList(
        key: _globalKey,
        initialItemCount: list.length,
        itemBuilder: ((context, index, animation) {
          /**
           * Flutter 内置的淡入淡出动画组件
           */
          return FadeTransition(opacity: animation, child: _buildItem(index));
        }),
      ),
    );
  }
}
