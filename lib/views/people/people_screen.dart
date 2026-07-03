import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/app_constants.dart';
import '../chat/chat_screen.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  String _searchQuery = ''; // Biến lưu trữ từ khóa tìm kiếm
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( // Dùng SafeArea để không bị lẹm vào tai thỏ/status bar
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildStoriesSection(),
              const SizedBox(height: 10),
              _buildPeopleList(),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Phần Header (Avatar, Tiêu đề, Các nút bấm)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Có thể lấy ảnh của current user sau
          ),
          const SizedBox(width: 12),
          const Text('People', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const Spacer(),
          Container(
            decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
            child: IconButton(icon: const Icon(Icons.chat_bubble_rounded, color: Colors.black, size: 20), onPressed: () {}),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
            child: IconButton(icon: const Icon(Icons.edit_square, color: Colors.black, size: 20), onPressed: () {}),
          ),
        ],
      ),
    );
  }

  // 2. Thanh tìm kiếm
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase(); // Đưa hết về chữ thường để dễ so sánh
            });
          },
          decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  // 3. Danh sách Stories (Mock data)
  Widget _buildStoriesSection() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16.0),
        children: [
          _buildYourStoryCard(),
          // Tạm thời để Mock data, sau này có thể cùng Linh và Thắng làm tính năng upload Story thật
          _buildStoryCard(name: "Linh", bgUrl: "https://images.unsplash.com/photo-1506744626753-edaeb5d8c001", avatarUrl: "https://via.placeholder.com/150"),
          _buildStoryCard(name: "Thắng", bgUrl: "https://images.unsplash.com/photo-1519681393784-d120267933ba", avatarUrl: "https://via.placeholder.com/150"),
        ],
      ),
    );
  }

  // Component cho thẻ "Your Story"
  Widget _buildYourStoryCard() {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 15, left: 15,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black,
              child: Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
          const Positioned(
            bottom: 15, left: 15,
            child: Text("Your Story", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // Component cho thẻ Story của bạn bè
  Widget _buildStoryCard({required String name, required String bgUrl, required String avatarUrl}) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(image: NetworkImage(bgUrl), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)]),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10, left: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.messengerBlue, width: 2), // Viền xanh của Story
                ),
                child: CircleAvatar(radius: 16, backgroundImage: NetworkImage(avatarUrl)),
              ),
            ),
            Positioned(
              bottom: 12, left: 10, right: 10,
              child: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Danh sách người dùng từ Firestore (StreamBuilder)
  Widget _buildPeopleList() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return const Center(child: Text("Lỗi tải danh sách"));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const SizedBox();

        // LOGIC LỌC TÌM KIẾM ĐƯỢC THÊM VÀO ĐÂY
        final users = snapshot.data!.docs.where((doc) {
          // 1. Bỏ qua chính mình
          if (doc.id == currentUserId) return false;

          // 2. Nếu thanh tìm kiếm trống -> Hiện tất cả
          if (_searchQuery.isEmpty) return true;

          // 3. Lấy tên và email về chữ thường để so sánh
          var userData = doc.data() as Map<String, dynamic>;
          String name = (userData['name'] ?? '').toString().toLowerCase();
          String email = (userData['email'] ?? '').toString().toLowerCase();

          // 4. Kiểm tra xem từ khóa có nằm trong Tên HOẶC Email không
          return name.contains(_searchQuery) || email.contains(_searchQuery);
        }).toList();

        if (users.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: Text("Không tìm thấy kết quả nào.", style: TextStyle(color: Colors.grey))),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            var userData = users[index].data() as Map<String, dynamic>;
            bool isOnline = userData['status'] == 'online';

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Stack(
                children: [
                  CircleAvatar(radius: 26, backgroundImage: NetworkImage(userData['avatarUrl'] == "" ? 'https://via.placeholder.com/150' : userData['avatarUrl'])),
                  if (isOnline)
                    Positioned(
                      right: 0, bottom: 0,
                      child: Container(
                        width: 14, height: 14,
                        decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                      ),
                    ),
                ],
              ),
              title: Text(userData['name'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              trailing: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
                child: const Icon(Icons.waving_hand, color: Colors.black87, size: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      receiverName: userData['name'] ?? 'No Name',
                      receiverId: users[index].id,
                      receiverAvatarUrl: userData['avatarUrl'] == ""
                          ? 'https://via.placeholder.com/150'
                          : userData['avatarUrl'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}