// lib/presentation/pages/auth/welcome_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
              AppColors.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and App Name
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

                // Welcome Text
                Text(
                  AppStrings.welcome,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w300,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(
                  begin: 0.3,
                  duration: 600.ms,
                ),

                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms).slideY(
                  begin: 0.3,
                  duration: 600.ms,
                ),

                const SizedBox(height: 16),

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

                const SizedBox(height: 80),

                // User Type Selection
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Choose Your Role',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Vendor Button
                      CustomButton(
                        text: 'Continue as Vendor',
                        backgroundColor: AppColors.vendorPrimary,
                        icon: Icons.store,
                        onPressed: () => Get.toNamed('/login?type=vendor'),
                      ),

                      const SizedBox(height: 16),

                      // Customer Button
                      CustomButton(
                        text: 'Continue as Customer',
                        backgroundColor: AppColors.customerPrimary,
                        icon: Icons.person,
                        onPressed: () => Get.toNamed('/login?type=customer'),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 800.ms).slideY(
                  begin: 0.5,
                  duration: 800.ms,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}