import 'package:http/http.dart' as http;
import 'dart:convert';

class DealService {
  final String apiUrl = 'http://192.168.0.108:3000/api/deals';

  // Thêm deal mới
  Future<bool> addDeal(String title, String description, double price, String company) async {
    final response = await http.post(
      Uri.parse('$apiUrl/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'price': price,
        'company': company,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Sửa thông tin deal
  Future<bool> updateDeal(String dealId, String title, String description, double price, String company) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update/$dealId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'price': price,
        'company': company,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Xóa deal
  Future<bool> deleteDeal(String dealId) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/delete/$dealId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Lấy danh sách các deal
  Future<List<dynamic>> getDeals() async {
    final response = await http.get(
      Uri.parse('$apiUrl/list'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }
}
