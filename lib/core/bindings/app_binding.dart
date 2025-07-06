// lib/core/bindings/app_binding.dart (Updated for better performance)
import 'package:get/get.dart';
import '../../data/providers/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../presentation/controllers/auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Only initialize what's not already initialized
    // This binding is used for pages that need minimal dependencies

    // Ensure core dependencies exist
    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(ApiClient(), permanent: true);
    }

    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(
            () => AuthRepositoryImpl(Get.find<ApiClient>()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(
        AuthController(
          Get.find<AuthRepository>(),
          Get.find<ApiClient>(),
        ),
        permanent: true,
      );
    }
  }
}