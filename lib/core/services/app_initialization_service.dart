// lib/core/services/app_initialization_service.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/providers/api_client.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../constants/app_constants.dart';

class AppInitializationService extends GetxService {
  final RxBool isInitialized = false.obs;
  final RxString initializationError = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      print('🚀 Starting app initialization...');

      // Initialize GetStorage
      await GetStorage.init();
      print('✅ GetStorage initialized');

      // Initialize API Client
      Get.put<ApiClient>(ApiClient(), permanent: true);
      print('✅ API Client initialized');

      // Wait for auth controller to initialize
      final authController = Get.find<AuthController>();

      // Wait for auth initialization to complete
      while (!authController.isInitialized.value) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      print('✅ Authentication initialized');

      isInitialized.value = true;
      print('🎉 App initialization completed successfully');

    } catch (e) {
      print('❌ App initialization failed: $e');
      initializationError.value = e.toString();
      isInitialized.value = true; // Set to true to allow app to continue
    }
  }

  /// Get the initial route based on authentication state
  String getInitialRoute() {
    final storage = GetStorage();
    final apiClient = Get.find<ApiClient>();

    final token = apiClient.getToken();
    final userData = storage.read(AppConstants.userDataKey);
    final userTypeString = storage.read(AppConstants.userTypeKey);

    final isAuthenticated = token != null && userData != null && userTypeString != null;

    if (isAuthenticated) {
      // Determine which dashboard to show
      if (userTypeString == 'vendor') {
        return '/vendor-dashboard';
      } else {
        return '/customer-dashboard';
      }
    }

    return '/'; // Welcome page
  }
}