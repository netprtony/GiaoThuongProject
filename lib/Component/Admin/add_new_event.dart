import 'package:flutter/material.dart';

class AddNewEventScreen extends StatefulWidget {
  const AddNewEventScreen({super.key});

  @override
  _AddNewEventScreenState createState() => _AddNewEventScreenState();
}

class _AddNewEventScreenState extends State<AddNewEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Sự Kiện Mới'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Tiêu đề sự kiện
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề sự kiện',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              const SizedBox(height: 20),

              // Nội dung sự kiện
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nội dung sự kiện',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!;
                },
              ),
              const SizedBox(height: 20),

              // Nút thêm sự kiện
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _addEvent();
                  }
                },
                child: const Text('Thêm Sự Kiện'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm xử lý khi thêm sự kiện
  void _addEvent() {
    // Thêm sự kiện vào cơ sở dữ liệu (lưu vào API hoặc database)
    print('Thêm sự kiện mới:');
    print('Tiêu đề: $_title');
    print('Nội dung: $_content');

    // Quay lại màn hình chính sau khi thêm sự kiện
    Navigator.pop(context, {
      'title': _title,
      'content': _content,
    });
  }
}

