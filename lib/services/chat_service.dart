import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_model.dart';
import '../utils/chat_helper.dart'; // Nơi chứa hàm getChatRoomId hôm trước
import 'dart:io';
import 'storage_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Hàm gửi tin nhắn
  Future<void> sendMessage(String receiverId, String messageText) async {
    try {
      final String currentUserId = _auth.currentUser!.uid;
      String roomId = ChatHelper.getChatRoomId(currentUserId, receiverId);

      // 1. Bắn dữ liệu lên sub-collection 'messages' với Server Timestamp
      await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .add({
        'senderId': currentUserId,
        'receiverId': receiverId,
        'message': messageText,
        'isRead': false,
        // ĐIỂM ĂN TIỀN CỦA TASK NÀY LÀ ĐÂY:
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. Cập nhật lại "vỏ" của phòng chat để màn hình bên ngoài đọc được
      await _firestore.collection('chat_rooms').doc(roomId).set({
        'roomId': roomId,
        'users': [currentUserId, receiverId],
        'lastMessage': messageText,
        // CẬP NHẬT LUÔN Ở ĐÂY ĐỂ ĐỒNG BỘ:
        'lastMessageTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

    } catch (e) {
      print("Lỗi khi gửi tin nhắn: $e");
    }
  }

  // Hàm đánh dấu tin nhắn là "Đã xem"
  Future<void> markMessagesAsRead(String receiverId) async {
    try {
      final String currentUserId = _auth.currentUser!.uid;
      String roomId = ChatHelper.getChatRoomId(currentUserId, receiverId);

      // 1. Tìm các tin nhắn trong phòng: Mình là người nhận & chưa đọc
      var unreadMessages = await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId) // Phải là tin nhắn gửi cho mình
          .where('isRead', isEqualTo: false)             // Và đang ở trạng thái chưa đọc
          .get();

      // 2. Dùng WriteBatch để cập nhật tất cả cùng lúc cho tối ưu
      if (unreadMessages.docs.isNotEmpty) {
        WriteBatch batch = _firestore.batch();

        for (var doc in unreadMessages.docs) {
          batch.update(doc.reference, {'isRead': true});
        }

        // Tiến hành ghi hàng loạt lên Firestore
        await batch.commit();
      }
    } catch (e) {
      print("Lỗi khi cập nhật trạng thái đã xem: $e");
    }
  }

  // Hàm xóa tin nhắn
  Future<void> deleteMessage(String receiverId, String messageId) async {
    try {
      final String currentUserId = _auth.currentUser!.uid;
      String roomId = ChatHelper.getChatRoomId(currentUserId, receiverId);

      // Gọi lệnh delete() chính xác vào ID của tin nhắn
      await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .delete();

    } catch (e) {
      print("Lỗi khi xóa tin nhắn: $e");
    }
  }

  // Hàm xử lý gửi tin nhắn hình ảnh
  Future<void> sendImageMessage(String receiverId, File imageFile) async {
    try {
      // 1. Dùng StorageService đẩy ảnh lên và lấy URL về
      String? imageUrl = await StorageService().uploadImage(imageFile, 'chat_images');

      if (imageUrl == null) return; // Nếu lỗi upload thì dừng lại

      final String currentUserId = _auth.currentUser!.uid;
      String roomId = ChatHelper.getChatRoomId(currentUserId, receiverId);

      // 2. Lưu tin nhắn vào collection 'messages' với type = 'image'
      await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .add({
        'senderId': currentUserId,
        'receiverId': receiverId,
        'message': imageUrl, // Lưu URL tải xuống vào nội dung
        'type': 'image',     // Đánh dấu đây là ảnh
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 3. Cập nhật hiển thị ngoài danh sách Chat (Home)
      await _firestore.collection('chat_rooms').doc(roomId).set({
        'roomId': roomId,
        'users': [currentUserId, receiverId],
        'lastMessage': '📸 Đã gửi một ảnh', // Hiện chữ thay vì hiện nguyên cái URL dài ngoằng
        'lastMessageTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

    } catch (e) {
      print("Lỗi khi gửi ảnh: $e");
    }
  }
}