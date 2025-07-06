// lib/data/providers/api_client.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_constants.dart';

class ApiClient extends GetxService {
  late Dio dio;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl + AppConstants.apiVersion,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptor for authentication and logging
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print('🔑 Using token: ${token.substring(0, 20)}...');
          }
          print('🌐 API Request: ${options.method} ${options.path}');
          if (options.data != null) {
            print('📤 Request Data: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ API Response: ${response.statusCode} ${response.requestOptions.path}');
          print('📥 Response Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ API Error: ${error.response?.statusCode} ${error.requestOptions.path}');
          print('❌ Error Data: ${error.response?.data}');
          if (error.response?.statusCode == 401) {
            print('🚪 Unauthorized - clearing token and redirecting to login');
            clearToken();
            Get.offAllNamed('/');
          }
          handler.next(error);
        },
      ),
    );
  }

  String? getToken() {
    final token = storage.read(AppConstants.authTokenKey);
    print('🔍 Getting token from storage: ${token != null ? 'Found' : 'Not found'}');
    return token;
  }

  void saveToken(String token) {
    print('💾 Saving token to storage: ${token.substring(0, 20)}...');
    storage.write(AppConstants.authTokenKey, token);
  }

  void clearToken() {
    print('🗑️ Clearing token from storage');
    storage.remove(AppConstants.authTokenKey);
  }

  bool get isLoggedIn {
    final hasToken = getToken() != null;
    print('🔐 Is logged in: $hasToken');
    return hasToken;
  }
}