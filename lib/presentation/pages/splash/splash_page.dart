// lib/presentation/pages/splash/splash_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/app_initialization_service.dart';
import '../../../data/models/auth/user_type.dart';
import '../../controllers/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeAndRedirect();
  }

  Future<void> _initializeAndRedirect() async {
    try {
      // Get initialization service
      final initService = Get.find<AppInitializationService>();
      final authController = Get.find<AuthController>();

      // Wait for initialization to complete
      while (!initService.isInitialized.value) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Wait for auth initialization
      while (!authController.isInitialized.value) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Add minimum splash duration for better UX
      await Future.delayed(const Duration(seconds: 2));

      // Navigate based on authentication state
      if (authController.isLoggedIn.value && authController.currentUserType.value != null) {
        final dashboardRoute = authController.currentUserType.value == UserType.vendor
            ? '/vendor-dashboard'
            : '/customer-dashboard';

        print('🔄 Splash: Redirecting authenticated user to $dashboardRoute');
        Get.offAllNamed(dashboardRoute);
      } else {
        print('🔄 Splash: Redirecting to welcome page');
        Get.offAllNamed('/welcome');
      }

    } catch (e) {
      print('❌ Splash initialization error: $e');
      // Fallback to welcome page
      Get.offAllNamed('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.store,
                  size: 60,
                  color: AppColors.primary,
                ),
              ).animate().scale(
                duration: 800.ms,
                curve: Curves.elasticOut,
              ),

              const SizedBox(height: 40),

              // App Name
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms).slideY(
                begin: 0.3,
                duration: 600.ms,
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                AppStrings.welcomeSubtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms).slideY(
                begin: 0.3,
                duration: 600.ms,
              ),

              const SizedBox(height: 60),

              // Loading Indicator
              Obx(() {
                final initService = Get.find<AppInitializationService>();
                final authController = Get.find<AuthController>();

                return Column(
                  children: [
                    // Custom loading animation
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                        strokeWidth: 3,
                      ),
                    ).animate().fadeIn(delay: 800.ms),

                    const SizedBox(height: 24),

                    // Status text
                    Text(
                      _getStatusText(initService, authController),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 1000.ms),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(AppInitializationService initService, AuthController authController) {
    if (!initService.isInitialized.value) {
      return 'Initializing app...';
    }

    if (!authController.isInitialized.value) {
      return 'Checking authentication...';
    }

    if (authController.isLoggedIn.value) {
      return 'Welcome back! Loading your dashboard...';
    }

    return 'Ready! Redirecting...';
  }
}
