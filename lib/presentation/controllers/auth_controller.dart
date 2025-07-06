// lib/presentation/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/session_management_service.dart';
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
  final RxBool isInitialized = false.obs;

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

    // Initialize authentication state
    initializeAuth();
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

  /// Initialize authentication state from storage
  Future<void> initializeAuth() async {
    try {
      print('🔄 Initializing authentication state...');

      final token = _apiClient.getToken();
      final userData = _storage.read(AppConstants.userDataKey);
      final userTypeString = _storage.read(AppConstants.userTypeKey);

      print('🔍 Init Auth - Token exists: ${token != null}');
      print('🔍 Init Auth - User data exists: ${userData != null}');
      print('🔍 Init Auth - User type: $userTypeString');

      if (token != null && userData != null && userTypeString != null) {
        // Restore authentication state
        currentUserType.value = UserType.values.firstWhere(
              (type) => type.name == userTypeString,
          orElse: () => UserType.customer,
        );

        try {
          // Reconstruct user profile based on type
          if (currentUserType.value == UserType.vendor) {
            currentUser.value = UserProfile.fromVendorJson(userData);
          } else {
            currentUser.value = UserProfile.fromCustomerJson(userData);
          }

          isLoggedIn.value = true;
          print('✅ Authentication state restored successfully');

          // Start session management if available
          try {
            if (Get.isRegistered<SessionManagementService>()) {
              final sessionService = Get.find<SessionManagementService>();
              sessionService.startSession();
            }
          } catch (e) {
            print('⚠️ Could not start session management: $e');
          }

          // Optionally validate token with server (but don't block initialization)
          Future.delayed(const Duration(milliseconds: 500), () {
            validateTokenWithServer();
          });

        } catch (e) {
          print('❌ Error reconstructing user profile: $e');
          await _clearAuthData();
        }
      } else {
        print('ℹ️ No authentication data found');
        isLoggedIn.value = false;
      }
    } catch (e) {
      print('❌ Error initializing auth: $e');
      await _clearAuthData();
    } finally {
      isInitialized.value = true;
    }
  }

  /// Validate current token with server
  Future<void> validateTokenWithServer() async {
    if (currentUserType.value == null) return;

    try {
      print('🔄 Validating token with server...');
      final response = await _authRepository.getProfile(currentUserType.value!);

      if (response.isSuccess && response.data != null) {
        currentUser.value = response.data!;
        // Update stored user data with fresh data
        _storage.write(AppConstants.userDataKey, response.data!.toJson());
        print('✅ Token validation successful');
      } else {
        print('⚠️ Token validation failed: ${response.message}');
        // Token might be expired or invalid
        await _clearAuthData();
        _showTokenExpiredMessage();
      }
    } catch (e) {
      print('❌ Error validating token: $e');
      // Network error - keep user logged in but show warning
      _showNetworkErrorMessage();
    }
  }

  /// Check if user is authenticated and redirect accordingly
  void checkAuthAndRedirect() {
    if (isLoggedIn.value && currentUserType.value != null) {
      final dashboardRoute = currentUserType.value == UserType.vendor
          ? '/vendor-dashboard'
          : '/customer-dashboard';

      print('🔄 Redirecting authenticated user to $dashboardRoute');
      Get.offAllNamed(dashboardRoute);
    }
  }

  Future<void> _clearAuthData() async {
    _apiClient.clearToken();
    _storage.remove(AppConstants.userDataKey);
    _storage.remove(AppConstants.userTypeKey);
    isLoggedIn.value = false;
    currentUser.value = null;
    currentUserType.value = null;
    print('🗑️ Authentication data cleared');
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

      print('🚀 Sending login request for ${userType.name}');

      final response = await _authRepository.login(request);

      print('📨 Login response: ${response.status}');
      print('💬 Login message: ${response.message}');

      if (response.isSuccess && response.data != null) {
        final loginData = response.data!;

        print('🔑 Token received: ${loginData.token}');
        print('👤 User data: ${loginData.user.toJson()}');

        // Save authentication data
        _apiClient.saveToken(loginData.token);
        _storage.write(AppConstants.userDataKey, loginData.user.toJson());
        _storage.write(AppConstants.userTypeKey, userType.name);

        // Update state
        isLoggedIn.value = true;
        currentUser.value = loginData.user;
        currentUserType.value = userType;

        print('✅ Login state updated successfully');

        // Clear form
        clearForms();

        // Navigate to appropriate dashboard
        final dashboardRoute = userType == UserType.vendor
            ? '/vendor-dashboard'
            : '/customer-dashboard';

        Get.offAllNamed(dashboardRoute);

        Get.snackbar(
          'Success',
          response.message.isNotEmpty ? response.message : AppStrings.loginSuccess,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        errorMessage.value = response.message;
        Get.snackbar(
          'Error',
          response.message.isNotEmpty ? response.message : AppStrings.invalidCredentials,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      print('❌ Login error: $e');
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

      // Call logout API if user type is available
      if (currentUserType.value != null) {
        try {
          await _authRepository.logout(currentUserType.value!);
        } catch (e) {
          print('⚠️ Logout API call failed: $e');
          // Continue with local logout even if API fails
        }
      }

      // Clear local data
      await _clearAuthData();

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
      print('❌ Logout error: $e');
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

  /// Auto-logout when token expires
  void handleTokenExpiry() {
    print('🔔 Handling token expiry');
    _clearAuthData();
    Get.offAllNamed('/');
    _showTokenExpiredMessage();
  }

  void _showTokenExpiredMessage() {
    Get.snackbar(
      'Session Expired',
      'Your session has expired. Please login again.',
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
      icon: const Icon(Icons.access_time, color: Colors.white),
      duration: const Duration(seconds: 5),
    );
  }

  void _showNetworkErrorMessage() {
    Get.snackbar(
      'Network Error',
      'Unable to verify session. Check your internet connection.',
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      icon: const Icon(Icons.wifi_off, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  // Registration methods remain the same...
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

  // Rest of the methods remain the same...
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