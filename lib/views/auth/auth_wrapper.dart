import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../main/main_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // Lắng nghe sự thay đổi trạng thái đăng nhập từ Firebase
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. Nếu đang kết nối (đang kiểm tra)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Nếu đã có dữ liệu người dùng (Đã login)
          if (snapshot.hasData) {
            return const MainScreen();
          }

          // 3. Nếu chưa login
          return const LoginScreen();
        },
      ),
    );
  }
}