import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final String token;

  const SettingsScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: const Color(0xFF1975D7), // Màu nền cho AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Cài đặt tài khoản',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Thay đổi mật khẩu
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Thay đổi mật khẩu'),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào
                _showChangePasswordDialog(context);
              },
            ),
            const Divider(),
            // Thông báo
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Thông báo'),
              trailing: Switch(
                value: true, // Giá trị trạng thái thông báo
                onChanged: (value) {
                  // Xử lý khi bật/tắt thông báo
                },
              ),
            ),
            const Divider(),
            // Đăng xuất
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              onTap: () {
                // Xử lý sự kiện đăng xuất
                _logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Hộp thoại để thay đổi mật khẩu
  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController _newPasswordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thay đổi mật khẩu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Xử lý logic thay đổi mật khẩu
                if (_newPasswordController.text == _confirmPasswordController.text) {
                  // Thay đổi mật khẩu thành công
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mật khẩu đã được thay đổi')),
                  );
                  Navigator.of(context).pop(); // Đóng hộp thoại
                } else {
                  // Thông báo nếu mật khẩu không khớp
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mật khẩu không khớp')),
                  );
                }
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  // Hàm đăng xuất
  void _logout(BuildContext context) {
    // Logic đăng xuất (xóa token, quay lại màn hình đăng nhập, v.v.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đăng xuất thành công')),
    );
    Navigator.pop(context); // Quay lại màn hình trước đó
  }
}
