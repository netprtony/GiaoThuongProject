import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

// Class dịch vụ đăng ký
class RegisterService {
  Future<bool> register(String username, String password, String name, String gender, String dob, String phone, String company, String email, String address, String role) async {
    final hashedPassword = hashPassword(password); // Băm mật khẩu trước khi gửi

    final response = await http.post(
      Uri.parse('http://127.0.0.1:3000/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': hashedPassword, // Gửi mật khẩu đã băm
        'name': name,
        'gender': gender,
        'dob': dob,
        'phone': phone,
        'company': company,
        'email': email,
        'address': address,
        'role': role, // Gửi vai trò
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['message'] == 'Đăng ký thành công';
    } else {
      return false;
    }
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Chuyển password thành bytes
    var digest = sha256.convert(bytes); // Băm password với SHA-256
    return digest.toString(); // Chuyển hash thành chuỗi
  }
}

