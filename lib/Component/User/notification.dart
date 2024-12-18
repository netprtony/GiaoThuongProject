import 'package:flutter/material.dart';
import 'package:giaothuong/Component/User/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  final String token;
  const NotificationsPage({super.key, required this.token});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsPage> {
  late NotificationService notificationService;
  List<NotificationItem> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService(widget.token);
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final fetchedNotifications = await notificationService.fetchNotifications();
      setState(() {
        notifications = fetchedNotifications;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _markNotificationAllAsRead() async {
    try {
      await notificationService.markAllAsRead();
      setState(() {
        for (var notification in notifications) {
          notification.isRead = true;
        }
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark all notifications as read: $e')),
      );
    }
  }

  Future<void> _markNotificationAsRead(String notificationId) async {
    try {
      await notificationService.markAsRead(notificationId);
      setState(() {
        notifications.firstWhere((notification) => notification.notificationId == notificationId).isRead = true;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark notification as read: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.00, // Điều chỉnh padding theo tỷ lệ màn hình
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.00, // Điều chỉnh padding tiêu đề theo chiều cao màn hình
          ),
          child: Text(
            "Thông báo",
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.06, // Điều chỉnh kích thước font theo tỷ lệ màn hình
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 25, 117, 215),
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.05, // Điều chỉnh chiều cao AppBar theo màn hình
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_as_unread),
            onPressed: _markNotificationAllAsRead,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFC5D8EC), Color(0xFF1975D7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
            ? const Center(child: Text('Chưa có thông báo', style: TextStyle(fontSize: 18, color: Colors.black54)))
            : ListView.builder(
          padding: const EdgeInsets.only(top: 16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState(() {
                    notifications.removeAt(index);
                  });
                },
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: notifications[index].isRead
                          ? Colors.grey
                          : Colors.blueAccent,
                      child: Icon(
                        notifications[index].isRead
                            ? Icons.notifications_none
                            : Icons.notifications_active,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      notifications[index].message,
                      style: TextStyle(
                        fontWeight: notifications[index].isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      _formatDateTime(notifications[index].createDate),
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Đánh dấu là đã đọc') {
                          _markNotificationAsRead(notifications[index].notificationId);
                        } else if (value == 'Xoá thông báo') {
                          setState(() {
                            notifications.removeAt(index);
                          });
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Đánh dấu là đã đọc', 'Xoá thông báo'}
                            .map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDateTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm a');
    return formatter.format(parsedDate);
  }
}