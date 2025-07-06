// lib/presentation/controllers/customer_controller.dart
import 'package:get/get.dart';
import '../../data/models/customer/customer_list_response.dart';
import '../../data/models/customer/customer_detail_response.dart';
import '../../data/models/customer/customer_query_params.dart';
import '../../data/models/customer/customer_update_request.dart';
import '../../data/repositories/customer_repository.dart';

class CustomerController extends GetxController {
  final CustomerRepository _customerRepository;

  CustomerController(this._customerRepository);

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxList<CustomerItem> customers = <CustomerItem>[].obs;
  final Rx<CustomerDetail?> selectedCustomer = Rx<CustomerDetail?>(null);
  final Rx<CustomerStatistics?> statistics = Rx<CustomerStatistics?>(null);
  final RxString errorMessage = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxBool hasMorePages = false.obs;

  // Filters
  final Rx<CustomerQueryParams> queryParams = CustomerQueryParams(
    perPage: 10,
    sortBy: 'created_at',
    sortOrder: 'desc',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getCustomers();
  }

  Future<void> getCustomers({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (!hasMorePages.value || isLoadingMore.value) return;
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        customers.clear();
        currentPage.value = 1;
      }

      final params = queryParams.value.copyWith(
        page: loadMore ? currentPage.value + 1 : 1,
      );

      final response = await _customerRepository.getCustomers(params: params);

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final customerList = data.customers;

        if (loadMore) {
          customers.addAll(customerList.data);
          currentPage.value = customerList.currentPage;
        } else {
          customers.assignAll(customerList.data);
          currentPage.value = customerList.currentPage;
          statistics.value = data.statistics;
        }

        totalPages.value = customerList.lastPage;
        totalItems.value = customerList.total;
        hasMorePages.value = customerList.currentPage < customerList.lastPage;

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

  Future<void> getCustomerStatistics() async {
    try {
      final response = await _customerRepository.getCustomerStatistics();

      if (response.isSuccess && response.data != null) {
        statistics.value = response.data!;
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch customer statistics');
    }
  }

  Future<void> getCustomer(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _customerRepository.getCustomer(id);

      if (response.isSuccess && response.data != null) {
        selectedCustomer.value = response.data!;
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

  Future<void> updateCustomer({
    required int id,
    String? name,
    String? phone,
    String? email,
    String? address,
  }) async {
    try {
      isLoading.value = true;

      final request = CustomerUpdateRequest(
        name: name,
        phone: phone,
        email: email,
        address: address,
      );

      final response = await _customerRepository.updateCustomer(id, request);

      if (response.isSuccess) {
        Get.snackbar('Success', response.message);
        await getCustomers(); // Refresh customers list
        if (selectedCustomer.value?.id == id) {
          await getCustomer(id); // Refresh selected customer if it's currently viewed
        }
        Get.back(); // Close edit customer screen
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update customer');
    } finally {
      isLoading.value = false;
    }
  }

  // Filter methods
  void searchCustomers(String query) {
    queryParams.value = queryParams.value.copyWith(search: query);
    getCustomers();
  }

  void filterByStatus(bool? isActive) {
    queryParams.value = queryParams.value.copyWith(isActive: isActive);
    getCustomers();
  }

  void setSortOrder(String sortBy, String sortOrder) {
    queryParams.value = queryParams.value.copyWith(
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    getCustomers();
  }

  void setPerPage(int perPage) {
    queryParams.value = queryParams.value.copyWith(perPage: perPage);
    getCustomers();
  }

  void clearFilters() {
    queryParams.value = CustomerQueryParams(
      perPage: 10,
      sortBy: 'created_at',
      sortOrder: 'desc',
    );
    getCustomers();
  }

  // Helper methods
  void refreshCustomers() {
    getCustomers();
  }

  List<CustomerItem> get activeCustomersOnly {
    // Since we don't have status in the response, we'll consider all as active for now
    return customers.toList();
  }

  List<CustomerItem> get recentCustomers {
    return customers.where((customer) {
      final daysDiff = DateTime.now().difference(customer.createdAt).inDays;
      return daysDiff <= 30; // Customers from last 30 days
    }).toList();
  }

  CustomerItem? getCustomerById(int id) {
    try {
      return customers.firstWhere((customer) => customer.id == id);
    } catch (e) {
      return null;
    }
  }

  CustomerItem? getCustomerByEmail(String email) {
    try {
      return customers.firstWhere((customer) => customer.email == email);
    } catch (e) {
      return null;
    }
  }

  CustomerItem? getCustomerByPhone(String phone) {
    try {
      return customers.firstWhere((customer) => customer.phone == phone);
    } catch (e) {
      return null;
    }
  }

  // Statistics helpers
  int get totalCustomersCount => statistics.value?.totalCustomers ?? 0;
  int get newCustomersCount => statistics.value?.newCustomers ?? 0;
  int get activeCustomersCount => statistics.value?.activeCustomers ?? 0;
  int get inactiveCustomersCount => statistics.value?.inactiveCustomers ?? 0;

  double get activeCustomersPercentage {
    if (totalCustomersCount == 0) return 0.0;
    return (activeCustomersCount / totalCustomersCount) * 100;
  }

  double get customerGrowthRate {
    // Calculate growth rate based on new customers vs total
    if (totalCustomersCount == 0) return 0.0;
    return (newCustomersCount / totalCustomersCount) * 100;
  }
}