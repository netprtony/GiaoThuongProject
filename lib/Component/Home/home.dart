import 'package:flutter/material.dart';
import 'package:giaothuong/Component/Settings/settings_screen.dart' as settings;
import 'package:giaothuong/Component/User/deal_service.dart';

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
      'star': 4,  // Thay đổi thành kiểu int
      'comments': <String>[], // Đảm bảo đây là một List<String>
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

  if (!mounted) return; // Kiểm tra widget có còn mounted không

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

  if (!mounted) return; // Kiểm tra widget có còn mounted không

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

  if (!mounted) return; // Kiểm tra widget có còn mounted không

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

  if (!mounted) return; // Kiểm tra widget có còn mounted không

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment added successfully')),
    );
    _fetchDeals(); // Cập nhật lại danh sách deal sau khi thêm comment
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
    ),
    body: Stack(
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 200, 0), // Màu cam
                Color.fromARGB(255, 255, 140, 0), // Màu cam đậm hơn
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
                              'assets/images/person.png'), // Hình đại diện
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
                                  itemCount: _transactions.length, // Sử dụng _transactions
                                  itemBuilder: (context, index) {
                                    final transaction = _transactions[index]; // Lấy từng giao dịch
                                    return _buildEventCard(
                                      transaction['_id'], // Truyền dealId vào đây (nếu có)
                                      transaction['title'],
                                      transaction['content'],
                                      transaction['star'].toString(),
                                      transaction['comments'] ?? [], // Kiểm tra nếu không có bình luận
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
                                      settings.SettingsScreen(
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
                // Nút Floating Action Button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: _addDeal,
                    child: const Icon(Icons.add),
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
              const SizedBox(height: 5),
              Text(content),
              const SizedBox(height: 10),
              // Hiển thị xếp hạng sao
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < starCount ? Icons.star : Icons.star_border,
                    color: index < starCount ? Colors.amber : Colors.grey,
                  );
                }),
              ),
              const SizedBox(height: 10),
              // Hiển thị bình luận
              const Text(
                'Bình luận:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              ...comments.map((comment) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(comment),
                );
              }), // Loại bỏ toList() ở đây
              const SizedBox(height: 10),
              // Nút thêm bình luận
              TextField(
                onSubmitted: (newComment) {
                  _addComment(dealId, newComment); // Gọi hàm thêm bình luận
                },
                decoration: const InputDecoration(
                  labelText: 'Thêm bình luận',
                  border: OutlineInputBorder(),
                ),
              ),
              // Nút cập nhật
              TextButton(
                onPressed: () {
                  _updateDeal(dealId); // Gọi hàm cập nhật
                },
                child: const Text('Cập nhật'),
              ),
              // Nút xóa
              TextButton(
                onPressed: () {
                  _deleteDeal(dealId); // Gọi hàm xóa
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildQuickAccessButton(String label, IconData icon, Widget destination) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => destination,
            ),
          );
        },
      ),
    );
  }
}
