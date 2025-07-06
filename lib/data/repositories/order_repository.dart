// lib/data/repositories/order_repository.dart
import 'package:dio/dio.dart';
import '../models/order/order_list_response.dart';
import '../models/order/order_detail_response.dart';
import '../models/order/order_query_params.dart';
import '../models/order/order_status_update_request.dart';
import '../models/order/bulk_order_update_request.dart';
import '../models/common/api_response.dart';
import '../providers/api_client.dart';

abstract class OrderRepository {
  Future<ApiResponse<OrderListData>> getOrders({OrderQueryParams? params});
  Future<ApiResponse<OrderDetail>> getOrder(int id);
  Future<ApiResponse<dynamic>> updateOrderStatus(int id, String orderStatus);
  Future<ApiResponse<dynamic>> bulkUpdateOrderStatus(String action, List<int> selectedItems);
  Future<ApiResponse<dynamic>> checkPackagedStatus(int id);
}

class OrderRepositoryImpl implements OrderRepository {
  final ApiClient _apiClient;

  OrderRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<OrderListData>> getOrders({OrderQueryParams? params}) async {
    try {
      final queryParams = params?.toQueryParameters() ?? {};

      final response = await _apiClient.dio.get(
        '/orders',
        queryParameters: queryParams,
      );

      return ApiResponse<OrderListData>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? OrderListData.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<OrderListData>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch orders',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<OrderListData>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<OrderDetail>> getOrder(int id) async {
    try {
      final response = await _apiClient.dio.get('/orders/$id');

      return ApiResponse<OrderDetail>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? OrderDetail.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<OrderDetail>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch order',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<OrderDetail>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> updateOrderStatus(int id, String orderStatus) async {
    try {
      final request = OrderStatusUpdateRequest(orderStatus: orderStatus);

      final response = await _apiClient.dio.put(
        '/orders/$id/status',
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
        message: e.response?.data['message'] ?? 'Failed to update order status',
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
  Future<ApiResponse<dynamic>> bulkUpdateOrderStatus(String action, List<int> selectedItems) async {
    try {
      final request = BulkOrderUpdateRequest(
        action: action,
        selectedItems: selectedItems,
      );

      final response = await _apiClient.dio.post(
        '/orders/bulk-status',
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
        message: e.response?.data['message'] ?? 'Failed to bulk update order status',
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
  Future<ApiResponse<dynamic>> checkPackagedStatus(int id) async {
    try {
      final response = await _apiClient.dio.get('/orders/$id/check-packaged');

      return ApiResponse<dynamic>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to check packaged status',
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