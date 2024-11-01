import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String company;
  final double price;
  final List<Map<String, dynamic>> comments; 
  final List<Map<String, dynamic>> starRatings;

  const EventDetailScreen({
    Key? key,
    required this.title,
    required this.content,
    required this.company,
    required this.price,
    required this.comments,
    required this.starRatings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tính điểm trung bình của đánh giá sao
    double averageRating = starRatings.isNotEmpty
        ? starRatings.map((rating) => rating['rating'] as double).reduce((a, b) => a + b) / starRatings.length
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Công ty: $company',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Giá: ${price.toString()} VNĐ',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Đánh giá trung bình: ${averageRating.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Nhận xét:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...comments.map((comment) => ListTile(
              title: Text(comment['content']),
              subtitle: Text('Bởi người dùng ID: ${comment['userId']}'),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
