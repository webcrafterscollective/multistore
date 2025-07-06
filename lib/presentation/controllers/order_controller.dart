// lib/presentation/controllers/order_controller.dart
import 'package:get/get.dart';
import '../../data/models/order/order_list_response.dart';
import '../../data/models/order/order_detail_response.dart';
import '../../data/models/order/order_query_params.dart';
import '../../data/repositories/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository _orderRepository;

  OrderController(this._orderRepository);

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxList<OrderItem> orders = <OrderItem>[].obs;
  final Rx<OrderDetail?> selectedOrder = Rx<OrderDetail?>(null);
  final RxString errorMessage = ''.obs;
  final RxList<int> selectedOrderIds = <int>[].obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxBool hasMorePages = false.obs;

  // Filters
  final Rx<OrderQueryParams> queryParams = OrderQueryParams(
    perPage: 10,
    sortBy: 'order_date',
    sortOrder: 'desc',
  ).obs;

  // Order status options
  final List<String> orderStatuses = [
    'Order Placed',
    'Order Confirmed',
    'Ready to Package',
    'Packaged',
    'Shipped',
    'Out for Delivery',
    'Delivered',
    'Cancelled',
    'Returned',
  ];

  final List<String> paymentStatuses = [
    'Pending',
    'Paid',
    'Failed',
    'Refunded',
  ];

  final List<String> paymentModes = [
    'COD',
    'Online',
    'Card',
    'UPI',
    'Wallet',
  ];

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  Future<void> getOrders({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (!hasMorePages.value || isLoadingMore.value) return;
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        orders.clear();
        currentPage.value = 1;
      }

      final params = queryParams.value.copyWith(
        page: loadMore ? currentPage.value + 1 : 1,
      );

      final response = await _orderRepository.getOrders(params: params);

      if (response.isSuccess && response.data != null) {
        final data = response.data!;

        if (loadMore) {
          orders.addAll(data.data);
          currentPage.value = data.currentPage;
        } else {
          orders.assignAll(data.data);
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

  Future<void> getOrder(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _orderRepository.getOrder(id);

      if (response.isSuccess && response.data != null) {
        selectedOrder.value = response.data!;
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

  Future<void> updateOrderStatus(int id, String orderStatus) async {
    try {
      isLoading.value = true;

      final response = await _orderRepository.updateOrderStatus(id, orderStatus);

      if (response.isSuccess) {
        Get.snackbar('Success', response.message);
        await getOrders(); // Refresh orders list
        if (selectedOrder.value?.id == id) {
          await getOrder(id); // Refresh selected order if it's currently viewed
        }
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> bulkUpdateOrderStatus(String action) async {
    if (selectedOrderIds.isEmpty) {
      Get.snackbar('Error', 'Please select orders to update');
      return;
    }

    try {
      isLoading.value = true;

      final response = await _orderRepository.bulkUpdateOrderStatus(
        action,
        selectedOrderIds.toList(),
      );

      if (response.isSuccess) {
        Get.snackbar('Success', response.message);
        selectedOrderIds.clear();
        await getOrders(); // Refresh orders list
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to bulk update order status');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkPackagedStatus(int id) async {
    try {
      final response = await _orderRepository.checkPackagedStatus(id);

      if (response.isSuccess) {
        Get.snackbar('Info', response.message);
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to check packaged status');
    }
  }

  // Filter methods
  void searchOrders(String query) {
    queryParams.value = queryParams.value.copyWith(search: query);
    getOrders();
  }

  void filterByOrderStatus(String? orderStatus) {
    queryParams.value = queryParams.value.copyWith(orderStatus: orderStatus);
    getOrders();
  }

  void filterByPaymentStatus(String? paymentStatus) {
    queryParams.value = queryParams.value.copyWith(paymentStatus: paymentStatus);
    getOrders();
  }

  void filterByPaymentMode(String? paymentMode) {
    queryParams.value = queryParams.value.copyWith(paymentMode: paymentMode);
    getOrders();
  }

  void filterByDateRange(String? dateFilter) {
    queryParams.value = queryParams.value.copyWith(dateFilter: dateFilter);
    getOrders();
  }

  void setSortOrder(String sortBy, String sortOrder) {
    queryParams.value = queryParams.value.copyWith(
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    getOrders();
  }

  void setPerPage(int perPage) {
    queryParams.value = queryParams.value.copyWith(perPage: perPage);
    getOrders();
  }

  void clearFilters() {
    queryParams.value = OrderQueryParams(
      perPage: 10,
      sortBy: 'order_date',
      sortOrder: 'desc',
    );
    getOrders();
  }

  // Selection methods
  void toggleOrderSelection(int orderId) {
    if (selectedOrderIds.contains(orderId)) {
      selectedOrderIds.remove(orderId);
    } else {
      selectedOrderIds.add(orderId);
    }
  }

  void selectAllOrders() {
    selectedOrderIds.assignAll(orders.map((order) => order.id).toList());
  }

  void clearSelection() {
    selectedOrderIds.clear();
  }

  bool isOrderSelected(int orderId) {
    return selectedOrderIds.contains(orderId);
  }

  // Helper methods
  void refreshOrders() {
    getOrders();
  }

  List<OrderItem> get pendingOrders {
    return orders.where((order) =>
    order.orderStatus != 'Delivered' &&
        order.orderStatus != 'Cancelled'
    ).toList();
  }

  List<OrderItem> get completedOrders {
    return orders.where((order) =>
    order.orderStatus == 'Delivered'
    ).toList();
  }

  List<OrderItem> get cancelledOrders {
    return orders.where((order) =>
    order.orderStatus == 'Cancelled'
    ).toList();
  }

  double get totalOrderValue {
    return orders.fold(0.0, (sum, order) =>
    sum + (double.tryParse(order.totalPaid) ?? 0.0)
    );
  }

  OrderItem? getOrderById(int id) {
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  List<String> parseStatusInfo(String statusInfo) {
    // Parse status info string like "Order Placed|2025-04-07 17:25:14||Order Confirmed|2025-04-08 21:15:03"
    return statusInfo.split('||').where((s) => s.isNotEmpty).toList();
  }

  String getLatestStatus(String statusInfo) {
    final statuses = parseStatusInfo(statusInfo);
    if (statuses.isEmpty) return 'Unknown';

    final lastStatus = statuses.last;
    final parts = lastStatus.split('|');
    return parts.isNotEmpty ? parts[0] : 'Unknown';
  }

  DateTime? getLatestStatusDate(String statusInfo) {
    final statuses = parseStatusInfo(statusInfo);
    if (statuses.isEmpty) return null;

    final lastStatus = statuses.last;
    final parts = lastStatus.split('|');
    if (parts.length >= 2) {
      try {
        return DateTime.parse(parts[1]);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}