import 'package:http/http.dart' as http;
import 'dart:convert';

// Class dịch vụ đăng ký
class RegisterService {
  Future<bool> register(String username, String password, String name, String phone, String company, String email, String address, String gender, String dob, String role) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.108:3000/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password, // Gửi mật khẩu chưa băm
        'name': name,
        'company': company,
        'email': email,
        'phone': phone,        
        'address': address,
        'gender': gender,
        'dob': dob,
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
}
