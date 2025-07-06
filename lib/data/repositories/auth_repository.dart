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

      print('🔍 Login API Response: ${response.data}');

      if (response.data['status'] == 'success') {
        // Create a modified response structure that includes the token
        final modifiedResponse = Map<String, dynamic>.from(response.data);

        // Extract token from the response and add it to data level
        String? token;
        if (response.data['data'] != null && response.data['data']['token'] != null) {
          token = response.data['data']['token'];
        } else if (response.data['token'] != null) {
          token = response.data['token'];
        }

        // Ensure token is available at the data level
        if (token != null && modifiedResponse['data'] != null) {
          modifiedResponse['data']['token'] = token;
        }

        final loginData = UnifiedLoginData.fromJson(modifiedResponse, request.userType);

        return ApiResponse<UnifiedLoginData>(
          status: response.data['status'] ?? 'success',
          message: response.data['message'] ?? 'Login successful',
          data: loginData,
        );
      } else {
        return ApiResponse<UnifiedLoginData>(
          status: 'error',
          message: response.data['message'] ?? 'Login failed',
          error: response.data,
        );
      }
    } on DioException catch (e) {
      print('❌ Login Dio Error: ${e.response?.data}');
      return ApiResponse<UnifiedLoginData>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Login failed',
        error: e.response?.data,
      );
    } catch (e) {
      print('❌ Login General Error: $e');
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

      print('🔍 Profile API Response: ${response.data}');

      UserProfile? profile;
      if (response.data['status'] == 'success' && response.data['data'] != null) {
        if (userType == UserType.vendor) {
          // Use the specific profile constructor for vendor profile API
          profile = UserProfile.fromVendorProfileJson(response.data);
        } else {
          // Use the specific profile constructor for customer profile API
          profile = UserProfile.fromCustomerProfileJson(response.data);
        }
      }

      return ApiResponse<UserProfile>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: profile,
      );
    } on DioException catch (e) {
      print('❌ Profile Dio Error: ${e.response?.data}');
      return ApiResponse<UserProfile>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to get profile',
        error: e.response?.data,
      );
    } catch (e) {
      print('❌ Profile General Error: $e');
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