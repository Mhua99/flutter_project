import 'package:flutter/material.dart';
import "./demo25/main.dart";
import 'demo25/provider/global_state.dart';
import 'demo25/services/datebase.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await DatabaseHelper().initDatabase();
    print('Database initialized successfully');
  } catch (e) {
    print('Failed to initialize database: $e');
  }

  // 提前创建并初始化 GlobalState
  final globalState = GlobalState();
  /// 初始化用户 信息
  globalState.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => globalState, // 使用已初始化的实例
      child: MyApp(),
    ),
  );
}
