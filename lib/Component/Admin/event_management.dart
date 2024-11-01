import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Event {
  String eventID;
  String title;
  String content;
  String description;
  double price;
  String company;
  String username;

  Event({
    required this.eventID,
    required this.title,
    required this.content,
    required this.description,
    required this.price,
    required this.company,
    required this.username,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventID: json['eventID'],
      title: json['title'],
      content: json['content'],
      description: json['description'],
      price: json['price'].toDouble(),
      company: json['company'],
      username: json['username'],
    );
  }
}

class EventManagementScreen extends StatefulWidget {
  final String role;
  final String token;
  final String username; // Thêm thông tin username
  const EventManagementScreen({super.key, required this.role, required this.token, required this.username});

  @override
  EventManagementScreenState createState() => EventManagementScreenState();
}

class EventManagementScreenState extends State<EventManagementScreen> {
  List<Event> events = [];
  List<Event> filteredEvents = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEvents(); // Load initial events
  }

  Future<void> _updateEvent(Event event) async {
    final String url = 'http://192.168.0.108:3000/api/deals/update/${event.eventID}';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: json.encode({
        'title': event.title,
        'content': event.content,
        'description': event.description,
        'price': event.price,
        'company': event.company,
        'username': widget.username, // Lấy từ thông tin đăng nhập
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final updatedEvent = Event.fromJson(data['result']);
      setState(() {
        final index = events.indexWhere((e) => e.eventID == updatedEvent.eventID);
        if (index != -1) {
          events[index] = updatedEvent;
          filteredEvents = events;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thất bại: ${response.statusCode}')),
      );
    }
  }

  Future<void> _fetchEvents() async {
  final String url = 'http://192.168.0.108:3000/api/deals/list';
  
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      // Giải mã dữ liệu và kiểm tra kiểu dữ liệu
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['result'] is List) { 
        final List<Event> loadedEvents = (data['result'] as List)
            .map((eventJson) => Event.fromJson(eventJson))
            .toList();

        setState(() {
          events = loadedEvents;
          filteredEvents = events;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid data format')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: ${response.statusCode}')),
      );
    }
  } catch (e) {
    // Bắt lỗi nếu có
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}


  void _filterEvents(String query) {
    setState(() {
      final lowerCaseQuery = query.toLowerCase();
      filteredEvents = events.where((event) {
        final matchesTitle = event.title.toLowerCase().contains(lowerCaseQuery);
        final matchesContent = event.content.toLowerCase().contains(lowerCaseQuery);
        return matchesTitle || matchesContent;
      }).toList();
    });
  }

  void _showLogoutDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Xác nhận xóa giao dịch",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: const Text("Bạn có chắc chắn muốn xóa giao dịch này không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Không",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _deleteEvent(event);
                await _fetchEvents();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Có",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEventForm({Event? event}) {
    final isEditing = event != null;
    final titleController = TextEditingController(text: isEditing ? event.title : '');
    final contentController = TextEditingController(text: isEditing ? event.content : '');
    final descriptionController = TextEditingController(text: isEditing ? event.description : '');
    final priceController = TextEditingController(text: isEditing ? event.price.toString() : '');
    final companyController = TextEditingController(text: isEditing ? event.company : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? "Sửa giao dịch" : "Thêm giao dịch"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(titleController, "Tiêu đề"),
                const SizedBox(height: 10),
                _buildTextField(contentController, "Nội dung"),
                const SizedBox(height: 10),
                _buildTextField(descriptionController, "Mô tả"),
                const SizedBox(height: 10),
                _buildTextField(priceController, "Giá", keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                _buildTextField(companyController, "Công ty"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_validateForm(titleController, contentController, descriptionController, priceController, companyController)) {
                  if (isEditing) {
                    setState(() {
                      event.title = titleController.text;
                      event.content = contentController.text;
                      event.description = descriptionController.text;
                      event.price = double.parse(priceController.text);
                      event.company = companyController.text;
                      event.username = widget.username; // Lấy từ thông tin đăng nhập
                    });
                    _updateEvent(event);
                  } else {
                    final newEvent = Event(
                      eventID: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      content: contentController.text,
                      description: descriptionController.text,
                      price: double.parse(priceController.text),
                      company: companyController.text,
                      username: widget.username, // Lấy từ thông tin đăng nhập
                    );
                    _createEvent(newEvent);
                    await _fetchEvents();
                  }
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
                  );
                }
              },
              child: Text(isEditing ? "Sửa" : "Thêm"),
            ),
          ],
        );
      },
    );
  }

  bool _validateForm(TextEditingController title, TextEditingController content, TextEditingController description, TextEditingController price, TextEditingController company) {
    return title.text.isNotEmpty && content.text.isNotEmpty && description.text.isNotEmpty && price.text.isNotEmpty && company.text.isNotEmpty;
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _createEvent(Event event) async {
    const String url = 'http://192.168.0.108:3000/api/deals/create';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: json.encode({
        'title': event.title,
        'content': event.content,
        'description': event.description,
        'price': event.price,
        'company': event.company,
        'username': event.username,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final createdEvent = Event.fromJson(data['result']);
      setState(() {
        events.add(createdEvent);
        filteredEvents = events;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo giao dịch thành công')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tạo giao dịch thất bại: ${response.statusCode}')),
      );
    }
  }

  Future<void> _deleteEvent(Event event) async {
    final String url = 'http://192.168.0.108:3000/api/deals/delete/${event.eventID}';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        events.remove(event);
        filteredEvents = events;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa giao dịch thành công')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa giao dịch thất bại: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý giao dịch"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Tìm kiếm giao dịch',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterEvents,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Text(event.content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEventForm(event: event),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _showLogoutDialog(context, event),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
