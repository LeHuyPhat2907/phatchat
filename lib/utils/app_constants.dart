import 'package:flutter/material.dart';

class AppColors {
  // Màu xanh đặc trưng của Messenger
  static const Color messengerBlue = Color(0xFF0084FF);

  // Các tông màu hỗ trợ
  static const Color lightGray = Color(0xFFF0F0F0);
  static const Color darkGray = Color(0xFF8E8E93);
  static const Color black = Colors.black;
  static const Color white = Colors.white;

  // Màu trạng thánh Online
  static const Color onlineGreen = Color(0xFF44B700);
}

class AppTextStyles {
  static const TextStyle header = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.black,
  );
}