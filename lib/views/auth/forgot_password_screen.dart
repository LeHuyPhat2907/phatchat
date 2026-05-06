import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/app_constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _handleResetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng nhập email!")));
      return;
    }

    setState(() => _isLoading = true);
    String? result = await _authService.sendPasswordReset(_emailController.text.trim());
    setState(() => _isLoading = false);

    if (result == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Link đặt lại mật khẩu đã được gửi vào Email của bạn!")),
      );
      Navigator.pop(context); // Gửi xong thì quay lại màn Login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result ?? "Có lỗi xảy ra")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quên mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Text("Nhập email của bạn, chúng tôi sẽ gửi liên kết để đặt lại mật khẩu.", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Nhập email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleResetPassword,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.messengerBlue),
                child: _isLoading ? const CircularProgressIndicator() : const Text("Gửi yêu cầu", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}