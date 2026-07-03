import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/chat_service.dart';
import '../../utils/app_constants.dart';
import '../../utils/chat_helper.dart';
import '../../utils/date_formatter.dart';

class ChatScreen extends StatefulWidget {
  final String receiverName;
  final String receiverAvatarUrl;
  final String receiverId;

  // Cần truyền thông tin người nhận vào để hiển thị lên Header
  const ChatScreen({
    super.key,
    required this.receiverName,
    required this.receiverId,
    this.receiverAvatarUrl = 'https://via.placeholder.com/150',
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  // Hàm xử lý khi bấm gửi
  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      // Lưu lại text rồi xóa trắng khung nhập liệu ngay cho mượt
      String text = _messageController.text;
      _messageController.clear();

      // Gọi service đẩy lên Firebase
      await _chatService.sendMessage(widget.receiverId, text);
    }
  }

  // Hàm hiển thị hộp thoại xác nhận xóa
  void _showDeleteConfirmDialog(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Xóa tin nhắn", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Bạn có chắc chắn muốn thu hồi tin nhắn này không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                // Gọi hàm xóa và đóng hộp thoại
                _chatService.deleteMessage(widget.receiverId, messageId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("Thu hồi", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Dữ liệu giả (Mock Data) để dựng UI trước khi nối Firebase
  final List<Map<String, dynamic>> _dummyMessages = [
    {"text": "Hey, what's up?", "isMe": true, "time": "12:00 PM"},
    {"text": "Not much", "isMe": false, "time": "12:01 PM"},
    {"text": "Wanna hang out?", "isMe": false, "time": "12:01 PM"},
    {"text": "What about drinks tomorrow at 7?", "isMe": true, "time": "12:05 PM"},
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Lấy thông tin user hiện tại và tạo Room ID
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final roomId = ChatHelper.getChatRoomId(currentUserId, widget.receiverId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 2. Vùng hiển thị tin nhắn (Lắng nghe từ Firestore)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Lắng nghe dữ liệu trong sub-collection 'messages', sắp xếp theo thời gian
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(roomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true) // Sắp xếp tin nhắn mới nhất lên trước
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Lỗi tải tin nhắn"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                Future.microtask(() {
                  _chatService.markMessagesAsRead(widget.receiverId);
                });

                if (messages.isEmpty) {
                  return const Center(
                    child: Text("Hãy gửi lời chào đầu tiên!", style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  reverse: true, // Đảo ngược ListView để tin nhắn mới nhất nằm ở dưới cùng
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var msgData = messages[index].data() as Map<String, dynamic>;
                    String messageId = messages[index].id; // Lấy ID của tin nhắn từ Firestore

                    // Kiểm tra xem tin nhắn này là của mình hay của đối phương
                    bool isMe = msgData['senderId'] == currentUserId;

                    // Gọi hàm Format vừa viết
                    String formattedTime = DateFormatter.formatTimestamp(msgData['timestamp'] as Timestamp?);

                    return _buildMessageBubble(
                      text: msgData['message'] ?? '',
                      isMe: isMe,
                      avatarUrl: isMe ? null : widget.receiverAvatarUrl,
                      time: formattedTime, // Truyền vào đây
                      onLongPress: isMe ? () => _showDeleteConfirmDialog(context, messageId) : null,
                    );
                  },
                );
              },
            ),
          ),

          // Khu vực nhập tin nhắn (Giữ nguyên)
          _buildMessageInput(),
        ],
      ),
    );
  }

  // --- Các Widget con ---

  // Header (AppBar)
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.messengerBlue),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.receiverName, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
          const Text("Active Now", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Icons.phone, color: AppColors.messengerBlue), onPressed: () {}),
        IconButton(icon: const Icon(Icons.videocam, color: AppColors.messengerBlue), onPressed: () {}),
      ],
    );
  }

  // Khung nhập liệu (Footer)
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            const Icon(Icons.add_circle, color: AppColors.messengerBlue, size: 28),
            const SizedBox(width: 10),
            const Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 24),
            const SizedBox(width: 10),
            const Icon(Icons.photo_outlined, color: Colors.grey, size: 24),
            const SizedBox(width: 10),
            const Icon(Icons.mic_none, color: Colors.grey, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row( // Bọc Row để chứa TextField và Nút gửi
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: "Aa",
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) => _sendMessage(), // Gửi khi ấn Enter trên bàn phím
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: AppColors.messengerBlue),
                          onPressed: _sendMessage, // Gửi khi bấm nút
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Thêm biến time vào tham số
  Widget _buildMessageBubble({required String text, required bool isMe, String? avatarUrl, required String time, VoidCallback? onLongPress,}) {
    return GestureDetector(
        onLongPress: onLongPress, // Bắt sự kiện ở đây
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe && avatarUrl != null) ...[
                CircleAvatar(radius: 12, backgroundImage: NetworkImage(avatarUrl)),
                const SizedBox(width: 8),
              ],

              Flexible(
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.messengerBlue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(text, style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 16)),
                    ),
                    const SizedBox(height: 4),
                    // HIỂN THỊ THỜI GIAN NHỎ Ở DƯỚI BONG BÓNG CHAT
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}