import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginResponse {
  final bool authenticated;
  final String role;
  final String token;

  LoginResponse({required this.authenticated, required this.role, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      authenticated: json['authenticated'],
      role: json['role'], // Chắc chắn rằng API trả về vai trò
      token: json['token'], // Token người dùng
    );
  }
}

class LoginService {
  Future<LoginResponse?> login(String username, String password) async {
    const String apiUrl = 'http://192.168.0.19:3000/api/login'; 
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
      return LoginResponse.fromJson(data);
    } else {
      return null; // Xử lý lỗi nếu không phải 200 OK
    }
  }
}
