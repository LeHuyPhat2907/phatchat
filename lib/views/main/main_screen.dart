import 'package:flutter/material.dart';
import '../../utils/app_constants.dart';
import '../chat/chat_list_screen.dart';
import '../people/people_screen.dart';
import '../profile/profile_screen.dart';
// Import các màn hình con của bạn ở đây

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với từng Tab
  final List<Widget> _pages = [
    const ChatListScreen(), // Thay bằng ChatListScreen()
    const PeopleScreen(),// Thay bằng PeopleScreen()
    const ProfileScreen(),  // Thay bằng ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // Thiết kế Bottom Navigation Bar bo tròn như trong hình
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20), // Tạo khoảng cách với mép màn hình
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.messengerBlue,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0, // Tắt bóng mặc định của BottomNavigationBar để dùng bóng của Container
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'People',
              ),
              BottomNavigationBarItem(
                icon: CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Avatar tạm
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}