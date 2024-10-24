import 'package:http/http.dart' as http;
import 'dart:convert';

class DealService {
  final String apiUrl = 'http://127.0.0.1:3000/api/deals';

  // Thêm deal mới
  Future<bool> createDeal(String title, String description, double price, String company) async {
    final response = await http.post(
      Uri.parse('$apiUrl/create'),
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

  Future<bool> addComment(String dealId, String comment) async {
    final url = Uri.parse('$apiUrl/comments/$dealId');  // URL API để thêm comment

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        return true;  // Thành công
      } else {
        return false;  // Xử lý khi gặp lỗi
      }
    } catch (e) {
      print("Error adding comment: $e");
      return false;  // Xử lý khi gặp lỗi ngoại lệ
    }
  }

  Future<bool> addRating(String dealId, int rating) async {
    final response = await http.post(
      Uri.parse('$apiUrl/rating/$dealId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'rating': rating}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
