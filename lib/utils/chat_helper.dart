class ChatHelper {
  // Hàm tạo Room ID duy nhất cho 2 người dùng
  static String getChatRoomId(String uid1, String uid2) {
    // So sánh mã ASCII của 2 chuỗi
    if (uid1.compareTo(uid2) > 0) {
      return "${uid1}_$uid2";
    } else {
      return "${uid2}_$uid1";
    }
  }
}