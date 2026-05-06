import 'package:flutter/material.dart';
import '../utils/app_constants.dart'; // Đảm bảo bạn có file chứa AppColors.messengerBlue

class ChatListItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int unreadCount;
  final bool isTyping;
  final String avatarUrl;

  const ChatListItem({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    this.unreadCount = 0,
    this.isTyping = false,
    this.avatarUrl = 'https://via.placeholder.com/150',
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      // 1. Bên trái: Ảnh đại diện & Chấm xanh online
      leading: Stack(
        children: [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage(avatarUrl)),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
      // 2. Ở giữa: Tên & Tin nhắn cuối
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(
        isTyping ? "is typing..." : message,
        style: TextStyle(
          color: isTyping ? AppColors.messengerBlue : Colors.grey,
          fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      // 3. Bên phải: Thời gian & Thông báo tin nhắn mới
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 5),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: AppColors.messengerBlue, shape: BoxShape.circle),
              child: Text("$unreadCount", style: const TextStyle(color: Colors.white, fontSize: 10)),
            )
          else
            const Icon(Icons.done_all, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}