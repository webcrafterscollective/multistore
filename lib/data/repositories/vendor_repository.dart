// lib/data/repositories/vendor_repository.dart
import 'package:dio/dio.dart';
import '../models/common/api_response.dart';
import '../models/vendor/vendor_category.dart';
import '../models/vendor/vendor_list_response.dart';
import '../models/vendor/vendor_detail_response.dart';
import '../models/vendor/vendor_query_params.dart';
import '../providers/api_client.dart';

abstract class VendorRepository {
  Future<ApiResponse<VendorListData>> getVendors({VendorQueryParams? params});
  Future<ApiResponse<VendorDetail>> getVendor(int id);
  Future<ApiResponse<List<VendorCategory>>> getVendorCategories();
}

class VendorRepositoryImpl implements VendorRepository {
  final ApiClient _apiClient;

  VendorRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<VendorListData>> getVendors({VendorQueryParams? params}) async {
    try {
      final queryParams = params?.toQueryParameters() ?? {};

      final response = await _apiClient.dio.get(
        '/vendor/list',
        queryParameters: queryParams,
      );

      print('🏪 Vendors API Response: ${response.data}');

      if (response.data['status'] == 'success') {
        final vendors = (response.data['data'] as List? ?? [])
            .map((item) => VendorItem.fromJson(item))
            .toList();

        // Create a VendorListData object from the simple list
        final vendorListData = VendorListData.fromSimpleList(vendors);

        return ApiResponse<VendorListData>(
          status: response.data['status'] ?? 'success',
          message: response.data['message'] ?? '',
          data: vendorListData,
        );
      } else {
        return ApiResponse<VendorListData>(
          status: 'error',
          message: response.data['message'] ?? 'Failed to fetch vendors',
          error: response.data,
        );
      }
    } on DioException catch (e) {
      print('❌ Vendors Dio Error: ${e.response?.data}');
      return ApiResponse<VendorListData>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch vendors',
        error: e.response?.data,
      );
    } catch (e) {
      print('❌ Vendors General Error: $e');
      return ApiResponse<VendorListData>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<VendorDetail>> getVendor(int id) async {
    try {
      final response = await _apiClient.dio.get('/vendor/$id');

      print('🏪 Vendor Detail API Response: ${response.data}');

      return ApiResponse<VendorDetail>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? VendorDetail.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      print('❌ Vendor Detail Dio Error: ${e.response?.data}');
      return ApiResponse<VendorDetail>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch vendor',
        error: e.response?.data,
      );
    } catch (e) {
      print('❌ Vendor Detail General Error: $e');
      return ApiResponse<VendorDetail>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<List<VendorCategory>>> getVendorCategories() async {
    try {
      final response = await _apiClient.dio.get('/vendor-categories');

      print('📂 Vendor Categories API Response: ${response.data}');

      return ApiResponse<List<VendorCategory>>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? (response.data['data'] as List)
            .map((item) => VendorCategory.fromJson(item))
            .toList()
            : null,
      );
    } on DioException catch (e) {
      print('❌ Vendor Categories Dio Error: ${e.response?.data}');
      return ApiResponse<List<VendorCategory>>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch vendor categories',
        error: e.response?.data,
      );
    } catch (e) {
      print('❌ Vendor Categories General Error: $e');
      return ApiResponse<List<VendorCategory>>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }
}