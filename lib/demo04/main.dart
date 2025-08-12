import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Button Group"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // 使用主题中预定义的 titleLarge 样式来设置其外观。
                  child: Text("热搜", style: Theme.of(context).textTheme.titleLarge),
                ),
              ],
            ),
            const Divider(),
            Wrap(
              // 元素之间的水平间距
              spacing: 10,
              // 元素之间的垂直间距
              runSpacing: 10,
              children: [
                Button("女装", onPressed: () {}),
                Button("笔记本", onPressed: () {}),
                Button("玩具", onPressed: () {}),
                Button("文学", onPressed: () {}),
                Button("女装", onPressed: () {}),
                Button("时尚", onPressed: () {}),
                Button("男装", onPressed: () {}),
                Button("xxxx", onPressed: () {}),
                Button("手机", onPressed: () {}),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("历史记录", style: Theme.of(context).textTheme.titleLarge),
                ),
              ],
            ),
            const Divider(),
            Column(
              children: const [
                ListTile(title: Text("女装")),
                Divider(),
                ListTile(title: Text("手机")),
                Divider(),
                ListTile(title: Text("电脑")),
                Divider(),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(40),
              child: OutlinedButton.icon(
                // 自适应
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(Colors.black45),
                ),
                onPressed: () {},
                icon: const Icon(Icons.delete),
                label: const Text("清空历史记录"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  // 按钮的文字
  final String text;

  // 方法
  final Function() onPressed;

  const Button(this.text, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          const Color.fromARGB(241, 223, 219, 219),
        ),
        foregroundColor: WidgetStateProperty.all(Colors.black45),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
