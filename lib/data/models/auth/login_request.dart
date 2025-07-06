// lib/data/models/auth/login_request.dart
import 'user_type.dart';

class LoginRequest {
  final String email;
  final String password;
  final UserType userType;

  LoginRequest({
    required this.email,
    required this.password,
    required this.userType,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}