import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  // Khởi tạo instance của Firebase Storage
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Hàm upload ảnh lên Firebase Storage và trả về đường dẫn tải xuống (Download URL)
  /// [file]: File ảnh lấy từ thiết bị (ImagePicker)
  /// [folderName]: Tên thư mục chứa ảnh trên Firebase (VD: 'avatars' hoặc 'chat_images')
  Future<String?> uploadImage(File file, String folderName) async {
    try {
      // 1. Tạo tên file độc nhất bằng cách lấy thời gian hiện tại (tính bằng mili-giây)
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // 2. Chỉ định vị trí lưu trên Storage (Ví dụ: avatars/17123456789.jpg)
      Reference ref = _storage.ref().child(folderName).child(fileName);

      // 3. Tiến hành đẩy (upload) file lên Firebase
      UploadTask uploadTask = ref.putFile(file);

      // Đợi tiến trình upload hoàn tất
      TaskSnapshot snapshot = await uploadTask;

      // 4. Lấy URL công khai của bức ảnh để lưu vào Database hoặc hiển thị
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;

    } catch (e) {
      print("Lỗi khi upload ảnh lên Storage: $e");
      return null;
    }
  }
}