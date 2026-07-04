import 'package:cloud_firestore/cloud_firestore.dart';

// 1. Model cho Tin nhắn con (Nằm trong sub-collection 'messages')
class MessageModel {
  final String senderId;
  final String receiverId;
  final String message;
  final String type;
  final Timestamp timestamp;
  final bool isRead;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.type = 'text', // Mặc định là text
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'type': type, // Lưu type lên Firebase
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'text',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      isRead: map['isRead'] ?? false,
    );
  }
}

// 2. Model cho Phòng chat (Nằm trong collection 'chat_rooms')
class ChatRoomModel {
  final String roomId;
  final List<String> users; // Chứa UID của cả 2 người để dễ query
  final String lastMessage;
  final Timestamp lastMessageTime;

  ChatRoomModel({
    required this.roomId,
    required this.users,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'users': users,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      roomId: map['roomId'] ?? '',
      users: List<String>.from(map['users'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] ?? Timestamp.now(),
    );
  }
}