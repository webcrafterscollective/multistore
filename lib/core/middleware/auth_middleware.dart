// lib/core/middleware/auth_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/providers/api_client.dart';
import '../../data/models/auth/user_type.dart';
import '../constants/app_constants.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  final GetStorage _storage = GetStorage();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final apiClient = Get.find<ApiClient>();
    final token = apiClient.getToken();
    final userData = _storage.read(AppConstants.userDataKey);
    final userTypeString = _storage.read(AppConstants.userTypeKey);

    print('🔍 Auth Middleware - Route: $route');
    print('🔍 Auth Middleware - Token exists: ${token != null}');
    print('🔍 Auth Middleware - User data exists: ${userData != null}');
    print('🔍 Auth Middleware - User type: $userTypeString');

    final isAuthenticated = token != null && userData != null && userTypeString != null;

    // Define protected routes that require authentication
    final protectedRoutes = [
      AppRoutes.vendorDashboard,
      AppRoutes.customerDashboard,
      AppRoutes.profile,
      AppRoutes.products,
      AppRoutes.orders,
      AppRoutes.customers,
      AppRoutes.categories,
    ];

    // Define public routes that don't require authentication
    final publicRoutes = [
      AppRoutes.initial,
      AppRoutes.login,
      AppRoutes.vendorRegister,
      AppRoutes.customerRegister,
    ];

    // If user is trying to access a protected route without authentication
    if (protectedRoutes.contains(route) && !isAuthenticated) {
      print('🚫 Auth Middleware - Redirecting to welcome (not authenticated)');
      return const RouteSettings(name: AppRoutes.initial);
    }

    // If user is authenticated and trying to access public routes
    if (publicRoutes.contains(route) && isAuthenticated) {
      final userType = UserType.values.firstWhere(
            (type) => type.name == userTypeString,
        orElse: () => UserType.customer,
      );

      final dashboardRoute = userType == UserType.vendor
          ? AppRoutes.vendorDashboard
          : AppRoutes.customerDashboard;

      print('🔄 Auth Middleware - Redirecting to dashboard ($dashboardRoute)');
      return RouteSettings(name: dashboardRoute);
    }

    // Allow access to the requested route
    print('✅ Auth Middleware - Allowing access to $route');
    return null;
  }
}