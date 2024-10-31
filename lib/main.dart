/* import 'package:giaothuong/Component/Home/login.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'Trang chủ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const Login(),
    );
  }
} */
/* import 'package:flutter/material.dart';
import 'package:giaothuong/Component/Home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giao Thương',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(role: 'user', token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NzFlNDViYmUyZmY3MGQZWI4MDA5YmQiLCJpYXQiOjE3MzAwMzcxODYsImV4cCI6MTczMDA0MDc4Nn0.b5warlv85VjiZO0xy0w4obNi5dSdNG_7GOdCLM8k72Y'), // Thay đổi 'your_token' bằng token thích hợp nếu có
    );
  }
} */
import 'package:flutter/material.dart';
import 'package:giaothuong/Component/Admin/dash_board_admin.dart';
import 'package:http/http.dart' as http;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gọi API tạo tài khoản admin
  await createAdminAccount();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AdminDashboardScreen(role: 'admin', token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NzFmM2Q5ZTMzYTBjMDE3MzU3MDQ2MDMiLCJpYXQiOjE3MzAzNjUxNzYsImV4cCI6MTczMDM2ODc3Nn0.LD1gPyYu55lUycThYDRFj7PKJdU3fSVio877x_GQkUk'),
    );
  }
}

Future<void> createAdminAccount() async {
  try {
    final response = await http.post(
      Uri.parse('192.168.0.108:3000/api/admin/createAdmin'), // Địa chỉ API của bạn
    );

    if (response.statusCode == 200) {
      print('Tài khoản admin đã được tạo thành công.');
    } else {
      print('Có lỗi xảy ra khi tạo tài khoản admin: ${response.body}');
    }
  } catch (e) {
    print('Lỗi kết nối: $e');
  }
}



