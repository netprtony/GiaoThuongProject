import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginResponse {
  final String message;
  final String token;
  final List<String> role;

  const LoginResponse({
    required this.message,
    required this.token,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      role: List<String>.from(json['role'] ?? []),
    );
  }
}

class LoginService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<LoginResponse?> login(String username, String password) async {
    const String apiUrl = 'http://192.168.0.108:3000/api/auth/login';
    
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(data);

      // Lưu token và role vào Secure Storage
      await _storage.write(key: 'token', value: loginResponse.token);
      await _storage.write(
        key: 'role',
        value: loginResponse.role.isNotEmpty ? loginResponse.role[0] : null,
      );

      return loginResponse;
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      print("Lỗi đăng nhập: ${errorData['message']}");
      return null;
    }
  }
}
