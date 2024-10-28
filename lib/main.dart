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
import 'package:flutter/material.dart';
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
}



