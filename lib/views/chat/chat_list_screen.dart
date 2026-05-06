import 'package:flutter/material.dart';
import '../../widgets/chat_list_item.dart';
import '../../utils/app_constants.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả lập danh sách tin nhắn: Để trống [] để hiện Mẫu 1, thêm dữ liệu để hiện Mẫu 2
    List<Map<String, dynamic>> chats = [
      {"name": "Olivia Grant", "msg": "Olivia is typing...", "time": "12:30", "count": 3, "typing": true},
      {"name": "John Alfaro", "msg": "Nice work, i love it 👍", "time": "12:30", "count": 0, "typing": false},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset('assets/images/logo.png', height: 140),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),

          Expanded(
            child: chats.isEmpty
                ? _buildEmptyState() // Giao diện Mẫu 1
                : ListView.builder(  // Giao diện Mẫu 2
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final item = chats[index];
                return ChatListItem(
                  name: item['name'],
                  message: item['msg'],
                  time: item['time'],
                  unreadCount: item['count'],
                  isTyping: item['typing'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Thay bằng ảnh minh họa của bạn
          const Icon(Icons.chat_bubble_outline, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          const Text("Bắt đầu tin nhắn của bạn", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.messengerBlue),
            child: const Text("Thêm tin nhắn mới", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}