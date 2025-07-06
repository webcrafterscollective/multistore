// lib/presentation/controllers/category_controller.dart
import 'package:get/get.dart';
import '../../data/models/category/category_list_response.dart';
import '../../data/models/category/category_request.dart';
import '../../data/models/category/subcategory_response.dart';
import '../../data/models/category/items_response.dart';
import '../../data/models/category/brands_response.dart';
import '../../data/models/category/features_response.dart';
import '../../data/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _categoryRepository;

  CategoryController(this._categoryRepository);

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<CategoryItem> categories = <CategoryItem>[].obs;
  final RxList<SubcategoryItem> subcategories = <SubcategoryItem>[].obs;
  final RxList<ItemDetail> items = <ItemDetail>[].obs;
  final RxList<BrandDetail> brands = <BrandDetail>[].obs;
  final RxList<FeatureDetail> features = <FeatureDetail>[].obs;
  final Rx<CategoryItem?> selectedCategory = Rx<CategoryItem?>(null);
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCategories();
  }

  Future<void> getCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _categoryRepository.getCategories();

      if (response.isSuccess && response.data != null) {
        categories.assignAll(response.data!);
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

  Future<void> getCategory(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _categoryRepository.getCategory(id);

      if (response.isSuccess && response.data != null) {
        selectedCategory.value = response.data!;
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

  Future<void> createCategory({
    required String name,
    required int position,
    required bool status,
    double? tax,
    String? image,
  }) async {
    try {
      isLoading.value = true;

      final request = CategoryCreateRequest(
        name: name,
        position: position,
        status: status,
        tax: tax,
        image: image,
      );

      final response = await _categoryRepository.createCategory(request);

      if (response.isSuccess) {
        Get.snackbar('Success', response.message);
        await getCategories(); // Refresh categories
        Get.back(); // Close create category screen
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create category');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCategory({
    required int id,
    String? name,
    int? position,
    bool? status,
    double? tax,
    String? image,
  }) async {
    try {
      isLoading.value = true;

      final request = CategoryUpdateRequest(
        name: name,
        position: position,
        status: status,
        tax: tax,
        image: image,
      );

      final response = await _categoryRepository.updateCategory(id, request);

      if (response.isSuccess) {
        Get.snackbar('Success', response.message);
        await getCategories(); // Refresh categories
        Get.back(); // Close edit category screen
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update category');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      isLoading.value = true;

      final response = await _categoryRepository.deleteCategory(id);

      if (response.isSuccess) {
        Get.snackbar('Success', response.message);
        await getCategories(); // Refresh categories
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSubcategories(int categoryId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _categoryRepository.getSubcategories(categoryId);

      if (response.isSuccess && response.data != null) {
        subcategories.assignAll(response.data!);
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

  Future<void> getItems(int subcategoryId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _categoryRepository.getItems(subcategoryId);

      if (response.isSuccess && response.data != null) {
        items.assignAll(response.data!);
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

  Future<void> getBrands(int itemId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _categoryRepository.getBrands(itemId);

      if (response.isSuccess && response.data != null) {
        brands.assignAll(response.data!);
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

  Future<void> getFeatures() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _categoryRepository.getFeatures();

      if (response.isSuccess && response.data != null) {
        features.assignAll(response.data!);
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

  // Helper methods
  void clearSubcategories() {
    subcategories.clear();
  }

  void clearItems() {
    items.clear();
  }

  void clearBrands() {
    brands.clear();
  }

  void refreshCategories() {
    getCategories();
  }

  List<CategoryItem> get activeCategoriesOnly {
    return categories.where((category) => category.status == 1).toList();
  }

  List<SubcategoryItem> get activeSubcategoriesOnly {
    return subcategories.where((subcategory) => subcategory.status == 1).toList();
  }

  CategoryItem? getCategoryById(int id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  SubcategoryItem? getSubcategoryById(int id) {
    try {
      return subcategories.firstWhere((subcategory) => subcategory.id == id);
    } catch (e) {
      return null;
    }
  }
}