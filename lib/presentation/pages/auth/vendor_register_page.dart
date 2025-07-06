// lib/presentation/pages/auth/vendor_register_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_overlay.dart';

class VendorRegisterPage extends StatelessWidget {
  const VendorRegisterPage({Key? key}) : super(key: key);

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
    Text(
    'Create Vendor Account',
    style: const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.3),

    const SizedBox(height: 8),

    Text(
    'Set up your store and start selling',
    style: const TextStyle(
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
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Personal Information Section
    Text(
    'Personal Information',
    style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.vendorPrimary,
    ),
    ).animate().fadeIn(delay: 400.ms),

    const SizedBox(height: 20),

    // Name Field
    CustomTextField(
    label: AppStrings.name,
    controller: authController.nameController,
    prefixIcon: Icons.person_outlined,
    validator: (value) => authController.validateRequired(value, 'Name'),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),

    const SizedBox(height: 20),

    // Email Field
    CustomTextField(
    label: AppStrings.email,
    controller: authController.emailController,
    keyboardType: TextInputType.emailAddress,
    prefixIcon: Icons.email_outlined,
    validator: authController.validateEmail,
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),

    const SizedBox(height: 20),

    // Phone Field
    CustomTextField(
    label: AppStrings.phone,
    controller: authController.phoneController,
    keyboardType: TextInputType.phone,
    prefixIcon: Icons.phone_outlined,
    validator: authController.validatePhone,
    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3),

    const SizedBox(height: 30),

    // Store Information Section
    Text(
    AppStrings.storeInfo,
    style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.vendorPrimary,
    ),
    ).animate().fadeIn(delay: 800.ms),

    const SizedBox(height: 20),

    // Store Name Field
      // Store Name Field
      CustomTextField(
        label: AppStrings.storeName,
        controller: authController.storeNameController,
        prefixIcon: Icons.store_outlined,
        validator: (value) => authController.validateRequired(value, 'Store Name'),
      ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3),

      const SizedBox(height: 20),

      // Store Slug Field
      CustomTextField(
        label: AppStrings.storeSlug,
        controller: authController.storeSlugController,
        prefixIcon: Icons.link_outlined,
        readOnly: true,
        hint: 'Auto-generated from store name',
      ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3),

      const SizedBox(height: 20),

      // Store Type Field
      CustomTextField(
        label: AppStrings.storeType,
        controller: authController.storeTypeController,
        prefixIcon: Icons.category_outlined,
        validator: (value) => authController.validateRequired(value, 'Store Type'),
      ).animate().fadeIn(delay: 1100.ms).slideY(begin: 0.3),

      const SizedBox(height: 20),

      // Contact Number Field
      CustomTextField(
        label: AppStrings.contactNumber,
        controller: authController.contactNumberController,
        keyboardType: TextInputType.phone,
        prefixIcon: Icons.business_outlined,
        validator: authController.validatePhone,
      ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.3),

      const SizedBox(height: 30),

      // Security Section
      Text(
        'Security',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.vendorPrimary,
        ),
      ).animate().fadeIn(delay: 1300.ms),

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
      ).animate().fadeIn(delay: 1400.ms).slideY(begin: 0.3),

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
      ).animate().fadeIn(delay: 1500.ms).slideY(begin: 0.3),

      const SizedBox(height: 30),

      // Register Button
      CustomButton(
        text: 'Create Vendor Account',
        backgroundColor: AppColors.vendorPrimary,
        icon: Icons.store,
        isLoading: authController.isLoading.value,
        onPressed: authController.registerVendor,
      ).animate().fadeIn(delay: 1600.ms).slideY(begin: 0.3),

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
                color: AppColors.vendorPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ).animate().fadeIn(delay: 1700.ms),
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
