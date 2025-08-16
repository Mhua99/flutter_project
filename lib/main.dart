import 'package:flutter/material.dart';
import "./demo25/main.dart";
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqflite.dart';

void main() {
  // 在 runApp() 之前设置
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}
