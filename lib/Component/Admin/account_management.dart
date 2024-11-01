import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  String username;
  String password;
  String confirmPassword;
  String name;
  String company;
  String email;
  String phone;
  String address;
  String gender;
  DateTime dob;
  Set<String> userRoles;

  User({
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.name,
    required this.company,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    required this.dob,
    required this.userRoles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      dob: DateTime.parse(json['dob']),
      userRoles: json['userRoles'] != null ? Set<String>.from(json['userRoles']) : {},
    );
  }
}

class UserManagementScreen extends StatefulWidget {
  final String role;
  final String token;

  const UserManagementScreen({super.key, required this.role, required this.token});

  @override
  UserManagementScreenState createState() => UserManagementScreenState();
}

class UserManagementScreenState extends State<UserManagementScreen> {
  List<User> users = [];
  List<User> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _updateUserRole(String username, String newRole) async {
    final String url = 'http://192.168.0.108:3000/api/auth/updateRole/$username';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode({'roles': [newRole]}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['code'] == 1000) {
        setState(() {
          final updatedUser = User.fromJson(jsonResponse['result']);
          final index = users.indexWhere((user) => user.username == username);
          if (index != -1) {
            users[index] = updatedUser;
            filteredUsers = users;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi quyền thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user role: ${jsonResponse['code']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thất bại: ${response.statusCode}')),
      );
    }
  }

  Future<void> _fetchUsers() async {
    const String url = 'http://192.168.0.108:3000/api/auth/listUsers';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['code'] == 1000) {
        setState(() {
          users = (jsonResponse['result'] as List)
              .map((data) => User.fromJson(data))
              .toList();
          filteredUsers = users;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load users: ${jsonResponse['code']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: ${response.statusCode}')),
      );
    }
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = users;
      } else {
        filteredUsers = users.where((user) {
          final lowerCaseQuery = query.toLowerCase();
          return user.name.toLowerCase().contains(lowerCaseQuery) ||
              user.userRoles.any((role) => role.toLowerCase().contains(lowerCaseQuery));
        }).toList();
      }
    });
  }

  void _showUserForm({User? user}) {
    final isEditing = user != null;
    final usernameController = TextEditingController(text: isEditing ? user.username : '');
    final passwordController = TextEditingController(text: isEditing ? user.password : '');
    String selectedRole = isEditing && user.userRoles.isNotEmpty ? user.userRoles.first : 'USER';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? "Sửa người dùng" : "Thêm người dùng"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(usernameController, "Tên đăng nhập"),
                const SizedBox(height: 10),
                _buildTextField(passwordController, "Mật khẩu"),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: "Quyền",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                  ),
                  items: ['USER', 'MANAGER', 'ADMIN'].map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                if (isEditing) {
                  _updateUserRole(user.username, selectedRole);
                  _fetchUsers();
                } else {
                  setState(() {
                    users.add(User(
                      username: usernameController.text,
                      password: passwordController.text,
                      confirmPassword: '',
                      name: '',
                      company: '',
                      email: '',
                      phone: '',
                      address: '',
                      gender: '',
                      dob: DateTime.now(),
                      userRoles: {selectedRole},
                    ));
                    filteredUsers = users;
                  });
                }
                Navigator.pop(context);
              },
              child: Text(isEditing ? "Sửa" : "Thêm"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 197, 216, 236), Color.fromARGB(255, 25, 117, 215)],
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
                  labelText: "Tìm kiếm theo tên hoặc quyền",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(1),
                ),
                onChanged: (value) {
                  _filterUsers(value);
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchUsers,
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color.fromARGB(255, 25, 117, 215),
                            child: Text(
                              user.name.isNotEmpty ? user.name[0] : '',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(user.username),
                          subtitle: Text('Quyền: ${user.userRoles.join(', ')}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUserForm(user: user);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Logic to delete user
                                },
                              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
