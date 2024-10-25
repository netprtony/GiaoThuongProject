import 'package:flutter/material.dart';

class User {
  String username;
  String password;
  String confirmPassword;
  String name;
  String company;
  String email;
  String phone;
  String address;
  String gender; // Thêm trường giới tính
  DateTime dob; // Thêm trường ngày sinh
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
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  UserManagementScreenState createState() => UserManagementScreenState();
}

class UserManagementScreenState extends State<UserManagementScreen> {
  List<User> users = [
    User(
      username: 'muidao',
      password: '123456',
      confirmPassword: '123456',
      name: 'Dao Qui Mui',
      company: 'Vietsunco',
      email: 'muidao156@gmail.com',
      phone: '+84 773 15 39 87',
      address: '390 Nữ Dân Công',
      gender: 'Nữ', // Giới tính
      dob: DateTime(1990, 5, 20), // Ngày sinh
      userRoles: {'Admin'},
    ),
    User(
      username: 'vikhang',
      password: 'bakugan',
      confirmPassword: 'bakugan',
      name: 'Huynh Vi Khang',
      company: 'Vietsunco',
      email: 'huynhvikhang6a13@gmail.com',
      phone: '+84 767 48 78 40',
      address: '5/5A Bắc lân Bà Điểm Hóc Môn TPHCM',
      gender: 'Nam', // Giới tính
      dob: DateTime(1995, 8, 15), // Ngày sinh
      userRoles: {'User'},
    ),
  ];

  List<User> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUsers = users; // Initialize filtered list with all users
  }

  // Function to filter users by name or role
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

  // Function to handle adding or editing users
  void _showUserForm({User? user}) {
    final isEditing = user != null;
    final usernameController = TextEditingController(text: isEditing ? user.username : '');
    final passwordController = TextEditingController(text: isEditing ? user.password : '');
    final confirmPasswordController = TextEditingController(text: isEditing ? user.confirmPassword : '');
    final nameController = TextEditingController(text: isEditing ? user.name : '');
    final companyController = TextEditingController(text: isEditing ? user.company : '');
    final emailController = TextEditingController(text: isEditing ? user.email : '');
    final phoneController = TextEditingController(text: isEditing ? user.phone : '');
    final addressController = TextEditingController(text: isEditing ? user.address : '');
    String selectedRole = isEditing && user.userRoles.isNotEmpty ? user.userRoles.first : 'User';
    String selectedGender = isEditing ? user.gender : 'Nam'; // Giới tính
    DateTime? selectedDob = isEditing ? user.dob : null; // Ngày sinh

    // Date picker function
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDob ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != selectedDob)
        setState(() {
          selectedDob = picked; // Cập nhật ngày sinh
        });
    }

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
                _buildTextField(confirmPasswordController, "Xác nhận mật khẩu"),
                const SizedBox(height: 10),
                _buildTextField(nameController, "Họ và tên"),
                const SizedBox(height: 10),
                _buildTextField(companyController, "Công ty"),
                const SizedBox(height: 10),
                _buildTextField(emailController, "Email"),
                const SizedBox(height: 10),
                _buildTextField(phoneController, "Số điện thoại"),
                const SizedBox(height: 10),
                _buildTextField(addressController, "Địa chỉ"),
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
                  items: ['User', 'Admin'].map((role) {
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
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    labelText: "Giới tính",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                  ),
                  items: ['Nam', 'Nữ'].map((gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: TextEditingController(
                    text: selectedDob != null ? "${selectedDob!.day}/${selectedDob!.month}/${selectedDob!.year}" : '',
                  ),
                  decoration: InputDecoration(
                    labelText: "Ngày sinh",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                  ),
                  onTap: () => _selectDate(context), // Mở DatePicker khi nhấn
                  readOnly: true,
                ),
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
                setState(() {
                  if (isEditing) {
                    user.username = usernameController.text;
                    user.password = passwordController.text;
                    user.confirmPassword = confirmPasswordController.text;
                    user.name = nameController.text;
                    user.company = companyController.text;
                    user.email = emailController.text;
                    user.phone = phoneController.text;
                    user.address = addressController.text;
                    user.userRoles = {selectedRole};
                    user.gender = selectedGender; // Cập nhật giới tính
                    user.dob = selectedDob ?? DateTime.now(); // Cập nhật ngày sinh
                  } else {
                    users.add(User(
                      username: usernameController.text,
                      password: passwordController.text,
                      confirmPassword: confirmPasswordController.text,
                      name: nameController.text,
                      company: companyController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      address: addressController.text,
                      userRoles: {selectedRole},
                      gender: selectedGender, // Giới tính
                      dob: selectedDob ?? DateTime.now(), // Ngày sinh
                    ));
                  }
                  filteredUsers = users; // Reset filtered list after adding or editing
                });
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
              // Search Bar
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
                  _filterUsers(value); // Filter users when search query changes
                },
              ),
              const SizedBox(height: 20),
              Expanded(
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
                            user.name[0],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _showUserForm(user: user),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
