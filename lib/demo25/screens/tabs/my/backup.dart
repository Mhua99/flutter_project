import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../../services/base_database.dart';
import '../../../utils/const.dart';
import '../../login.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final BaseDatabase _baseDatabase = BaseDatabase();
  List<FileSystemEntity> _backupList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBackupList();
  }

  /// 导出
  Future<void> _exportBackup(File backupFile) async {
    try {
      // 获取外部存储目录
      Directory? externalDir = await _baseDatabase.getBackUpPath;

      // 构建默认导出路径
      final exportDir = Directory('${externalDir?.path}/backup');
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      final fileName = backupFile.path.split('/').last;
      final exportPath = '${exportDir.path}/$fileName';

      // 复制文件到导出目录
      await backupFile.copy(exportPath);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('备份已导出到: $exportPath')));
    } catch (e) {
      print('导出备份失败: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('导出备份失败: $e')));
    }
  }

  Future<void> _loadBackupList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      /// 尝试从外部存储加载备份列表
      List<FileSystemEntity> dbFiles = [];

      if (Platform.isAndroid) {
        try {
          Directory? externalDir = await _baseDatabase.getBackUpPath;
          if (externalDir != null) {
            final backupDir = Directory(externalDir.path);
            if (await backupDir.exists()) {
              final files = backupDir.listSync();
              dbFiles = files
                  .where((file) => file is File && file.path.endsWith('.db'))
                  .toList();
            }
          }
        } catch (e) {
          print('从外部存储加载备份失败: $e');
        }
      }

      /// 按修改时间排序
      dbFiles.sort(
        (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
      );

      setState(() {
        _backupList = dbFiles;
        _isLoading = false;
      });
    } catch (e) {
      print('加载备份列表失败: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('加载备份列表失败')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 添加打开目录的方法
  Future<void> _openBackupDirectory(String filePath) async {
    _selectFileToRestore();
  }

  Future<void> _showBackupDetails(String backupPath) async {
    try {
      final file = File(backupPath);
      if (await file.exists()) {
        final stat = await file.stat();
        final name = backupPath.split('/').last;

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("备份详情"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("文件名: $name"),
                  SizedBox(height: 8),
                  Text("路径: $backupPath"),
                  SizedBox(height: 8),
                  Text("大小: ${_formatFileSize(stat.size)}"),
                  SizedBox(height: 8),
                  Text("创建时间: ${_formatDateTime(stat.modified)}"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("取消"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // 打开文件所在目录
                    _openBackupDirectory(backupPath);
                  },
                  child: Text("打开目录"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('查看备份详情失败: $e');
    }
  }

  Future<void> _createBackup() async {
    // 添加详细的确认对话框
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("创建备份"),
          content: Text("即将创建数据库备份，备份文件将保存在设备存储中，您可以随时访问。确定要继续吗？"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("确定"),
            ),
          ],
        );
      },
    );

    // 只有用户确认后才执行备份
    if (confirm == true) {
      try {
        // 创建数据库备份
        final backupPath = await _baseDatabase.backupDatabase();

        // 刷新列表
        await _loadBackupList();

        // 显示成功信息，包含查看备份文件的操作
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('备份创建成功'),
            action: SnackBarAction(
              label: '查看',
              onPressed: () {
                // 显示备份详情
                _showBackupDetails(backupPath);
              },
            ),
          ),
        );
      } catch (e) {
        print('创建备份失败: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('创建备份失败: $e')));
      }
    }
  }

  Future<void> _restoreBackup(File file) async {
    try {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("确认恢复"),
            content: Text("恢复备份将覆盖当前数据，确定要继续吗？"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("取消"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("确定"),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        // 显示加载指示器
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('正在恢复数据...')));

        try {
          /// 恢复数据库
          await _baseDatabase.restoreDatabase(file.path);
          //
          // ScaffoldMessenger.of(
          //   context,
          // ).showSnackBar(SnackBar(content: Text('数据恢复成功，请重新启动应用')));

          /// 给用户提示信息，建议重启应用
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("恢复完成"),
                content: Text("数据已恢复成功，建议完全关闭并重新启动应用以确保数据正确加载。"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      /// 跳转到登录页
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: Text("确定"),
                  ),
                ],
              );
            },
          );

          // 刷新列表
          await _loadBackupList();
        } catch (e) {
          print('恢复备份失败: $e');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('恢复备份失败: $e')));
        }
      }
    } catch (e) {
      print('恢复过程出错: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('恢复过程出错: $e')));
    }
  }

  Future<void> _selectFileToRestore() async {
    try {
      // 获取 Download 目录路径
      Directory downloadDir = Directory(ConstUtils.backupPath);

      // 检查 Download 目录是否存在，如果不存在则使用默认路径
      if (!await downloadDir.exists()) {
        downloadDir = await getDownloadsDirectory() ?? Directory('');
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        // allowedExtensions: ['db'],
        initialDirectory: downloadDir.path, // 设置初始目录
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        await _restoreBackup(file);
      }
    } catch (e) {
      print('选择文件失败: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('选择文件失败')));
    }
  }

  Future<void> _deleteBackup(File file, String name) async {
    try {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("确认删除"),
            content: Text("确定要删除备份 $name 吗？"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("取消"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("确定", style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        await file.delete();
        await _loadBackupList();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('备份已删除')));
      }
    } catch (e) {
      print('删除备份失败: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除备份失败')));
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('数据备份'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _createBackup,
                    icon: Icon(Icons.add),
                    label: Text('新增备份'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _selectFileToRestore,
                    icon: Icon(Icons.upload),
                    label: Text('导入备份'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _backupList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.backup_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          '暂无备份记录',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '点击"新建备份"按钮创建第一个备份',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _backupList.length,
                    itemBuilder: (context, index) {
                      final file = _backupList[index] as File;
                      final stat = file.statSync();
                      final name = file.path.split('/').last;

                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(name, style: TextStyle(fontSize: 14)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatDateTime(stat.modified),
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _formatFileSize(stat.size),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (String value) {
                              if (value == 'restore') {
                                _restoreBackup(file);
                              } else if (value == 'delete') {
                                _deleteBackup(file, name);
                              } else if (value == 'export') {
                                _exportBackup(file);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 'restore',
                                child: Text('恢复'),
                              ),
                              PopupMenuItem(value: 'delete', child: Text('删除')),
                              // PopupMenuItem(value: 'export', child: Text('导出')),
                            ],
                          ),
                          onTap: () => _restoreBackup(file),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
