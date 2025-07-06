// lib/core/middleware/token_refresh_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/providers/api_client.dart';
import '../constants/app_constants.dart';
import '../routes/app_routes.dart';

class TokenRefreshMiddleware extends GetMiddleware {
  @override
  int? get priority => 0; // Highest priority

  @override
  RouteSettings? redirect(String? route) {
    final apiClient = Get.find<ApiClient>();
    final storage = GetStorage();

    final token = apiClient.getToken();
    if (token != null) {
      // Check if token is expired (you can implement JWT decode here)
      // For now, we'll just validate that the token exists and is properly formatted
      if (_isTokenValid(token)) {
        print('✅ Token Refresh Middleware - Token is valid');
        return null;
      } else {
        print('🚫 Token Refresh Middleware - Invalid token, clearing auth data');
        _clearAuthData(apiClient, storage);
        return const RouteSettings(name: AppRoutes.initial);
      }
    }

    return null;
  }

  bool _isTokenValid(String token) {
    // Basic validation - check if token is not empty and has reasonable length
    if (token.isEmpty || token.length < 10) {
      return false;
    }

    // You can add more sophisticated validation here:
    // - JWT token validation
    // - Expiry check
    // - Format validation

    return true;
  }

  void _clearAuthData(ApiClient apiClient, GetStorage storage) {
    apiClient.clearToken();
    storage.remove(AppConstants.userDataKey);
    storage.remove(AppConstants.userTypeKey);
  }
}