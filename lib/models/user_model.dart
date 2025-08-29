class UserModel {
  final String name;
  final String shopName;
  final String email;
  final String phone;
  final String location;

  UserModel({
    required this.name,
    required this.shopName,
    required this.email,
    required this.phone,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'shopName': shopName,
      'email': email,
      'phone': phone,
      'location': location,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      shopName: json['shopName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
    );
  }

  // // For demo purposes, we'll use a static user
  // static UserModel get demoUser => UserModel(
  //   name: 'Ahmed Rahman',
  //   shopName: 'Rahman Agro Store',
  //   email: 'ahmed.rahman@email.com',
  //   phone: '+880 1712-345678',
  //   location: 'Dhaka, Bangladesh',
  // );
}
