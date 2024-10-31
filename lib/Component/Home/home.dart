import 'package:flutter/material.dart';
import 'package:giaothuong/Component/Settings/settings_screen.dart';
import 'package:giaothuong/Component/User/deal_service.dart';
import 'package:giaothuong/Component/Admin/event_list_management.dart';
import 'package:giaothuong/Component/User/notification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  final String role;
  final String token;
  const Home({super.key, required this.role, required this.token});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? userInfo;
  List<dynamic> _upcomingEvents = [];
  Timer? _timer;
  Timer? _timer2;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
    _fetchUpcomingEvents();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchUserInfo();
      _fetchUpcomingEvents();
    });
    _timer2 = Timer.periodic(const Duration(minutes: 30), (timer) {
      // _autoCalculateTrainingPoint();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer2?.cancel();
    super.dispose();
  }

  Future<void> _fetchUserInfo() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:3000/api/auth/profile'),
      headers: {
        'Authorization': '${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        userInfo = data['result'];
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user info')),
      );
    }
  }

  Future<void> _fetchUpcomingEvents() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:3000/api/deals/list'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> allEvents = data['result'];

      // Filter events to include only upcoming events
      final DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm');
      final DateTime now = DateTime.now().toLocal();
      final List<dynamic> upcomingEvents = allEvents.where((event) {
        final DateTime eventStartDate = DateTime.parse(event['dateStart']).toLocal();
        return now.isBefore(eventStartDate);
      }).map((event) {
        event['formattedDateStart'] = dateFormat.format(DateTime.parse(event['dateStart']).toLocal());
        event['formattedDateEnd'] = dateFormat.format(DateTime.parse(event['dateEnd']).toLocal());
        return event;
      }).toList();

      setState(() {
        _upcomingEvents = upcomingEvents;
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: ${response.statusCode}')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 197, 216, 236),
                  Color.fromARGB(255, 25, 117, 215),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            profile?['username'] ?? 'Loading...',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 25, 25, 25),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const CircleAvatar(
                            backgroundImage: AssetImage('assets/avatar.png'),
                            radius: 25,
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _upcomingEvents.length,
                                    itemBuilder: (context, index) {
                                      final event = _upcomingEvents[index];
                                      return _buildEventCard(
                                        event,
                                        event['title'] ?? 'Chưa cập nhật',
                                        event['content'] ?? 'Chưa cập nhật',
                                        event['price'] ?? 'Chưa cập nhật',
                                        event['company'] ?? 'Chưa cập nhật',
                                        event['createdBy'] ?? 'Chưa cập nhật',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _buildQuickAccessButton(" Giao Dịch", Icons.event, EventListManagementScreen(role: widget.role, token: widget.token)),
                                    const SizedBox(height: 16),
                                    _buildQuickAccessButton("Thông báo", Icons.notifications, NotificationsPage(token: widget.token)),
                                    const SizedBox(height: 16),
                                    _buildQuickAccessButton(" Cài đặt", Icons.settings, SettingsScreen(token: widget.token)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(dynamic event, String title, String content, String price, String company, String createdBy) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm'); // Define the date format

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsScreen(
                          title: event['title'],
                          content: event['content'],
                          price: event['price'],
                          company: event['company']
                          createdBy: event['createdBy'],
                          role: widget.role,
                          token: widget.token,
                          onUpdate: () => _fetchUpcomingEvents(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text("Xem chi tiết"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(String label, IconData icon, Widget destination) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      icon: Icon(icon, color: Colors.black),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        elevation: 5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
