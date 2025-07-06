// lib/data/repositories/auth_repository.dart
import 'package:dio/dio.dart';
import '../models/auth/user_profile.dart';
import '../models/auth/user_type.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import '../models/auth/customer_register_request.dart';
import '../models/auth/vendor_register_request.dart';
import '../models/common/api_response.dart';
import '../providers/api_client.dart';

abstract class AuthRepository {
  Future<ApiResponse<UnifiedLoginData>> login(LoginRequest request);
  Future<ApiResponse<dynamic>> registerVendor(VendorRegisterRequest request);
  Future<ApiResponse<dynamic>> registerCustomer(CustomerRegisterRequest request);
  Future<ApiResponse<dynamic>> logout(UserType userType);
  Future<ApiResponse<UserProfile>> getProfile(UserType userType);
  Future<ApiResponse<dynamic>> updateProfile(UserType userType, Map<String, dynamic> data);
  Future<ApiResponse<dynamic>> changePassword(UserType userType, Map<String, dynamic> data);
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<UnifiedLoginData>> login(LoginRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/${request.userType.apiPath}/login',
        data: request.toJson(),
      );

      return ApiResponse<UnifiedLoginData>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? UnifiedLoginData.fromJson(response.data['data'], request.userType)
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<UnifiedLoginData>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Login failed',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<UnifiedLoginData>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> registerVendor(VendorRegisterRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/vendor/register',
        data: request.toJson(),
      );

      return ApiResponse<dynamic>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Vendor registration failed',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> registerCustomer(CustomerRegisterRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/user/register',
        data: request.toJson(),
      );

      return ApiResponse<dynamic>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Customer registration failed',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> logout(UserType userType) async {
    try {
      final response = await _apiClient.dio.post('/${userType.apiPath}/logout');

      return ApiResponse<dynamic>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Logout failed',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<UserProfile>> getProfile(UserType userType) async {
    try {
      final response = await _apiClient.dio.get('/${userType.apiPath}/profile');

      UserProfile? profile;
      if (response.data['data'] != null) {
        profile = userType == UserType.vendor
            ? UserProfile.fromVendorJson(response.data['data'])
            : UserProfile.fromCustomerJson(response.data['data']);
      }

      return ApiResponse<UserProfile>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: profile,
      );
    } on DioException catch (e) {
      return ApiResponse<UserProfile>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to get profile',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<UserProfile>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> updateProfile(UserType userType, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put(
        '/${userType.apiPath}/profile',
        data: data,
      );

      return ApiResponse<dynamic>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to update profile',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> changePassword(UserType userType, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post(
        '/${userType.apiPath}/change-password',
        data: data,
      );

      return ApiResponse<dynamic>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to change password',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }
}