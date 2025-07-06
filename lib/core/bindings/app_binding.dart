// lib/core/bindings/app_binding.dart
import 'package:get/get.dart';
import '../../data/providers/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../presentation/controllers/auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Repository
    Get.lazyPut<AuthRepository>(
          () => AuthRepositoryImpl(Get.find<ApiClient>()),
      fenix: true,
    );

    // Controller
    Get.lazyPut<AuthController>(
          () => AuthController(
        Get.find<AuthRepository>(),
        Get.find<ApiClient>(),
      ),
      fenix: true,
    );
  }
}
