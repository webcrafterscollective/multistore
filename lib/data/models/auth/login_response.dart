// lib/data/models/auth/login_response.dart
import 'user_profile.dart';
import 'user_type.dart';

class UnifiedLoginResponse {
  final String status;
  final String message;
  final UnifiedLoginData? data;

  UnifiedLoginResponse({
    required this.status,
    this.message = '',
    this.data,
  });

  factory UnifiedLoginResponse.fromJson(Map<String, dynamic> json, UserType userType) {
    return UnifiedLoginResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? UnifiedLoginData.fromJson(json, userType)
          : null,
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
    // Extract token from the response
    String token = '';

    // Handle different response structures for token
    if (json.containsKey('token')) {
      token = json['token'] ?? '';
    } else if (json['data'] != null && json['data']['token'] != null) {
      token = json['data']['token'] ?? '';
    }

    // Create user profile based on user type
    UserProfile user;
    if (userType == UserType.vendor) {
      // For vendor, the user data is directly in the 'data' field
      user = UserProfile.fromVendorJson(json);
    } else {
      // For customer, check if user data is nested
      final userData = json['data']?['user'] ?? json['data'] ?? json;
      user = UserProfile.fromCustomerJson(userData);
    }

    return UnifiedLoginData(
      user: user,
      token: token,
    );
  }
}