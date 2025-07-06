// lib/data/repositories/category_repository.dart
import 'package:dio/dio.dart';
import '../models/category/category_list_response.dart';
import '../models/category/category_request.dart';
import '../models/category/subcategory_response.dart';
import '../models/category/items_response.dart';
import '../models/category/brands_response.dart';
import '../models/category/features_response.dart';
import '../models/common/api_response.dart';
import '../providers/api_client.dart';

abstract class CategoryRepository {
  Future<ApiResponse<List<CategoryItem>>> getCategories();
  Future<ApiResponse<CategoryItem>> getCategory(int id);
  Future<ApiResponse<dynamic>> createCategory(CategoryCreateRequest request);
  Future<ApiResponse<dynamic>> updateCategory(int id, CategoryUpdateRequest request);
  Future<ApiResponse<dynamic>> deleteCategory(int id);
  Future<ApiResponse<List<SubcategoryItem>>> getSubcategories(int categoryId);
  Future<ApiResponse<List<ItemDetail>>> getItems(int subcategoryId);
  Future<ApiResponse<List<BrandDetail>>> getBrands(int itemId);
  Future<ApiResponse<List<FeatureDetail>>> getFeatures();
}

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiClient _apiClient;

  CategoryRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<List<CategoryItem>>> getCategories() async {
    try {
      final response = await _apiClient.dio.get('/categories');

      return ApiResponse<List<CategoryItem>>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? (response.data['data'] as List)
            .map((item) => CategoryItem.fromJson(item))
            .toList()
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<List<CategoryItem>>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch categories',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<List<CategoryItem>>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<CategoryItem>> getCategory(int id) async {
    try {
      final response = await _apiClient.dio.get('/categories/$id');

      return ApiResponse<CategoryItem>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? CategoryItem.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<CategoryItem>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch category',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<CategoryItem>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> createCategory(CategoryCreateRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/categories',
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
        message: e.response?.data['message'] ?? 'Failed to create category',
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
  Future<ApiResponse<dynamic>> updateCategory(int id, CategoryUpdateRequest request) async {
    try {
      final response = await _apiClient.dio.put(
        '/categories/$id',
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
        message: e.response?.data['message'] ?? 'Failed to update category',
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
  Future<ApiResponse<dynamic>> deleteCategory(int id) async {
    try {
      final response = await _apiClient.dio.delete('/categories/$id');

      return ApiResponse<dynamic>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return ApiResponse<dynamic>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to delete category',
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
  Future<ApiResponse<List<SubcategoryItem>>> getSubcategories(int categoryId) async {
    try {
      final response = await _apiClient.dio.get('/categories/$categoryId/subcategories');

      return ApiResponse<List<SubcategoryItem>>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? (response.data['data'] as List)
            .map((item) => SubcategoryItem.fromJson(item))
            .toList()
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<List<SubcategoryItem>>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch subcategories',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<List<SubcategoryItem>>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<List<ItemDetail>>> getItems(int subcategoryId) async {
    try {
      final response = await _apiClient.dio.get('/categories/subcategories/$subcategoryId/items');

      return ApiResponse<List<ItemDetail>>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? (response.data['data'] as List)
            .map((item) => ItemDetail.fromJson(item))
            .toList()
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<List<ItemDetail>>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch items',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<List<ItemDetail>>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<List<BrandDetail>>> getBrands(int itemId) async {
    try {
      final response = await _apiClient.dio.get('/categories/items/$itemId/brands');

      return ApiResponse<List<BrandDetail>>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? (response.data['data'] as List)
            .map((item) => BrandDetail.fromJson(item))
            .toList()
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<List<BrandDetail>>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch brands',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<List<BrandDetail>>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<List<FeatureDetail>>> getFeatures() async {
    try {
      final response = await _apiClient.dio.get('/categories/features');

      return ApiResponse<List<FeatureDetail>>(
        status: response.data['status'] ?? 'error',
        message: response.data['message'] ?? '',
        data: response.data['data'] != null
            ? (response.data['data'] as List)
            .map((item) => FeatureDetail.fromJson(item))
            .toList()
            : null,
      );
    } on DioException catch (e) {
      return ApiResponse<List<FeatureDetail>>(
        status: 'error',
        message: e.response?.data['message'] ?? 'Failed to fetch features',
        error: e.response?.data,
      );
    } catch (e) {
      return ApiResponse<List<FeatureDetail>>(
        status: 'error',
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }
}