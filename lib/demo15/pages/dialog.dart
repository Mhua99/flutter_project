import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/demo15/widget/myDialog.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _myDialog() async {
    var result = await showDialog(
      barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
      context: context,
      builder: (context) {
        return MyDialog(
          title: "提示!",
          content: "我是一个内容",
          onTap: () {
            print("close");
            Navigator.of(context).pop("我是自定义dialog关闭的事件");
          },
        );
      },
    );
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dialog")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _myDialog,
              child: const Text('自定义dialog'),
            ),
            // fluttertoast
          ],
        ),
      ),
    );
  }
}
