import 'package:flutter/material.dart';
import 'package:giaothuong/Component/Admin/add_new_event.dart';

class EventListManagementScreen extends StatefulWidget {
  const EventListManagementScreen({super.key});

  @override
  _EventListManagementScreenState createState() => _EventListManagementScreenState();
}

class _EventListManagementScreenState extends State<EventListManagementScreen> {
  // List các sự kiện mẫu
  final List<Map<String, dynamic>> _eventList = [
    {'title': 'Bất động sản', 'content': 'Phú Mỹ Hưng', 'star': '4'},
    {'title': 'Công nghệ', 'content': 'Train App', 'star': '5'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Danh Sách Giao Dịch'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _eventList.length,
        itemBuilder: (context, index) {
          final event = _eventList[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.event),
              title: Text(event['title']),
              subtitle: Text('Nội dung: ${event['content']} - Đánh giá: ${event['star']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  _confirmDelete(index);
                },
              ),
              onTap: () {
                _viewEventDetails(event);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEvent,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  // Thêm giao dịch mới
  void _addNewEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewEventScreen()),
    ).then((newEvent) {
      if (newEvent != null) {
        setState(() {
          _eventList.add(newEvent); // Thêm sự kiện mới vào danh sách
        });
        print('Sự kiện mới đã được thêm:');
        print('Tiêu đề: ${newEvent['title']}');
        print('Nội dung: ${newEvent['content']}');
        print('Số sao: ${newEvent['star']}');
      }
    });
  }



  // Hiển thị chi tiết giao dịch
  void _viewEventDetails(Map<String, dynamic> event) {
    // Logic để hiển thị chi tiết sự kiện (có thể hiển thị dưới dạng dialog hoặc trang chi tiết)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chi Tiết Giao Dịch: ${event['title']}'),
          content: Text('Nội dung: ${event['content']}\nĐánh giá: ${event['star']}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  // Xác nhận xóa sự kiện
  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác Nhận Xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa giao dịch này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _eventList.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Có', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }
}
