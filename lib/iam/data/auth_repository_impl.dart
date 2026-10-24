import 'package:dio/dio.dart';

import '../../core/network/app_error.dart';
import '../../core/session/user_session.dart';
import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserSession> signIn(String username, String password) =>
      guardApi(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          'authentication/sign-in',
          data: {'username': username, 'password': password},
        );
        final json = response.data!;
        final role = UserRole.fromApi(json['role'] as String?);
        if (role == null) {
          throw AppException(UnknownError('Unsupported role: ${json['role']}'));
        }
        final fullName = (json['fullName'] as String?) ?? '';
        return UserSession(
          userId: (json['id'] as num).toInt(),
          username: json['username'] as String,
          fullName: fullName.isEmpty ? json['username'] as String : fullName,
          role: role,
          token: json['token'] as String,
          email: json['email'] as String?,
        );
      });
}
