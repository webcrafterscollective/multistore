// lib/core/routes/app_pages.dart (Updated with splash and proper middleware)
import 'package:get/get.dart';
import '../../presentation/pages/customer/product/product_detail_page.dart';
import '../../presentation/pages/customer/store/store_detail_page.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/auth/welcome_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/vendor_register_page.dart';
import '../../presentation/pages/auth/customer_register_page.dart';
import '../../presentation/pages/dashboard/vendor_dashboard_page.dart';
import '../../presentation/pages/dashboard/customer_dashboard_page.dart';
import '../../data/models/auth/user_type.dart';
import '../bindings/app_binding.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/guest_middleware.dart';
import '../middleware/token_refresh_middleware.dart';
import '../middleware/user_type_middleware.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    // Splash screen - no middleware needed
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: AppBinding(),
      transition: Transition.fadeIn,
    ),

    // Initial route redirects to welcome
    GetPage(
      name: AppRoutes.initial,
      page: () => const WelcomePage(),
      binding: AppBinding(),
      transition: Transition.fadeIn,
      middlewares: [
        TokenRefreshMiddleware(),
        GuestMiddleware(),
      ],
    ),

    // Welcome page - public route
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomePage(),
      binding: AppBinding(),
      transition: Transition.fadeIn,
      middlewares: [
        TokenRefreshMiddleware(),
        GuestMiddleware(),
      ],
    ),

    // Public authentication routes
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AppBinding(),
      transition: Transition.rightToLeft,
      middlewares: [
        TokenRefreshMiddleware(),
        GuestMiddleware(),
      ],
    ),

    GetPage(
      name: AppRoutes.vendorRegister,
      page: () => const VendorRegisterPage(),
      binding: AppBinding(),
      transition: Transition.rightToLeft,
      middlewares: [
        TokenRefreshMiddleware(),
        GuestMiddleware(),
      ],
    ),

    GetPage(
      name: AppRoutes.customerRegister,
      page: () => const CustomerRegisterPage(),
      binding: AppBinding(),
      transition: Transition.rightToLeft,
      middlewares: [
        TokenRefreshMiddleware(),
        GuestMiddleware(),
      ],
    ),

    // Protected routes - require authentication
    GetPage(
      name: AppRoutes.vendorDashboard,
      page: () => const VendorDashboardPage(),
      binding: AppBinding(),
      transition: Transition.fadeIn,
      middlewares: [
        TokenRefreshMiddleware(),
        AuthMiddleware(),
        UserTypeMiddleware(UserType.vendor),
      ],
    ),

    GetPage(
      name: AppRoutes.customerDashboard,
      page: () => const CustomerDashboardPage(),
      binding: AppBinding(),
      transition: Transition.fadeIn,
      middlewares: [
        TokenRefreshMiddleware(),
        AuthMiddleware(),
        UserTypeMiddleware(UserType.customer),
      ],
    ),

    GetPage(
      name: AppRoutes.storeDetail,
      page: () => const StoreDetailPage(),
      binding: AppBinding(),
      transition: Transition.rightToLeft,
      middlewares: [
        TokenRefreshMiddleware(),
        AuthMiddleware(),
        UserTypeMiddleware(UserType.customer),
      ],
    ),

    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailPage(),
      binding: AppBinding(),
      transition: Transition.rightToLeft,
      middlewares: [
        TokenRefreshMiddleware(),
        AuthMiddleware(),
        UserTypeMiddleware(UserType.customer),
      ],
    ),

    // // Profile route - accessible by both user types
    // GetPage(
    //   name: AppRoutes.profile,
    //   page: () => const ProfilePage(),
    //   binding: AppBinding(),
    //   transition: Transition.rightToLeft,
    //   middlewares: [
    //     TokenRefreshMiddleware(),
    //     AuthMiddleware(),
    //   ],
    // ),
    //
    // // Vendor-specific protected routes
    // GetPage(
    //   name: AppRoutes.products,
    //   page: () => const ProductsPage(),
    //   binding: AppBinding(),
    //   transition: Transition.rightToLeft,
    //   middlewares: [
    //     TokenRefreshMiddleware(),
    //     AuthMiddleware(),
    //     UserTypeMiddleware(UserType.vendor),
    //   ],
    // ),
    //
    // GetPage(
    //   name: AppRoutes.orders,
    //   page: () => const OrdersPage(),
    //   binding: AppBinding(),
    //   transition: Transition.rightToLeft,
    //   middlewares: [
    //     TokenRefreshMiddleware(),
    //     AuthMiddleware(),
    //     UserTypeMiddleware(UserType.vendor),
    //   ],
    // ),
    //
    // GetPage(
    //   name: AppRoutes.customers,
    //   page: () => const CustomersPage(),
    //   binding: AppBinding(),
    //   transition: Transition.rightToLeft,
    //   middlewares: [
    //     TokenRefreshMiddleware(),
    //     AuthMiddleware(),
    //     UserTypeMiddleware(UserType.vendor),
    //   ],
    // ),
    //
    // GetPage(
    //   name: AppRoutes.categories,
    //   page: () => const CategoriesPage(),
    //   binding: AppBinding(),
    //   transition: Transition.rightToLeft,
    //   middlewares: [
    //     TokenRefreshMiddleware(),
    //     AuthMiddleware(),
    //     UserTypeMiddleware(UserType.vendor),
    //   ],
    // ),
  ];
}