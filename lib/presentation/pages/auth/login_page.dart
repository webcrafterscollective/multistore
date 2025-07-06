// lib/presentation/pages/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/auth/user_type.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_overlay.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserType selectedUserType;

  @override
  void initState() {
    super.initState();
    // Get user type from URL parameter or default to customer
    final typeParam = Get.parameters['type'];
    selectedUserType = typeParam == 'vendor' ? UserType.vendor : UserType.customer;
  }

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
              key: authController.loginFormKey,
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

                  // User Type Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedUserType = UserType.vendor),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: selectedUserType == UserType.vendor
                                    ? AppColors.vendorPrimary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.store,
                                    color: selectedUserType == UserType.vendor
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Vendor',
                                    style: TextStyle(
                                      color: selectedUserType == UserType.vendor
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedUserType = UserType.customer),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: selectedUserType == UserType.customer
                                    ? AppColors.customerPrimary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: selectedUserType == UserType.customer
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Customer',
                                    style: TextStyle(
                                      color: selectedUserType == UserType.customer
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'Welcome Back!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.3),

                  const SizedBox(height: 8),

                  Text(
                    'Sign in to your ${selectedUserType.displayName.toLowerCase()} account',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.3),

                  const SizedBox(height: 40),

                  // Login Form
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
                        // Email Field
                        CustomTextField(
                          label: AppStrings.email,
                          controller: authController.emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: authController.validateEmail,
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

                        const SizedBox(height: 12),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                            },
                            child: Text(
                              AppStrings.forgotPassword,
                              style: TextStyle(
                                color: selectedUserType.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 800.ms),

                        const SizedBox(height: 24),

                        // Login Button
                        CustomButton(
                          text: 'Sign In',
                          backgroundColor: selectedUserType.primaryColor,
                          icon: Icons.login,
                          isLoading: authController.isLoading.value,
                          onPressed: () => authController.login(
                            authController.emailController.text,
                            authController.passwordController.text,
                            selectedUserType,
                          ),
                        ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3),

                        const SizedBox(height: 24),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.dontHaveAccount,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (selectedUserType == UserType.vendor) {
                                  Get.toNamed('/vendor-register');
                                } else {
                                  Get.toNamed('/customer-register');
                                }
                              },
                              child: Text(
                                AppStrings.signUpHere,
                                style: TextStyle(
                                  color: selectedUserType.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 1000.ms),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}