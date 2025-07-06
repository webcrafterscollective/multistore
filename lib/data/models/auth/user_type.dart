// lib/data/models/auth/user_type.dart
import 'dart:ui';

import '../../../core/constants/app_colors.dart';

enum UserType {
  vendor,
  customer;

  String get displayName {
    switch (this) {
      case UserType.vendor:
        return 'Vendor';
      case UserType.customer:
        return 'Customer';
    }
  }

  String get apiPath {
    switch (this) {
      case UserType.vendor:
        return 'vendor';
      case UserType.customer:
        return 'user';
    }
  }

  Color get primaryColor {
    switch (this) {
      case UserType.vendor:
        return AppColors.vendorPrimary;
      case UserType.customer:
        return AppColors.customerPrimary;
    }
  }

  Color get secondaryColor {
    switch (this) {
      case UserType.vendor:
        return AppColors.vendorSecondary;
      case UserType.customer:
        return AppColors.customerSecondary;
    }
  }
}