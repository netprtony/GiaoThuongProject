import 'package:flutter/material.dart';
import 'package:giaothuong/Component/User/list_event.dart'; 
import 'package:giaothuong/Component/User/notification.dart'; 
import 'package:giaothuong/Component/User/setting.dart'; 

class HomeScreen extends StatefulWidget {
  final String token;
  final String role;
  const HomeScreen({Key? key, required this.token, required this.role}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Chỉ số của tab đang được chọn

  // Danh sách các màn hình để hiển thị theo tab
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.add(ListEventScreen(token: widget.token)); // Thêm màn hình danh sách sự kiện
    _screens.add(NotificationsPage(token: widget.token)); // Thêm màn hình thông báo
    _screens.add(SettingsScreen(token: widget.token, role: widget.role)); // Thêm màn hình cài đặt
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số tab đang chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Chính'),
      ),
      body: _screens[_selectedIndex], // Hiển thị màn hình tương ứng với tab đang chọn
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Gọi hàm khi tab được nhấn
      ),
    );
  }
}