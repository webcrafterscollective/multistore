// lib/presentation/pages/auth/customer_register_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_overlay.dart';

class CustomerRegisterPage extends StatelessWidget {
  const CustomerRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() => LoadingOverlay(
        isLoading: authController.isLoading.value,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: authController.registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                    ),
                  ).animate().fadeIn().slideX(begin: -0.3),

                  const SizedBox(height: 40),

                  // Title
                  const Text(
                    'Create Customer Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.3),

                  const SizedBox(height: 8),

                  const Text(
                    'Join us and start shopping',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3),

                  const SizedBox(height: 40),

                  // Registration Form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Name Field
                        CustomTextField(
                          label: AppStrings.name,
                          controller: authController.nameController,
                          prefixIcon: Icons.person_outlined,
                          validator: (value) => authController.validateRequired(value, 'Name'),
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

                        const SizedBox(height: 20),

                        // Email Field
                        CustomTextField(
                          label: AppStrings.email,
                          controller: authController.emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: authController.validateEmail,
                        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),

                        const SizedBox(height: 20),

                        // Phone Field
                        CustomTextField(
                          label: AppStrings.phone,
                          controller: authController.phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          validator: authController.validatePhone,
                        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),

                        const SizedBox(height: 20),

                        // Password Field
                        CustomTextField(
                          label: AppStrings.password,
                          controller: authController.passwordController,
                          isPassword: authController.obscurePassword.value,
                          prefixIcon: Icons.lock_outlined,
                          suffixIcon: IconButton(
                            onPressed: authController.togglePasswordVisibility,
                            icon: Icon(
                              authController.obscurePassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          validator: authController.validatePassword,
                        ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3),

                        const SizedBox(height: 20),

                        // Confirm Password Field
                        CustomTextField(
                          label: AppStrings.confirmPassword,
                          controller: authController.confirmPasswordController,
                          isPassword: authController.obscureConfirmPassword.value,
                          prefixIcon: Icons.lock_outlined,
                          suffixIcon: IconButton(
                            onPressed: authController.toggleConfirmPasswordVisibility,
                            icon: Icon(
                              authController.obscureConfirmPassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          validator: authController.validateConfirmPassword,
                        ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),

                        const SizedBox(height: 30),

                        // Register Button
                        CustomButton(
                          text: 'Create Customer Account',
                          backgroundColor: AppColors.customerPrimary,
                          icon: Icons.person_add,
                          isLoading: authController.isLoading.value,
                          onPressed: authController.registerCustomer,
                        ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3),

                        const SizedBox(height: 24),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              AppStrings.alreadyHaveAccount,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text(
                                AppStrings.signInHere,
                                style: TextStyle(
                                  color: AppColors.customerPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 1000.ms),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}