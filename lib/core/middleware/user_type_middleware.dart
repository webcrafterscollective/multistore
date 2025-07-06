// lib/core/middleware/user_type_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/auth/user_type.dart';
import '../constants/app_constants.dart';
import '../routes/app_routes.dart';

class UserTypeMiddleware extends GetMiddleware {
  final UserType requiredUserType;

  UserTypeMiddleware(this.requiredUserType);

  @override
  int? get priority => 3;

  @override
  RouteSettings? redirect(String? route) {
    final storage = GetStorage();
    final userTypeString = storage.read(AppConstants.userTypeKey);

    if (userTypeString == null) {
      print('🚫 UserType Middleware - No user type found, redirecting to welcome');
      return const RouteSettings(name: AppRoutes.initial);
    }

    final currentUserType = UserType.values.firstWhere(
          (type) => type.name == userTypeString,
      orElse: () => UserType.customer,
    );

    if (currentUserType != requiredUserType) {
      final correctDashboard = currentUserType == UserType.vendor
          ? AppRoutes.vendorDashboard
          : AppRoutes.customerDashboard;

      print('🚫 UserType Middleware - Wrong user type, redirecting to $correctDashboard');
      return RouteSettings(name: correctDashboard);
    }

    return null;
  }
}