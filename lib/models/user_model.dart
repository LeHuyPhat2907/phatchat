class UserModel {
  final String uid;
  final String email;
  final String name;
  final String avatarUrl;
  final String status;
  final DateTime lastSeen;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.avatarUrl,
    required this.status,
    required this.lastSeen,
  });

  // Chuyển dữ liệu từ Map (Firestore) sang Model
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      status: data['status'] ?? 'offline',
      lastSeen: (data['lastSeen'] != null)
          ? data['lastSeen'].toDate()
          : DateTime.now(),
    );
  }

  // Chuyển từ Model sang Map để đẩy lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'status': status,
      'lastSeen': lastSeen,
    };
  }
}