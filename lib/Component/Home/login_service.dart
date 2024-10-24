import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginResponse {
  final bool authenticated;
  final String role;
  final String token;

  const LoginResponse({
    required this.authenticated,
    required this.role,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      authenticated: json['authenticated'] ?? false,
      role: json['role'] ?? 'user',
      token: json['token'] ?? '',
    );
  }
}

class LoginService {
  // Khởi tạo Secure Storage với const
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
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(data);
      
      // Lưu token vào Secure Storage
      await _storage.write(key: 'token', value: loginResponse.token);
      
      return loginResponse;
    } else {
      return null; // Xử lý lỗi nếu không phải 200 OK
    }
  }
}
