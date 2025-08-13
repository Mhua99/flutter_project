import 'package:flutter/material.dart';

class RegisterSecondPage extends StatefulWidget {
  const RegisterSecondPage({super.key});

  @override
  State<RegisterSecondPage> createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("注册第二步")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("注册第二步"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                /**
                 * pushNamed 通过路由名称（String 类型）跳转到指定页面。
                 */
                // Navigator.pushNamed(context, "/registerThird");

                /**
                 * 通过路由名称跳转到新页面，并替换当前页面（即移除当前页面）
                 */
                Navigator.of(context).pushReplacementNamed("/registerThird");
              },
              child: const Text("下一步"),
            ),
          ],
        ),
      ),
    );
  }
}
