import 'package:flutter/material.dart';
import '../../utils/app_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 1; // Quản lý bước hiện tại (1, 2, hoặc 3)

  // Controllers cho các ô nhập liệu
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 1 && _currentStep < 3
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => setState(() => _currentStep--),
        )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: _buildStepContent(),
        ),
      ),
    );
  }

  // Hàm điều hướng hiển thị nội dung theo từng bước
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1: return _buildStep1();
      case 2: return _buildStep2();
      case 3: return _buildStep3();
      default: return _buildStep1();
    }
  }

  // --- BƯỚC 1: ĐIỀN THÔNG TIN HỒ SƠ ---
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(child: Text("Đăng ký tài khoản", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
        const SizedBox(height: 30),
        const Text("1 of 2", style: TextStyle(color: AppColors.darkGray)),
        const Text("Điền thông tin hồ sơ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("Vui lòng điền thông tin hồ sơ của bạn trước", style: TextStyle(color: AppColors.darkGray)),
        const SizedBox(height: 30),

        Center(
          child: const Text("Ảnh đại diện", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),



        // Avatar Picker (Tạm thời là icon)
        Center(
          child: Stack(
            children: [
              CircleAvatar(radius: 40, backgroundColor: AppColors.lightGray, child: Icon(Icons.person, size: 40, color: AppColors.darkGray)),
              Positioned(bottom: 0, right: 0, child: CircleAvatar(radius: 12, backgroundColor: AppColors.black, child: Icon(Icons.edit, size: 12, color: Colors.white))),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildTextField("Email của bạn", _emailController, hint: "nicholashyde@caza.com"),
        _buildTextField("Tên", _firstNameController, hint: "Your first name"),
        _buildTextField("Họ", _lastNameController, hint: "Your last name"),

        const SizedBox(height: 40),
        _buildButton("Next", () => setState(() => _currentStep = 2)),
      ],
    );
  }

  // --- BƯỚC 2: NHẬP MẬT KHẨU ---
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(child: Text("Đăng ký tài khoản", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
        const SizedBox(height: 30),
        const Text("2 of 2", style: TextStyle(color: AppColors.darkGray)),
        const Text("Nhập mật khẩu của bạn", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        _buildTextField("Mật khẩu mới", _passController, isPass: true),
        _buildTextField("Xác nhận lại mật khẩu mới", _confirmPassController, isPass: true),

        const SizedBox(height: 40),
        _buildButton("Đăng ký", () => setState(() => _currentStep = 3)),
        const SizedBox(height: 10),
        Center(
          child: OutlinedButton(
            onPressed: () => setState(() => _currentStep = 1),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white, // nền trắng
              side: BorderSide(color: Colors.black), // viền đen
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // vuông góc (không bo)
              ),
              fixedSize: Size(400, 50), // hình vuông
            ),
            child: Text(
              "Quay lại",
              style: TextStyle(color: AppColors.black),
            ),
          ),
        )
      ],
    );
  }

  // --- BƯỚC 3: THÀNH CÔNG ---
  Widget _buildStep3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        const CircleAvatar(radius: 40, backgroundColor: AppColors.messengerBlue, child: Icon(Icons.check, size: 50, color: Colors.white)),
        const SizedBox(height: 30),
        const Text("Đăng ký tài khoản thành công", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        const Text("Nhấn vào nút đăng nhập bên dưới để vào ứng dụng", textAlign: TextAlign.center, style: TextStyle(color: AppColors.darkGray)),
        const SizedBox(height: 50),
        _buildButton("Đăng nhập", () => Navigator.pop(context)),
      ],
    );
  }

  // Widget dùng chung để vẽ TextField cho gọn code
  Widget _buildTextField(String label, TextEditingController controller, {String? hint, bool isPass = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: isPass,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: AppColors.white,
              suffixIcon: isPass ? const Icon(Icons.visibility_off) : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightGray)),
            ),
          ),
        ],
      ),
    );
  }

  // Widget dùng chung cho Button
  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.messengerBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}