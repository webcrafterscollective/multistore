// lib/data/models/auth/login_response.dart
import 'user_profile.dart';
import 'user_type.dart';

class UnifiedLoginResponse {
  final String status;
  final String message;
  final UnifiedLoginData data;

  UnifiedLoginResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UnifiedLoginResponse.fromJson(Map<String, dynamic> json, UserType userType) {
    return UnifiedLoginResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: UnifiedLoginData.fromJson(json['data'] ?? {}, userType),
    );
  }
}

class UnifiedLoginData {
  final UserProfile user;
  final String token;

  UnifiedLoginData({
    required this.user,
    required this.token,
  });

  factory UnifiedLoginData.fromJson(Map<String, dynamic> json, UserType userType) {
    return UnifiedLoginData(
      user: userType == UserType.vendor
          ? UserProfile.fromVendorJson(json)
          : UserProfile.fromCustomerJson(json['user'] ?? {}),
      token: json['token'] ?? '',
    );
  }
}
