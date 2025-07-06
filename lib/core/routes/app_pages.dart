// lib/core/routes/app_pages.dart
import 'package:get/get.dart';
import '../../presentation/pages/auth/welcome_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/vendor_register_page.dart';
import '../../presentation/pages/auth/customer_register_page.dart';
import '../../presentation/pages/dashboard/vendor_dashboard_page.dart';
import '../../presentation/pages/dashboard/customer_dashboard_page.dart';
// import '../../presentation/pages/profile/profile_page.dart';
import '../bindings/app_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const WelcomePage(),
      binding: AppBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AppBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.vendorRegister,
      page: () => const VendorRegisterPage(),
      binding: AppBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.customerRegister,
      page: () => const CustomerRegisterPage(),
      binding: AppBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.vendorDashboard,
      page: () => const VendorDashboardPage(),
      binding: AppBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.customerDashboard,
      page: () => const CustomerDashboardPage(),
      binding: AppBinding(),
      transition: Transition.fadeIn,
    ),
    // GetPage(
    //   name: AppRoutes.profile,
    //   page: () => const ProfilePage(),
    //   binding: AppBinding(),
    //   transition: Transition.rightToLeft,
    // ),
  ];
}