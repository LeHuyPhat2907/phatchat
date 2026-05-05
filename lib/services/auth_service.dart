import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Hàm Đăng ký tài khoản
  Future<String?> registerWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "success"; // Đăng ký thành công
    } on FirebaseAuthException catch (e) {
      // Xử lý các lỗi cụ thể từ Firebase
      if (e.code == 'weak-password') {
        return "Mật khẩu quá yếu, bạn nên đặt trên 6 ký tự.";
      } else if (e.code == 'email-already-in-use') {
        return "Email này đã được sử dụng cho một tài khoản khác.";
      } else if (e.code == 'invalid-email') {
        return "Định dạng email không hợp lệ.";
      }
      return e.message; // Các lỗi khác
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "success";
    } on FirebaseAuthException catch (e) {
      // Xử lý các lỗi đăng nhập phổ biến
      if (e.code == 'user-not-found') {
        return "Không tìm thấy người dùng với email này.";
      } else if (e.code == 'wrong-password') {
        return "Mật khẩu không chính xác.";
      } else if (e.code == 'invalid-email') {
        return "Định dạng email không hợp lệ.";
      }
      return "Lỗi đăng nhập: ${e.message}";
    } catch (e) {
      return e.toString();
    }
  }
}