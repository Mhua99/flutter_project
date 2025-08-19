class DateFormat {
  static String formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return "今天，${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    }
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  static int calculateRegistrationDays(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      return 0;
    }

    try {
      // 解析创建时间字符串
      DateTime registrationDate;

      // 处理不同的日期格式
      if (createdAt.contains('T')) {
        // ISO 8601 格式 (2023-01-15T10:30:00)
        registrationDate = DateTime.parse(createdAt);
      } else {
        // SQLite datetime 格式 (2023-01-15 10:30:00)
        registrationDate = DateTime.parse(createdAt);
      }

      // 获取当前日期
      DateTime now = DateTime.now();

      // 计算天数差
      Duration difference = now.difference(registrationDate);
      return difference.inDays;
    } catch (e) {
      print('解析日期时出错: $e');
      return 0;
    }
  }
}
