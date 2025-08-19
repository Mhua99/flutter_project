import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // 应用信息
  final Map<String, dynamic> appInfo = {
    'appName': '我的记事本',
    'version': 'v1.0.0',
    'description': '一款简洁易用的笔记记录应用，帮助您随时随地记录生活点滴。',
    'features': [
      '📝 简洁美观的界面设计',
      '📂 分类管理您的笔记',
      '🔍 快速搜索功能',
      '🎨 个性化笔记颜色标记',
      '🔒 安全的本地数据存储',
      '📱 跨设备数据同步（即将支持）',
    ],
    'developer': '记事本开发团队',
    'contactEmail': 'support@mynotes.com',
    'website': 'www.mynotes.com',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text("关于我们", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppInfoSection(),
              Spacer(),
              // Text("version: 1.0.0", style: TextStyle(color: Colors.grey),),
              // SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     spreadRadius: 1,
        //     blurRadius: 10,
        //     offset: Offset(0, 3),
        //   ),
        // ],
      ),
      child: Column(
        children: [
          // 应用Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.note_alt_outlined, size: 40, color: Colors.blue),
          ),
          SizedBox(height: 20),

          // 应用名称
          Text(
            appInfo['appName'],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),

          // 版本号
          Text(
            appInfo['version'],
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 15),

          // 应用描述
          Text(
            appInfo['description'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
