// lib/core/bindings/initial_binding.dart (Complete)
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
import '../services/app_initialization_service.dart';
import '../services/session_management_service.dart';
import '../services/connectivity_service.dart';
import '../services/app_lifecycle_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    print('🔧 Starting dependency injection...');

    // Core services - Initialize in order
    _initializeCoreServices();
    _initializeNetworkServices();
    _initializeDataServices();
    _initializeBusinessServices();
    _initializeUIControllers();

    print('✅ All dependencies initialized successfully');
  }

  void _initializeCoreServices() {
    print('🔧 Initializing core services...');

    // App initialization service
    Get.put<AppInitializationService>(
      AppInitializationService(),
      permanent: true,
    );

    // App lifecycle management
    Get.put<AppLifecycleService>(
      AppLifecycleService(),
      permanent: true,
    );

    // Session management
    Get.put<SessionManagementService>(
      SessionManagementService(),
      permanent: true,
    );

    print('✅ Core services initialized');
  }

  void _initializeNetworkServices() {
    print('🔧 Initializing network services...');

    // Connectivity service
    Get.put<ConnectivityService>(
      ConnectivityService(),
      permanent: true,
    );

    // API Client with enhanced features
    Get.put<ApiClient>(
      ApiClient(),
      permanent: true,
    );

    print('✅ Network services initialized');
  }

  void _initializeDataServices() {
    print('🔧 Initializing data services (repositories)...');

    // Repositories - Data layer
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

    print('✅ Data services initialized');
  }

  void _initializeBusinessServices() {
    print('🔧 Initializing business services...');

    // Add any business logic services here
    // For example: NotificationService, AnalyticsService, etc.

    print('✅ Business services initialized');
  }

  void _initializeUIControllers() {
    print('🔧 Initializing UI controllers...');

    // Auth Controller - Critical for middleware, initialize immediately
    Get.put<AuthController>(
      AuthController(
        Get.find<AuthRepository>(),
        Get.find<ApiClient>(),
      ),
      permanent: true,
    );

    // Other controllers - Lazy loaded
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

    print('✅ UI controllers initialized');
  }
}