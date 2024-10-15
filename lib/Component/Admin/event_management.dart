import 'package:flutter/material.dart';

class EventManagementScreen extends StatefulWidget {
  const EventManagementScreen({super.key});

  @override
  _EventManagementScreenState createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  // Ví dụ về danh sách sự kiện
  List<Map<String, dynamic>> events = [
    {
      'title': 'Bất động sản',
      'content': 'Phú Mỹ Hưng',
      'star': 4,
    },
    {
      'title': 'Công nghệ',
      'content': 'Train App',
      'star': 5,
    },
  ];

  // Hàm thêm sự kiện mới
  void _addNewEvent(Map<String, dynamic> newEvent) {
    setState(() {
      events.add(newEvent);
    });
  }

  // Hàm xóa sự kiện
  void _deleteEvent(int index) {
    setState(() {
      events.removeAt(index);
    });
  }

  // Hàm để hiện form thêm sự kiện mới
  void _showAddEventForm(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    TextEditingController starController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm Giao Dịch Mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Nội dung'),
              ),
              TextField(
                controller: starController,
                decoration: const InputDecoration(labelText: 'Số sao'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty &&
                    starController.text.isNotEmpty) {
                  _addNewEvent({
                    'title': titleController.text,
                    'content': contentController.text,
                    'star': int.parse(starController.text),
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Giao Dịch'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(events[index]['title']),
              subtitle: Text(events[index]['content']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Hàm chỉnh sửa sự kiện sẽ được gọi ở đây
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteEvent(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventForm(context); // Gọi form thêm sự kiện
        },
        tooltip: 'Thêm Giao Dịch',
        child: const Icon(Icons.add),
      ),
    );
  }
}
