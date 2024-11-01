import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final String token;

  NotificationService(this.token);

  Future<List<NotificationItem>> fetchNotifications() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:3000/api/auth/getNotifications'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['code'] == 1000) {
        final notifications = (data['result']['notifications'] as List)
            .map((json) => NotificationItem.fromJson(json))
            .toList();
        notifications.sort((a, b) => b.createDate.compareTo(a.createDate)); 
        return notifications;
      } else {
        throw Exception('Failed to load notifications: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load notifications: ${response.statusCode}');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final url = 'http://127.0.0.1:3000/api/auth/markAsRead/$notificationId';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read: ${response.statusCode}');
    }
  }

  Future<void> markAllAsRead() async {
    const url = 'http://192.168.0.108:3000/api/auth/markAllAsRead';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark all notifications as read: ${response.statusCode}');
    }
  }
}

class NotificationItem {
  String notificationId;
  String createUser;
  String message;
  String createDate;
  bool isRead;

  NotificationItem({
    required this.notificationId,
    required this.createUser,
    required this.message,
    required this.createDate,
    required this.isRead,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: json['notification_id'],
      createUser: json['createUser'],
      message: json['message'],
      createDate: json['createDate'],
      isRead: json['read'],
    );
  }
}