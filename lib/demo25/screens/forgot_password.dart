import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_project/demo25/services/datebase.dart';
import 'package:flutter_project/demo25/model/user.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        /// 检查用户是否存在
        final user = await _databaseHelper.getUserByUsername(
          _usernameController.text,
        );

        if (user == null) {
          Fluttertoast.showToast(msg: "用户不存在");
          return;
        }

        /// 更新密码
        final updatedUser = User(
          id: user.id,
          username: user.username,
          password: _newPasswordController.text,
          email: user.email,
          avatar: user.avatar,
          createdAt: user.createdAt,
        );

        await _databaseHelper.updateUser(updatedUser);

        Fluttertoast.showToast(msg: "密码重置成功");

        /// 返回登录页面
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(msg: "密码重置失败: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("忘记密码", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "重置密码",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "请输入您的用户名和新密码",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 30),

              /// 用户名输入框
              _buildUsernameInput(),
              SizedBox(height: 20),

              /// 新密码输入框
              _buildNewPasswordInput(),
              SizedBox(height: 20),

              /// 确认密码输入框
              _buildConfirmPasswordInput(),
              SizedBox(height: 30),

              /// 重置密码按钮
              _buildResetButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "用户名",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: "请输入用户名",
            hintStyle: TextStyle(color: Colors.grey[700]),
            prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
            prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[800]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入用户名';
            }
            if (value.length < 3) {
              return '用户名长度不能少于3位';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNewPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "新密码",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _newPasswordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: "请输入新密码",
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            hintStyle: TextStyle(color: Colors.grey[700]),
            prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[800]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入新密码';
            }
            if (value.length < 6) {
              return '密码长度不能少于6位';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "确认密码",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          decoration: InputDecoration(
            hintText: "请再次输入新密码",
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            hintStyle: TextStyle(color: Colors.grey[700]),
            prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[800]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请确认密码';
            }
            if (value != _newPasswordController.text) {
              return '两次输入的密码不一致';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _resetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                "重置密码",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
