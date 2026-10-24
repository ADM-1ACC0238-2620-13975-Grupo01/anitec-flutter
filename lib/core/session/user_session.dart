/// Roles exactly as the API names them.
enum UserRole {
  rancher('Rancher'),
  veterinarian('Veterinarian');

  const UserRole(this.apiValue);

  final String apiValue;

  static UserRole? fromApi(String? value) {
    for (final role in values) {
      if (role.apiValue.toLowerCase() == value?.toLowerCase()) return role;
    }
    return null;
  }
}

class UserSession {
  const UserSession({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.role,
    required this.token,
    this.email,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
    userId: (json['userId'] as num).toInt(),
    username: json['username'] as String,
    fullName: json['fullName'] as String,
    role: UserRole.fromApi(json['role'] as String?)!,
    token: json['token'] as String,
    email: json['email'] as String?,
  );

  final int userId;
  final String username;
  final String fullName;
  final UserRole role;
  final String token;
  final String? email;

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'username': username,
    'fullName': fullName,
    'role': role.apiValue,
    'token': token,
    'email': email,
  };
}
