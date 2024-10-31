import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String _role = 'user';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await _storage.read(key: 'role');
    setState(() {
      _role = role ?? 'user'; // Mặc định là 'user' nếu không có role lưu trữ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trang chủ')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Chỉ hiển thị nội dung dành cho người dùng
            if (_role == 'user') ...[
              Text('Chào mừng, User!'),
              ElevatedButton(
                onPressed: () {
                  // Chức năng dành cho User
                  // Ví dụ: điều hướng tới trang thông tin cá nhân
                },
                child: Text('Xem thông tin cá nhân'),
              ),
            ] else ...[
              Text('Chức năng này chỉ dành cho người dùng thông thường!'),
            ],
          ],
        ),
      ),
    );
  }
}
