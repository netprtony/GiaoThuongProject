import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginResponse {
  final String message;
  final String role;
  final String token;

  const LoginResponse({
    required this.message,
    required this.role,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      role: json['role'] ?? 'user',
      token: json['token'] ?? '',
    );
  }
}

class LoginService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<LoginResponse?> login(String username, String password) async {
    const String apiUrl = 'http://127.0.0.1:3000/api/auth/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password, // Gửi mật khẩu gốc
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(data);

      // Lưu token vào Secure Storage
      await _storage.write(key: 'token', value: loginResponse.token);

      return loginResponse;
    } else {
      // Phân tích lỗi từ phản hồi
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      print("Lỗi đăng nhập: ${errorData['message']}");
      return null;
    }
  }
}
