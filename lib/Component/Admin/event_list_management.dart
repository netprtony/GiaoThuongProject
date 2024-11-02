import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventList {
  String title;
  String content;
  String description;
  double price;
  String company;
  String username;
  double rating;
  List<Comment> comments;

  EventList({
    required this.title,
    required this.content,
    required this.description,
    required this.price,
    required this.company,
    required this.username,
    required this.rating,
    required this.comments,
  });

  factory EventList.fromJson(Map<String, dynamic> json) {
    return EventList(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      company: json['company'] ?? '',
      username: json['username'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((comment) => Comment.fromJson(comment))
              .toList() ??
          [],
    );
  }
}

class Comment {
  String user;
  String commentText;

  Comment({
    required this.user,
    required this.commentText,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'] ?? '',
      commentText: json['commentText'] ?? '',
    );
  }
}

class EventListManagementScreen extends StatefulWidget {
  final String token;
  final String role;
  const EventListManagementScreen({super.key, required this.token, required this.role});

  @override
  EventListManagementScreenState createState() => EventListManagementScreenState();
}

class EventListManagementScreenState extends State<EventListManagementScreen> {
  List<EventList> events = [];
  List<EventList> filteredEvents = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    const String url = 'http://192.168.1.67:3000/api/deal/listEvent';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final List<EventList> loadedEvents = (data['result'] as List)
          .map((eventJson) => EventList.fromJson(eventJson))
          .toList();

      setState(() {
        events = loadedEvents;
        filteredEvents = events;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: ${response.statusCode}')),
      );
    }
  }

  void _filterEvents(String query) {
    setState(() {
      final lowerCaseQuery = query.toLowerCase();

      filteredEvents = events.where((event) {
        final matchesTitle = event.title.toLowerCase().contains(lowerCaseQuery);
        return matchesTitle;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Tìm kiếm theo tiêu đề",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                onChanged: (value) {
                  _filterEvents(value);
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchEvents,
                  child: ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ListTile(
                          title: Text(event.title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Mô tả: ${event.description}"),
                              Text("Giá: \$${event.price.toStringAsFixed(2)}"),
                              Text("Công ty: ${event.company}"),
                              Text("Người dùng: ${event.username}"),
                              Text("Đánh giá: ${event.rating.toString()}/5"),
                              ...event.comments.map((comment) => Text(
                                  "${comment.user}: ${comment.commentText}")),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
