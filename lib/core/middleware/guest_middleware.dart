// lib/core/middleware/guest_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/auth/user_type.dart';
import '../../data/providers/api_client.dart';
import '../constants/app_constants.dart';
import '../routes/app_routes.dart';

class GuestMiddleware extends GetMiddleware {
  final GetStorage _storage = GetStorage();

  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    final apiClient = Get.find<ApiClient>();
    final token = apiClient.getToken();
    final userData = _storage.read(AppConstants.userDataKey);
    final userTypeString = _storage.read(AppConstants.userTypeKey);

    final isAuthenticated = token != null && userData != null && userTypeString != null;

    // If user is authenticated, redirect to appropriate dashboard
    if (isAuthenticated) {
      final userType = UserType.values.firstWhere(
            (type) => type.name == userTypeString,
        orElse: () => UserType.customer,
      );

      final dashboardRoute = userType == UserType.vendor
          ? AppRoutes.vendorDashboard
          : AppRoutes.customerDashboard;

      print('🔄 Guest Middleware - Redirecting authenticated user to $dashboardRoute');
      return RouteSettings(name: dashboardRoute);
    }

    return null;
  }
}
