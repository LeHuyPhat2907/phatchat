import 'package:flutter/material.dart';
import '../../utils/app_constants.dart';
import '../auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller để lấy dữ liệu từ các ô nhập
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // 2. Form nội dung
          SafeArea(
            child: Center(
              child: SingleChildScrollView( //Tránh lỗi tràn khi hiện bàn phím
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề
                    const Center(
                      child: Text(
                        "Chào mừng quay lại!",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Chúng tôi rất mong được gặp lại bạn!",
                        style: TextStyle(color: AppColors.darkGray, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 40),

                    const Text("Thông tin tài khoản",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 15),

                    // Ô nhập Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Nhập email",
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.lightGray),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Ô nhập Mật khẩu
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible, // Ẩn/hiện pass
                      decoration: InputDecoration(
                        hintText: "Mật khẩu",
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.lightGray),
                        ),
                      ),
                    ),

                    // Quên mật khẩu
                    TextButton(
                      onPressed: () {},
                      child: const Text("Bạn quên mật khẩu?",
                          style: TextStyle(color: AppColors.messengerBlue, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),

                    // Nút Đăng nhập
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // Logic đăng nhập sẽ làm ở Task 12
                          print("Email: ${_emailController.text}");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.messengerBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Đăng nhập",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));}, child: const Text("Bạn chưa có tài khoản? Đăng ký ngay."))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}