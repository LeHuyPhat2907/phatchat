import 'package:flutter/material.dart';
import '../../utils/app_constants.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 1. Logo (Cố định chiều cao một chút)
              Image.asset('assets/images/logo.png', height: 210),

              // 2. PHẦN QUAN TRỌNG: Hình minh họa co giãn
              // Expanded sẽ "hút" hết khoảng trống ở giữa và co giãn ảnh bên trong
              Expanded(
                flex: 5, // Chiếm tỷ trọng lớn nhất
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/onboarding_illustration.png',
                    fit: BoxFit.contain, // Ảnh luôn co lại để không bị vỡ/tràn
                  ),
                ),
              ),

              // 3. Phần Nội dung chữ (Gói trong một Widget cố định hoặc Flexible)
              Flexible(
                flex: 3,
                child: Column(
                  children: [
                    const Text(
                      "Chào mừng đến với\nPhatChat",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Nhắn tin, chia sẻ hình ảnh và tập tin với bạn bè một cách dễ dàng",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: AppColors.darkGray),
                    ),
                  ],
                ),
              ),

              // 4. Nút bấm (Luôn nằm ở dưới cùng)
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.messengerBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Đăng nhập", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}