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
          }
          print('🌐 API Request: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ API Response: ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ API Error: ${error.response?.statusCode} ${error.requestOptions.path}');
          if (error.response?.statusCode == 401) {
            clearToken();
            Get.offAllNamed('/');
          }
          handler.next(error);
        },
      ),
    );
  }

  String? getToken() => storage.read(AppConstants.authTokenKey);

  void saveToken(String token) => storage.write(AppConstants.authTokenKey, token);

  void clearToken() => storage.remove(AppConstants.authTokenKey);

  bool get isLoggedIn => getToken() != null;
}
