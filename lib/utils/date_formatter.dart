import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatTimestamp(Timestamp? timestamp) {
    // Xử lý trường hợp FieldValue.serverTimestamp() chưa kịp trả về từ server
    if (timestamp == null) return 'Đang gửi...';

    DateTime date = timestamp.toDate();
    DateTime now = DateTime.now();

    // 1. Cùng ngày -> Hiện giờ (VD: 10:30)
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return DateFormat('HH:mm').format(date);
    }

    // 2. Trong vòng 7 ngày -> Hiện Thứ (VD: Thứ 2)
    Duration difference = now.difference(date);
    if (difference.inDays < 7) {
      switch (date.weekday) {
        case 1: return 'Thứ 2';
        case 2: return 'Thứ 3';
        case 3: return 'Thứ 4';
        case 4: return 'Thứ 5';
        case 5: return 'Thứ 6';
        case 6: return 'Thứ 7';
        case 7: return 'CN';
      }
    }

    // 3. Khác ngày & quá 7 ngày -> Hiện ngày tháng (VD: 15/07/2026)
    return DateFormat('dd/MM/yyyy').format(date);
  }
}