import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'utils/app_constants.dart'; // Import file màu sắc
import 'services/firebase_service.dart';
import 'views/auth/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gọi hàm khởi tạo từ FirebaseService
  await FirebaseService.setupFirebase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhatChat',
      debugShowCheckedModeBanner: false, // Tắt cái nhãn "Debug" ở gốc app
      theme: ThemeData(
        useMaterial3: true,
        // Màu chủ đạo cho toàn app
        primaryColor: AppColors.messengerBlue,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.messengerBlue,
        ),
        
        // Cấu hình font chữ mặc định
        fontFamily: 'Roboto', // Có thể thêm font khác sau
      ),
      home: OnboardingScreen(),
      );
  }
}