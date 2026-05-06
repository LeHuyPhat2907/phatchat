import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Khai báo Firestore

  // Hàm Đăng ký tài khoản
  Future<String?> registerWithEmail(String email, String password, String name) async {
    try {
      // 1. Tạo user trên Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Nếu thành công, tạo tiếp Document trên Firestore
      if (credential.user != null) {
        UserModel newUser = UserModel(
          uid: credential.user!.uid,
          email: email,
          name: name,
          avatarUrl: "", // Tạm thời để trống, sẽ làm ở Task upload ảnh sau
          status: "online",
          lastSeen: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(newUser.toMap());
      }
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

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "Không tìm thấy tài khoản với email này.";
      } else if (e.code == 'invalid-email') {
        return "Định dạng email không hợp lệ.";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}

