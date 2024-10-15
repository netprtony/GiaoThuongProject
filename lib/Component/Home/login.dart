import 'package:flutter/material.dart';
import 'package:giaothuong/Component/Admin/dash_board_admin.dart';
import 'package:giaothuong/Component/Home/home.dart';
import 'package:giaothuong/Component/Home/signup.dart';
import 'package:giaothuong/Component/Home/login_service.dart';  

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final LoginService _loginService = LoginService();

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tài khoản và mật khẩu không được để trống'),
        ),
      );
      return;
    }

    try {
      final response = await _loginService.login(username, password);

      if (response != null && response.authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công. Vai trò: ${response.role}')),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token: ${response.token}')),
        );
        // Navigate to different pages based on the role
        if (response.role.contains('ADMIN')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminDashboardScreen(),
            ),
          );
        } else if (response.role.contains('MANAGER') || response.role.contains('USER')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(role: response.role, token: response.token),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thất bại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 197, 216, 236),
                  Color.fromARGB(255, 25, 117, 215),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Column(
                children: [
                  const Text(
                    'Hệ thống đăng nhập',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100.0, // chiều rộng
                      height: 100.0, // chiều cao
                      fit: BoxFit.cover, // phương thức fit để đảm bảo hình ảnh không bị biến dạng
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                      prefixIcon: const Icon(Icons.person, color: Color.fromARGB(255, 0, 0, 0)),
                      labelText: 'Tài khoản',
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                      prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 0, 0, 0)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      labelText: 'Mật khẩu',
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 0, 92, 250),
                      foregroundColor: const Color.fromARGB(255, 8, 8, 8),
                    ),
                    child: const Text('Đăng nhập'),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Chưa có tài khoản?',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },
                        child: const Text(
                          'Đăng ký ngay',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 13, 254),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
