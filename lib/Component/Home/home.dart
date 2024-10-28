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
  // Danh sách giao dịch
  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Bất động sản',
      'content': 'Phú Mỹ Hưng',
      'price': '15000',
      'company': 'Vietsunco',
      'star': 4,
      'comments': <String>[],
    },
    {
      'title': 'Công nghệ',
      'content': 'Train App',
      'price': '10000',
      'company': 'Vietsunco',
      'star': 5,
      'comments': <String>[],
    },
    {
      'title': 'Dịch vụ',
      'content': 'Giao hàng nhanh',
      'price': '8000',
      'company': 'Vietsunco',
      'star': 3,
      'comments': <String>[],
    },
  ];

  DealService dealService = DealService();
  List<dynamic> deals = [];

  @override
  void initState() {
    super.initState();
    _fetchDeals();
  }

  void _fetchDeals() async {
    List<dynamic> fetchedDeals = await dealService.getDeals();
    setState(() {
      deals = fetchedDeals;
    });
  }

  void _addDeal() async {
    bool success = await dealService.createDeal(
      'New Deal',
      'This is a new deal',
      100.0,
      'Some Company',
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deal added successfully')),
      );
      _fetchDeals();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add deal')),
      );
    }
  }

  void _updateDeal(String dealId) async {
    bool success = await dealService.updateDeal(
      dealId,
      'Updated Deal',
      'Updated description',
      150.0,
      'Updated Company',
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deal updated successfully')),
      );
      _fetchDeals();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update deal')),
      );
    }
  }

  void _deleteDeal(String dealId) async {
    bool success = await dealService.deleteDeal(dealId);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deal deleted successfully')),
      );
      _fetchDeals();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete deal')),
      );
    }
  }

  void _addComment(String dealId, String newComment) async {
    bool success = await dealService.addComment(dealId, newComment);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully')),
      );
      _fetchDeals();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add comment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deal Management'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 200, 0),
                  Color.fromARGB(255, 255, 140, 0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with profile
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dao Qui Mui",
                            style: TextStyle(
                              color: Color.fromARGB(255, 25, 25, 25),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/person.png'),
                            radius: 25,
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Body content
                  Expanded(
                    child: Row(
                      children: [
                        // Event List
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Danh sách giao dịch',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _transactions.length,
                                    itemBuilder: (context, index) {
                                      final transaction = _transactions[index];
                                      return _buildEventCard(
                                        transaction['_id'],
                                        transaction['title'],
                                        transaction['content'],
                                        transaction['star'].toString(),
                                        transaction['comments'] ?? [],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Quick Access Grid
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 16),
                                    _buildQuickAccessButton(
                                      "Cài đặt",
                                      Icons.settings,
                                      SettingsScreen(token: widget.token),
                                    ),
                                  ],
                                ),
                              ),
                              // Status Overview
                              Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Tổng quan trạng thái',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Nút Floating Action Button
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: _addDeal,
                      child: const Icon(Icons.add),
                      backgroundColor: Colors.orange,
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

  Widget _buildEventCard(String dealId, String title, String content, String star, List<String> comments) {
    int starCount = int.tryParse(star) ?? 0;

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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('⭐ ' * starCount),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteDeal(dealId),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(String title, IconData icon, Widget navigateTo) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 8,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => navigateTo),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.orange),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
