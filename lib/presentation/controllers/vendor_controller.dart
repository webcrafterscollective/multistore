// lib/presentation/controllers/vendor_controller.dart
import 'package:get/get.dart';
import '../../data/models/vendor/vendor_category.dart';
import '../../data/models/vendor/vendor_list_response.dart';
import '../../data/models/vendor/vendor_detail_response.dart';
import '../../data/models/vendor/vendor_query_params.dart';
import '../../data/repositories/vendor_repository.dart';

class VendorController extends GetxController {
  final VendorRepository _vendorRepository;

  VendorController(this._vendorRepository);

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxList<VendorItem> vendors = <VendorItem>[].obs;
  final RxList<VendorItem> featuredVendors = <VendorItem>[].obs;
  final RxList<VendorCategory> categories = <VendorCategory>[].obs;
  final Rx<VendorDetail?> selectedVendor = Rx<VendorDetail?>(null);
  final RxString errorMessage = ''.obs;

  // Store the original list for client-side filtering
  final RxList<VendorItem> _originalVendors = <VendorItem>[].obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxBool hasMorePages = false.obs;

  // Filters
  final Rx<VendorQueryParams> queryParams = VendorQueryParams(
    perPage: 10,
    sortBy: 'created_at',
    sortOrder: 'desc',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getVendors();
    getVendorCategories();
  }

  Future<void> getVendors({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (!hasMorePages.value || isLoadingMore.value) return;
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        vendors.clear();
        featuredVendors.clear();
        _originalVendors.clear();
        currentPage.value = 1;
      }

      final params = queryParams.value.copyWith(
        page: loadMore ? currentPage.value + 1 : 1,
      );

      final response = await _vendorRepository.getVendors(params: params);

      if (response.isSuccess && response.data != null) {
        final data = response.data!;

        if (loadMore) {
          vendors.addAll(data.data);
          _originalVendors.addAll(data.data);
          currentPage.value = data.currentPage;
        } else {
          vendors.assignAll(data.data);
          _originalVendors.assignAll(data.data);
          currentPage.value = data.currentPage;

          // Separate featured vendors (approved stores for now)
          featuredVendors.assignAll(
              data.data.where((vendor) => vendor.status == 'approved').take(3).toList()
          );
        }

        totalPages.value = data.lastPage;
        totalItems.value = data.total;
        hasMorePages.value = data.currentPage < data.lastPage;

        errorMessage.value = '';

        print('✅ Loaded ${data.data.length} vendors successfully');
        print('📊 Featured vendors: ${featuredVendors.length}');
        print('📊 Total vendors: ${vendors.length}');

        // Create categories from vendor data if not already loaded
        if (categories.isEmpty) {
          _createCategoriesFromVendors();
        }
      } else {
        errorMessage.value = response.message;
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Get.snackbar('Error', 'An unexpected error occurred');
      print('❌ Error getting vendors: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> getVendor(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _vendorRepository.getVendor(id);

      if (response.isSuccess && response.data != null) {
        selectedVendor.value = response.data!;
        print('✅ Loaded vendor details for: ${response.data!.storeName}');
      } else {
        errorMessage.value = response.message;
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Get.snackbar('Error', 'An unexpected error occurred');
      print('❌ Error getting vendor: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getVendorCategories() async {
    try {
      final response = await _vendorRepository.getVendorCategories();

      if (response.isSuccess && response.data != null) {
        categories.assignAll(response.data!);
        print('✅ Loaded ${response.data!.length} vendor categories');
      } else {
        print('⚠️ Failed to fetch vendor categories: ${response.message}');
        // Create categories from existing vendor store types
        _createCategoriesFromVendors();
      }
    } catch (e) {
      print('❌ Error getting vendor categories: $e');
      // Fallback to creating categories from vendors
      _createCategoriesFromVendors();
    }
  }

  void _createCategoriesFromVendors() {
    if (_originalVendors.isNotEmpty) {
      final storeTypes = _originalVendors.map((v) => v.storeType).toSet().toList();
      final generatedCategories = storeTypes.asMap().entries.map((entry) {
        return VendorCategory(
          id: entry.key + 1,
          name: entry.value,
          vendorCount: _originalVendors.where((v) => v.storeType == entry.value).length,
        );
      }).toList();

      categories.assignAll(generatedCategories);
      print('📂 Generated ${generatedCategories.length} categories from vendor data');
    }
  }

  // Filter methods with client-side filtering for simple list API
  void searchVendors(String query) {
    if (query.isEmpty) {
      vendors.assignAll(_originalVendors);
      return;
    }

    final filteredVendors = _originalVendors.where((vendor) =>
    vendor.storeName.toLowerCase().contains(query.toLowerCase()) ||
        vendor.storeType.toLowerCase().contains(query.toLowerCase()) ||
        vendor.about.toLowerCase().contains(query.toLowerCase()) ||
        (vendor.admin?.name.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();

    vendors.assignAll(filteredVendors);
    print('🔍 Search results: ${filteredVendors.length} vendors found for "$query"');
  }

  void filterByCategory(String? category) {
    if (category == null || category.isEmpty) {
      vendors.assignAll(_originalVendors);
      return;
    }

    final filteredVendors = _originalVendors.where((vendor) =>
    vendor.storeType.toLowerCase() == category.toLowerCase()
    ).toList();

    vendors.assignAll(filteredVendors);
    print('📂 Category filter: ${filteredVendors.length} vendors in "$category"');
  }

  void filterByStatus(bool? isOpen) {
    if (isOpen == null) {
      vendors.assignAll(_originalVendors);
      return;
    }

    final filteredVendors = _originalVendors.where((vendor) => vendor.isOpen == isOpen).toList();
    vendors.assignAll(filteredVendors);

    final statusText = isOpen ? 'open' : 'closed';
    print('🏪 Status filter: ${filteredVendors.length} $statusText vendors');
  }

  void setSortOrder(String sortBy, String sortOrder) {
    final sortedVendors = List<VendorItem>.from(vendors);

    switch (sortBy.toLowerCase()) {
      case 'store_name':
        sortedVendors.sort((a, b) => sortOrder == 'asc'
            ? a.storeName.compareTo(b.storeName)
            : b.storeName.compareTo(a.storeName));
        break;
      case 'store_type':
        sortedVendors.sort((a, b) => sortOrder == 'asc'
            ? a.storeType.compareTo(b.storeType)
            : b.storeType.compareTo(a.storeType));
        break;
      case 'created_at':
      default:
        sortedVendors.sort((a, b) => sortOrder == 'asc'
            ? a.createdAt.compareTo(b.createdAt)
            : b.createdAt.compareTo(a.createdAt));
        break;
    }

    vendors.assignAll(sortedVendors);
    print('📊 Sorted vendors by $sortBy ($sortOrder)');
  }

  void setPerPage(int perPage) {
    queryParams.value = queryParams.value.copyWith(perPage: perPage);
    getVendors();
  }

  void clearFilters() {
    queryParams.value = VendorQueryParams(
      perPage: 10,
      sortBy: 'created_at',
      sortOrder: 'desc',
    );
    vendors.assignAll(_originalVendors);
    print('🧹 Filters cleared, showing all ${_originalVendors.length} vendors');
  }

  // Helper methods
  void refreshVendors() {
    print('🔄 Refreshing vendor data...');
    getVendors();
  }

  List<VendorItem> get openVendors {
    return _originalVendors.where((vendor) => vendor.isOpen).toList();
  }

  List<VendorItem> get pendingVendors {
    return _originalVendors.where((vendor) => vendor.isPending).toList();
  }

  List<VendorItem> get closedVendors {
    return _originalVendors.where((vendor) => !vendor.isOpen && !vendor.isPending).toList();
  }

  VendorItem? getVendorById(int id) {
    try {
      return _originalVendors.firstWhere((vendor) => vendor.id == id);
    } catch (e) {
      return null;
    }
  }

  List<VendorItem> getVendorsByCategory(String category) {
    return _originalVendors.where((vendor) =>
    vendor.storeType.toLowerCase() == category.toLowerCase()
    ).toList();
  }

  // Statistics getters
  int get totalVendorsCount => _originalVendors.length;
  int get approvedVendorsCount => openVendors.length;
  int get pendingVendorsCount => pendingVendors.length;
  int get categoriesCount => categories.length;

  double get approvalRate {
    if (totalVendorsCount == 0) return 0.0;
    return (approvedVendorsCount / totalVendorsCount) * 100;
  }

  // Get unique store types for category generation
  List<String> get uniqueStoreTypes {
    return _originalVendors.map((v) => v.storeType).toSet().toList();
  }

  // Updated mock data method with realistic store types (fallback only)
  void loadMockData() {
    final mockVendors = [
      VendorItem(
        id: 1,
        adminId: 1,
        vendorId: 'VEND001',
        storeName: 'TechWorld Electronics',
        storeSlug: 'techworld-electronics',
        storeType: 'Electronics',
        logo: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400',
        banner: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
        address: 'Kolkata, West Bengal',
        contactNumber: '9876543210',
        about: 'Latest gadgets and electronics for all your tech needs',
        status: 'approved',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      VendorItem(
        id: 2,
        adminId: 2,
        vendorId: 'VEND002',
        storeName: 'Fashion Hub',
        storeSlug: 'fashion-hub',
        storeType: 'Fashion',
        logo: 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=400',
        banner: 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=800',
        address: 'Kolkata, West Bengal',
        contactNumber: '9876543211',
        about: 'Trendy clothes and accessories for all occasions',
        status: 'approved',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
      VendorItem(
        id: 3,
        adminId: 3,
        vendorId: 'VEND003',
        storeName: 'Fresh Mart',
        storeSlug: 'fresh-mart',
        storeType: 'Retail',
        logo: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
        banner: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800',
        address: 'Kolkata, West Bengal',
        contactNumber: '9876543212',
        about: 'Fresh groceries and daily essentials delivered to your door',
        status: 'approved',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
    ];

    vendors.assignAll(mockVendors);
    _originalVendors.assignAll(mockVendors);
    featuredVendors.assignAll(mockVendors.take(3).toList());

    final mockCategories = [
      VendorCategory(id: 1, name: 'Electronics', vendorCount: 1),
      VendorCategory(id: 2, name: 'Fashion', vendorCount: 1),
      VendorCategory(id: 3, name: 'Retail', vendorCount: 1),
    ];

    categories.assignAll(mockCategories);
    print('🔄 Loaded mock vendor data as fallback');
  }

  @override
  void onClose() {
    // Clean up resources
    vendors.clear();
    _originalVendors.clear();
    featuredVendors.clear();
    categories.clear();
    super.onClose();
  }
}