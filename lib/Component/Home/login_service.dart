import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

  Future<bool> _isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<LoginResponse?> login(String username, String password) async {
    const String apiUrl = 'http://192.168.1.67:3000/api/auth/login';

    // Kiểm tra kết nối mạng trước khi gửi yêu cầu
    if (!await _isConnected()) {
      print("Không có kết nối mạng. Vui lòng kiểm tra lại kết nối.");
      return null;
    }

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'username': username,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(data);

        // Lưu token và vai trò vào Secure Storage
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
    } on TimeoutException catch (_) {
      print("Kết nối hết thời gian. Vui lòng thử lại sau.");
      return null;
    } catch (e) {
      print("Đã xảy ra lỗi: $e");
      return null;
    }
  }
}
