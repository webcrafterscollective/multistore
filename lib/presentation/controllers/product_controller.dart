// lib/presentation/controllers/product_controller.dart
import 'package:get/get.dart';
import '../../data/models/product/product_list_response.dart';
import '../../data/models/product/product_detail_response.dart';
import '../../data/models/product/product_query_params.dart';
import '../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _productRepository;

  ProductController(this._productRepository);

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxList<ProductVariant> products = <ProductVariant>[].obs;
  final Rx<ProductDetail?> selectedProduct = Rx<ProductDetail?>(null);
  final RxList<dynamic> taxRates = <dynamic>[].obs;
  final RxString errorMessage = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxBool hasMorePages = false.obs;

  // Filters
  final Rx<ProductQueryParams> queryParams = ProductQueryParams(
    perPage: 10,
    sortBy: 'created_at',
    sortOrder: 'desc',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  Future<void> getProducts({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (!hasMorePages.value || isLoadingMore.value) return;
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        products.clear();
        currentPage.value = 1;
      }

      final params = queryParams.value.copyWith(
        page: loadMore ? currentPage.value + 1 : 1,
      );

      final response = await _productRepository.getProducts(params: params);

      if (response.isSuccess && response.data != null) {
        final data = response.data!;

        if (loadMore) {
          products.addAll(data.data);
          currentPage.value = data.currentPage;
        } else {
          products.assignAll(data.data);
          currentPage.value = data.currentPage;
        }

        totalPages.value = data.lastPage;
        totalItems.value = data.total;
        hasMorePages.value = data.currentPage < data.lastPage;

        errorMessage.value = '';
      } else {
        errorMessage.value = response.message;
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> getProduct(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _productRepository.getProduct(id);

      if (response.isSuccess && response.data != null) {
        selectedProduct.value = response.data!;
      } else {
        errorMessage.value = response.message;
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createProduct(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;

      final response = await _productRepository.createProduct(data);

      if (response.isSuccess) {
        Get.snackbar('Success', response.message);
        await getProducts(); // Refresh products list
        Get.back(); // Close create product screen
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create product');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;

      final response = await _productRepository.updateProduct(id, data);

      if (response.isSuccess) {
        Get.snackbar('Success', response.message);
        await getProducts(); // Refresh products list
        Get.back(); // Close edit product screen
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      isLoading.value = true;

      final response = await _productRepository.deleteProduct(id);

      if (response.isSuccess) {
        Get.snackbar('Success', response.message);
        await getProducts(); // Refresh products list
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTaxRates() async {
    try {
      final response = await _productRepository.getTaxRates();

      if (response.isSuccess && response.data != null) {
        taxRates.assignAll(response.data!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tax rates');
    }
  }

  // Filter methods
  void searchProducts(String query) {
    queryParams.value = queryParams.value.copyWith(search: query);
    getProducts();
  }

  void filterByCategory(int? categoryId) {
    queryParams.value = queryParams.value.copyWith(categoryId: categoryId);
    getProducts();
  }

  void filterBySubcategory(int? subcategoryId) {
    queryParams.value = queryParams.value.copyWith(subcategoryId: subcategoryId);
    getProducts();
  }

  void filterByPriceRange(double? minPrice, double? maxPrice) {
    queryParams.value = queryParams.value.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    getProducts();
  }

  void filterByStock(bool? inStock) {
    queryParams.value = queryParams.value.copyWith(inStock: inStock);
    getProducts();
  }

  void setSortOrder(String sortBy, String sortOrder) {
    queryParams.value = queryParams.value.copyWith(
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    getProducts();
  }

  void setPerPage(int perPage) {
    queryParams.value = queryParams.value.copyWith(perPage: perPage);
    getProducts();
  }

  void clearFilters() {
    queryParams.value = ProductQueryParams(
      perPage: 10,
      sortBy: 'created_at',
      sortOrder: 'desc',
    );
    getProducts();
  }

  void refreshProducts() {
    getProducts();
  }
}