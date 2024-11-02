import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'event_detail.dart';

class ListEventScreen extends StatefulWidget {
  final String token; 

  const ListEventScreen({Key? key, required this.token}) : super(key: key);

  @override
  _ListEventScreenState createState() => _ListEventScreenState();
}

class _ListEventScreenState extends State<ListEventScreen> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents(); 
  }

  Future<void> _fetchEvents() async {
    final String url = 'http://192.168.1.67:3000/api/deals/list'; 
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}', 
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final List<Event> loadedEvents = (data['result'] as List)
          .map((eventJson) => Event.fromJson(eventJson))
          .toList();

      setState(() {
        events = loadedEvents; 
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: events.isEmpty 
          ? Center(child: CircularProgressIndicator()) 
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.content), 
                      Text('Công ty: ${event.company}'), 
                      Text('Rating: ${event.averageRating.toString()}'), 
                    ],
                  ),
                  onTap: () {
                    // Chuyển hướng đến màn hình chi tiết 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(
                          title: event.title,
                          content: event.content,
                          company: event.company,
                          price: event.price,
                          comments: event.comments, 
                          starRatings: event.starRatings,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class Event {
  final String id;
  final String title;
  final String content;
  final String company;
  final double price;
  final List<Map<String, dynamic>> comments; // Nhận xét
  final List<Map<String, dynamic>> starRatings; // Đánh giá sao

  Event({
    required this.id,
    required this.title,
    required this.content,
    required this.company,
    required this.price,
    required this.comments,
    required this.starRatings,
  });

  // Tính rating trung bình
  double get averageRating {
    if (starRatings.isEmpty) return 0.0;
    double total = starRatings.map((rating) => rating['rating'] as double).reduce((a, b) => a + b);
    return total / starRatings.length;
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      company: json['company'],
      price: json['price'],
      comments: List<Map<String, dynamic>>.from(json['comments']),
      starRatings: List<Map<String, dynamic>>.from(json['starRatings']),
    );
  }
}
