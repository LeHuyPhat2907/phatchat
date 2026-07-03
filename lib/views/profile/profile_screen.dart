import 'dart:io'; // Import thêm thư viện này để dùng File
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _selectedImage; // Biến lưu trữ ảnh được chọn từ thiết bị

  // 1. Hàm chọn ảnh từ Gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Bật thư viện ảnh để người dùng chọn
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path); // Lưu đường dẫn ảnh vào biến
      });
      // (Task tiếp theo sẽ viết logic upload cái _selectedImage này lên Firebase Storage)
    }
  }

  // 2. Hàm xử lý đăng xuất (Giữ nguyên)
  void _handleLogout(BuildContext context) async {
    await AuthService().signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  // 3. Hàm hiển thị Dialog đổi tên (Giữ nguyên)
  void _showEditNameDialog(BuildContext context, String currentName, String uid) {
    TextEditingController nameController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Đổi tên hiển thị", style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Nhập tên mới của bạn",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                String newName = nameController.text.trim();
                if (newName.isNotEmpty && newName != currentName) {
                  try {
                    await FirebaseFirestore.instance.collection('users').doc(uid).update({'name': newName});
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Cập nhật tên thành công!"), backgroundColor: Colors.green),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red));
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text("Lưu", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cá nhân', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: user == null
          ? const Center(child: Text("Không tìm thấy thông tin người dùng"))
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Text("Lỗi tải thông tin"));

          var userData = snapshot.data?.data() as Map<String, dynamic>?;
          String name = userData?['name'] ?? 'Đang tải...';
          String email = userData?['email'] ?? user.email ?? '';
          String avatarUrl = userData?['avatarUrl'] ?? '';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 4. UI Avatar có thể bấm vào được
                GestureDetector(
                  onTap: _pickImage, // Gọi hàm chọn ảnh khi bấm vào
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        // Ưu tiên hiển thị ảnh vừa chọn từ máy (_selectedImage),
                        // nếu không có thì lấy link mạng (avatarUrl),
                        // nếu link mạng rỗng thì dùng ảnh mặc định.
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!) as ImageProvider
                            : NetworkImage(avatarUrl.isEmpty ? 'https://via.placeholder.com/150' : avatarUrl),
                      ),
                      // Icon camera nhỏ nhắn ở góc để báo hiệu cho người dùng có thể đổi ảnh
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.black87, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ... (Phần UI Tên, Nút Đổi Tên, Email và Đăng xuất giữ nguyên như cũ)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20, color: Colors.blueAccent),
                      onPressed: () => _showEditNameDialog(context, name, user.uid),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 40),
                SizedBox(
                  width: 200, height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("Đăng xuất", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}