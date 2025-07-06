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

      print('🔍 Login API Response Status: ${response.statusCode}');
      print('🔍 Login API Response: ${response.data}');

      // Handle successful responses (200-299)
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
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
      }

      // Handle client errors (400-499)
      else if (response.statusCode != null && response.statusCode! >= 400 && response.statusCode! < 500) {
        String errorMessage = 'Login failed';

        // Extract meaningful error message
        if (response.data != null && response.data is Map) {
          if (response.data['message'] != null) {
            errorMessage = response.data['message'];
          } else if (response.data['error'] != null) {
            if (response.data['error'] is String) {
              errorMessage = response.data['error'];
            } else if (response.data['error'] is Map && response.data['error']['message'] != null) {
              errorMessage = response.data['error']['message'];
            }
          }
        }

        // Handle specific error cases
        if (response.statusCode == 401) {
          errorMessage = 'Invalid email or password';
        } else if (response.statusCode == 422) {
          errorMessage = 'Please check your input and try again';
        } else if (response.statusCode == 429) {
          errorMessage = 'Too many login attempts. Please try again later';
        }

        return ApiResponse<UnifiedLoginData>(
          status: 'error',
          message: errorMessage,
          error: response.data,
        );
      }

      // Handle server errors (500-599)
      else if (response.statusCode != null && response.statusCode! >= 500) {
        String errorMessage = 'Server error occurred. Please try again later.';

        // Check if this is an authentication-related server error
        if (response.data != null && response.data is Map) {
          final message = response.data['message']?.toString().toLowerCase() ?? '';
          if (message.contains('credentials') || message.contains('login') || message.contains('authentication')) {
            errorMessage = 'Invalid email or password';
          } else if (response.data['message'] != null) {
            errorMessage = response.data['message'];
          }
        }

        return ApiResponse<UnifiedLoginData>(
          status: 'error',
          message: errorMessage,
          error: response.data,
        );
      }

      // Handle other unexpected status codes
      else {
        return ApiResponse<UnifiedLoginData>(
          status: 'error',
          message: 'Unexpected response from server',
          error: response.data,
        );
      }

    } on DioException catch (e) {
      print('❌ Login Dio Error: ${e.response?.statusCode} - ${e.message}');
      print('❌ Login Dio Error Data: ${e.response?.data}');

      String errorMessage = 'Login failed';

      // Handle network errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Unable to connect to server. Please check your internet connection.';
      } else if (e.response != null) {
        // Handle HTTP errors
        final statusCode = e.response!.statusCode;
        if (statusCode == 401) {
          errorMessage = 'Invalid email or password';
        } else if (statusCode == 500) {
          // Check if this is an authentication-related server error
          if (e.response!.data != null && e.response!.data is Map) {
            final message = e.response!.data['message']?.toString().toLowerCase() ?? '';
            if (message.contains('credentials') || message.contains('login') || message.contains('incorrect')) {
              errorMessage = 'Invalid email or password';
            } else {
              errorMessage = e.response!.data['message'] ?? 'Server error occurred';
            }
          } else {
            errorMessage = 'Server error occurred. Please try again later.';
          }
        } else if (e.response!.data != null && e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        }
      }

      return ApiResponse<UnifiedLoginData>(
        status: 'error',
        message: errorMessage,
        error: e.response?.data,
      );
    } catch (e) {
      print('❌ Login General Error: $e');
      return ApiResponse<UnifiedLoginData>(
        status: 'error',
        message: 'An unexpected error occurred. Please try again.',
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