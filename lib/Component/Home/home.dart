import 'package:flutter/material.dart';
import 'package:giaothuong/Component/Settings/settings_screen.dart' as Settings;
import 'package:giaothuong/Component/User/deal_service.dart';

class Home extends StatefulWidget {
  final String role;
  final String token;

  const Home({super.key, required this.role, required this.token});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Giả lập dữ liệu danh sách giao dịch
  final List<Map<String, String>> _transactions = [
    {
      'title': 'Bất động sản',
      'content': 'Phú Mỹ Hưng',
      'star': '4',
    },
    {
      'title': 'Công nghệ',
      'content': 'Train App',
      'star': '5',
    },
    {
      'title': 'Dịch vụ',
      'content': 'Giao hàng nhanh',
      'star': '3',
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
    bool success = await dealService.addDeal(
      'New Deal',
      'This is a new deal',
      100.0,
      'Some Company',
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deal Management'),
      ),
      body: Stack(
        children: [
          // Gradient background
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
                        color: Colors.white.withOpacity(0.8),
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
                                'assets/images/person.png'), // Profile picture
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
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Danh sách giao dịch',
                                  style: TextStyle(
                                    fontSize: 18,
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
                                        transaction['title']!,
                                        transaction['content']!,
                                        transaction['star']!,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 16),
                                    _buildQuickAccessButton(
                                        "Cài đặt",
                                        Icons.settings,
                                        Settings.SettingsScreen(
                                            token: widget.token)),
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
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addDeal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventCard(String title, String content, String star) {
    int starCount = int.tryParse(star) ?? 0; // Chuyển đổi chuỗi sang số nguyên
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
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 5),
              // Hiển thị ngôi sao dựa trên đánh giá
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < starCount ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  );
                }),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn nút
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Widget _buildQuickAccessButton(
      String label, IconData icon, Widget destination) {
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
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
