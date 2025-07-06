// lib/data/repositories/customer_repository.dart
import 'package:dio/dio.dart';
import '../models/customer/customer_list_response.dart';
import '../models/customer/customer_detail_response.dart';
import '../models/customer/customer_query_params.dart';
import '../models/customer/customer_update_request.dart';
import '../models/common/api_response.dart';
import '../providers/api_client.dart';

abstract class CustomerRepository {
  Future<ApiResponse<CustomerData>> getCustomers({CustomerQueryParams? params});
  Future<ApiResponse<CustomerStatistics>> getCustomerStatistics();
  Future<ApiResponse<CustomerDetail>> getCustomer(int id);
  Future<ApiResponse<dynamic>> updateCustomer(int id, CustomerUpdateRequest request);
}

class CustomerRepositoryImpl implements CustomerRepository {
  final ApiClient _apiClient;

  CustomerRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<CustomerData>> getCustomers({CustomerQueryParams? params}) async {
    try {
      final queryParams = params?.toQueryParameters() ?? {};

      final response = await _apiClient.dio.get(
        '/customers',
        queryParameters: queryParams,
      );

      return ApiResponse<CustomerData>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? CustomerData.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<CustomerData>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch customers',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<CustomerData>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<CustomerStatistics>> getCustomerStatistics() async {
    try {
      final response = await _apiClient.dio.get('/customers/statistics');

      return ApiResponse<CustomerStatistics>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? CustomerStatistics.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<CustomerStatistics>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch customer statistics',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<CustomerStatistics>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<CustomerDetail>> getCustomer(int id) async {
    try {
      final response = await _apiClient.dio.get('/customers/$id');

      return ApiResponse<CustomerDetail>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? CustomerDetail.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<CustomerDetail>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch customer',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<CustomerDetail>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> updateCustomer(int id, CustomerUpdateRequest request) async {
    try {
      final response = await _apiClient.dio.put(
        '/customers/$id',
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
        message: e.response?.data['message'] ?? 'Failed to update customer',
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