import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../model/user.dart';
import '../../../provider/global_state.dart';
import '../../../services/datebase.dart';

class ProfileScreen extends StatefulWidget {
  final User userInfo;

  const ProfileScreen({super.key, required this.userInfo});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// 数据库
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// 控制器
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  /// 表单状态
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  /// 添加密码可见性状态
  bool _isPasswordVisible = false;

  /// 选择的头像文件
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // 初始化控制器
    _usernameController.text = widget.userInfo.username;
    _passwordController.text = widget.userInfo.password;
    _emailController.text = widget.userInfo.email ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("触发");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(
          _isEditing ? "编辑个人资料" : "个人资料",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: Text(
                "保存",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 头像区域
              _buildAvatarSection(),

              SizedBox(height: 10),

              _buildReadOnlyItem(),

              SizedBox(height: 14),

              // 基本信息区域
              _buildBasicInfoSection(),

              SizedBox(height: 15),

              // 账号信息区域
              if (_isEditing) ...[_buildSaveButton()],
            ],
          ),
        ),
      ),
    );
  }

  // 构建头像区域
  Widget _buildAvatarSection() {
    return Column(
      children: [
        Stack(
          children: [
            // 头像
            CircleAvatar(
              radius: 60,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : AssetImage(
                          widget.userInfo.avatar ?? 'assets/demo25/logo1.png',
                        )
                        as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),

            // 编辑头像按钮（仅在编辑模式下显示）
            if (_isEditing)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    onPressed: _pickImage,
                  ),
                ),
              ),
          ],
        ),

        if (_isEditing)
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "点击头像更换照片",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  // 构建基本信息区域
  Widget _buildBasicInfoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "基本信息",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),

          _buildInfoItem(
            icon: Icons.person_outline,
            label: "用户名",
            controller: _usernameController,
            hintText: "请输入用户名",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '用户名不能为空';
              }
              if (value.length < 3) {
                return '用户名长度不能少于3位';
              }
              return null;
            },
          ),

          SizedBox(height: 15),

          _buildInfoItem(
            icon: Icons.lock_outline,
            label: "密码",
            controller: _passwordController,
            hintText: "请输入密码",
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            isShowPassword: _isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '密码不能为空';
              }
              return null;
            },
          ),

          SizedBox(height: 15),

          _buildInfoItem(
            icon: Icons.email_outlined,
            label: "邮箱",
            controller: _emailController,
            hintText: "请输入邮箱",
          ),
        ],
      ),
    );
  }

  // 构建信息输入项
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool isShowPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        if (_isEditing)
          TextFormField(
            controller: controller,
            obscureText: obscureText && isShowPassword,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300] ?? Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300] ?? Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
              // 添加密码可见性切换图标
              suffixIcon: obscureText
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
            ),
            validator: validator,
            keyboardType: keyboardType,
          )
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300] ?? Colors.grey),
            ),
            child: Text(
              obscureText ? "******" : controller.text,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
      ],
    );
  }

  // 构建只读信息项
  Widget _buildReadOnlyItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 10),
        Text(
          "注册时间：",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 10),
        Text(
          "2023-10-10",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // 构建保存按钮
  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          "保存修改",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 选择图片
  Future<void> _pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        Fluttertoast.showToast(msg: "头像选择成功");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "选择图片失败");
    }
  }

  // 保存个人资料
  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      User userInfo = User(
        id: widget.userInfo.id,
        username: _usernameController.text,
        password: _passwordController.text,
        avatar: "assets/demo25/logo1.png",
        email: _emailController.text,
      );

      try {
        await _databaseHelper.updateUser(userInfo);
        Fluttertoast.showToast(msg: "个人资料保存成功");

        /// 全局保存用户信息
        final globalState = Provider.of<GlobalState>(context, listen: false);
        globalState.setCurrentUser(userInfo);

        setState(() {
          _isEditing = false;
        });
      } catch (e) {
        Fluttertoast.showToast(msg: "保存个人资料失败");
      }
    }
  }
}
