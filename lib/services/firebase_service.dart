import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirebaseService {
  // Hàm static để gọi mà không cần khởi tạo class
  static Future<void> setupFirebase() async {
    // Đảm bảo Flutter framework đã sẵn sàng

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print("Firebase đã khởi tạo thành công cho PhatChat!");
  }
}