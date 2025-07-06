// lib/data/repositories/product_repository.dart
import 'package:dio/dio.dart';
import '../models/product/product_list_response.dart';
import '../models/product/product_detail_response.dart';
import '../models/product/product_query_params.dart';
import '../models/common/api_response.dart';
import '../providers/api_client.dart';

abstract class ProductRepository {
  Future<ApiResponse<ProductListData>> getProducts({ProductQueryParams? params});
  Future<ApiResponse<ProductDetail>> getProduct(int id);
  Future<ApiResponse<dynamic>> createProduct(Map<String, dynamic> data);
  Future<ApiResponse<dynamic>> updateProduct(int id, Map<String, dynamic> data);
  Future<ApiResponse<dynamic>> deleteProduct(int id);
  Future<ApiResponse<List<dynamic>>> getTaxRates();
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _apiClient;

  ProductRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<ProductListData>> getProducts({ProductQueryParams? params}) async {
    try {
      final queryParams = params?.toQueryParameters() ?? {};

      final response = await _apiClient.dio.get(
        '/products',
        queryParameters: queryParams,
      );

      return ApiResponse<ProductListData>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? ProductListData.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<ProductListData>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch products',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<ProductListData>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<ProductDetail>> getProduct(int id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id');

      return ApiResponse<ProductDetail>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? ProductDetail.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<ProductDetail>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch product',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<ProductDetail>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post(
        '/products',
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
        message: e.response?.data['message'] ?? 'Failed to create product',
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
  Future<ApiResponse<dynamic>> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put(
        '/products/$id',
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
        message: e.response?.data['message'] ?? 'Failed to update product',
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
  Future<ApiResponse<dynamic>> deleteProduct(int id) async {
    try {
      final response = await _apiClient.dio.delete('/products/$id');

      return ApiResponse<dynamic>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to delete product',
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
  Future<ApiResponse<List<dynamic>>> getTaxRates() async {
    try {
      final response = await _apiClient.dio.get('/products/tax-rates');

      return ApiResponse<List<dynamic>>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? List<dynamic>.from(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<List<dynamic>>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch tax rates',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<List<dynamic>>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }
}
