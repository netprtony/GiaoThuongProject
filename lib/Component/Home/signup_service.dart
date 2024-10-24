import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterService {
  Future<bool> register(String username, String password, String name, String gender, String dob, String phone, String company, String email, String address) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:3000/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'name': name,
        'gender': gender,
        'dob': dob,
        'phone': phone,
        'company': company,
        'email': email,
        'address': address,
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
