// lib/core/bindings/initial_binding.dart
import 'package:get/get.dart';
import 'package:multistorage_vendor_app/data/repositories/vendor_repository.dart';
import '../../data/providers/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/customer_repository.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/product_controller.dart';
import '../../presentation/controllers/category_controller.dart';
import '../../presentation/controllers/order_controller.dart';
import '../../presentation/controllers/customer_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Repositories
    Get.lazyPut<AuthRepository>(
          () => AuthRepositoryImpl(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<ProductRepository>(
          () => ProductRepositoryImpl(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<CategoryRepository>(
          () => CategoryRepositoryImpl(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<OrderRepository>(
          () => OrderRepositoryImpl(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<CustomerRepository>(
          () => CustomerRepositoryImpl(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<VendorRepository>(
          () => VendorRepositoryImpl(Get.find<ApiClient>()),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<AuthController>(
          () => AuthController(
        Get.find<AuthRepository>(),
        Get.find<ApiClient>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ProductController>(
          () => ProductController(Get.find<ProductRepository>()),
      fenix: true,
    );

    Get.lazyPut<CategoryController>(
          () => CategoryController(Get.find<CategoryRepository>()),
      fenix: true,
    );

    Get.lazyPut<OrderController>(
          () => OrderController(Get.find<OrderRepository>()),
      fenix: true,
    );

    Get.lazyPut<CustomerController>(
          () => CustomerController(Get.find<CustomerRepository>()),
      fenix: true,
    );
  }
}
