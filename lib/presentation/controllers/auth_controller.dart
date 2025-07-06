// lib/presentation/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/auth/user_type.dart';
import '../../data/models/auth/login_request.dart';
import '../../data/models/auth/user_profile.dart';
import '../../data/models/auth/vendor_register_request.dart';
import '../../data/models/auth/customer_register_request.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/providers/api_client.dart';

class AuthController extends GetxController with GetSingleTickerProviderStateMixin {
  final AuthRepository _authRepository;
  final ApiClient _apiClient;
  final GetStorage _storage = GetStorage();

  // Animation Controller
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  AuthController(this._authRepository, this._apiClient);

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<UserProfile?> currentUser = Rx<UserProfile?>(null);
  final Rx<UserType?> currentUserType = Rx<UserType?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  // Form Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Vendor specific controllers
  final storeNameController = TextEditingController();
  final storeSlugController = TextEditingController();
  final storeTypeController = TextEditingController();
  final contactNumberController = TextEditingController();

  // Form Keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    // Initialize animations
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    ));

    checkLoginStatus();
    animationController.forward();

    // Auto-generate store slug from store name
    storeNameController.addListener(_generateStoreSlug);
  }

  @override
  void onClose() {
    animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    storeNameController.dispose();
    storeSlugController.dispose();
    storeTypeController.dispose();
    contactNumberController.dispose();
    super.onClose();
  }

  void _generateStoreSlug() {
    final storeName = storeNameController.text.toLowerCase();
    final slug = storeName
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .trim();
    storeSlugController.text = slug;
  }

  void checkLoginStatus() {
    final token = _apiClient.getToken();
    final userData = _storage.read(AppConstants.userDataKey);
    final userTypeString = _storage.read(AppConstants.userTypeKey);

    if (token != null && userData != null && userTypeString != null) {
      isLoggedIn.value = true;
      currentUserType.value = UserType.values.firstWhere(
            (type) => type.name == userTypeString,
        orElse: () => UserType.customer,
      );

      // Reconstruct user profile based on type
      if (currentUserType.value == UserType.vendor) {
        currentUser.value = UserProfile.fromVendorJson(userData);
      } else {
        currentUser.value = UserProfile.fromCustomerJson(userData);
      }
    }
  }

  Future<void> login(String email, String password, UserType userType) async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = LoginRequest(
        email: email,
        password: password,
        userType: userType,
      );

      final response = await _authRepository.login(request);

      if (response.isSuccess && response.data != null) {
        // Save token, user data, and user type
        _apiClient.saveToken(response.data!.token);
        _storage.write(AppConstants.userDataKey, response.data!.user.toJson());
        _storage.write(AppConstants.userTypeKey, userType.name);

        // Update state
        isLoggedIn.value = true;
        currentUser.value = response.data!.user;
        currentUserType.value = userType;

        // Clear form
        clearForms();

        // Navigate to appropriate dashboard
        if (userType == UserType.vendor) {
          Get.offAllNamed('/vendor-dashboard');
        } else {
          Get.offAllNamed('/customer-dashboard');
        }

        Get.snackbar(
          'Success',
          response.message,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      errorMessage.value = AppStrings.somethingWentWrong;
      Get.snackbar(
        'Error',
        AppStrings.somethingWentWrong,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerVendor() async {
    if (!registerFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = VendorRegisterRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        phone: phoneController.text.trim(),
        storeName: storeNameController.text.trim(),
        storeSlug: storeSlugController.text.trim(),
        storeType: storeTypeController.text.trim(),
        contactNumber: contactNumberController.text.trim(),
      );

      final response = await _authRepository.registerVendor(request);

      if (response.isSuccess) {
        clearForms();
        Get.snackbar(
          'Success',
          'Vendor registration successful! Please login.',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        Get.offNamed('/login');
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      errorMessage.value = AppStrings.somethingWentWrong;
      Get.snackbar(
        'Error',
        AppStrings.somethingWentWrong,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerCustomer() async {
    if (!registerFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = CustomerRegisterRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        phone: phoneController.text.trim(),
      );

      final response = await _authRepository.registerCustomer(request);

      if (response.isSuccess) {
        clearForms();
        Get.snackbar(
          'Success',
          'Customer registration successful! Please login.',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        Get.offNamed('/login');
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      errorMessage.value = AppStrings.somethingWentWrong;
      Get.snackbar(
        'Error',
        AppStrings.somethingWentWrong,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      if (currentUserType.value != null) {
        await _authRepository.logout(currentUserType.value!);
      }

      // Clear local data
      _apiClient.clearToken();
      _storage.remove(AppConstants.userDataKey);
      _storage.remove(AppConstants.userTypeKey);

      // Update state
      isLoggedIn.value = false;
      currentUser.value = null;
      currentUserType.value = null;

      // Clear forms
      clearForms();

      // Navigate to welcome page
      Get.offAllNamed('/');
      Get.snackbar(
        'Success',
        AppStrings.logoutSuccess,
        backgroundColor: AppColors.info,
        colorText: Colors.white,
        icon: const Icon(Icons.logout, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForms() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    phoneController.clear();
    confirmPasswordController.clear();
    storeNameController.clear();
    storeSlugController.clear();
    storeTypeController.clear();
    contactNumberController.clear();
    errorMessage.value = '';
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // Validators
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  // Helper getters
  bool get isVendor => currentUserType.value == UserType.vendor;
  bool get isCustomer => currentUserType.value == UserType.customer;
  String get userName => currentUser.value?.displayName ?? 'User';
  String get userEmail => currentUser.value?.email ?? '';
  String? get storeName => currentUser.value?.vendorInfo?.storeName;
  String? get storeStatus => currentUser.value?.vendorInfo?.status;
}