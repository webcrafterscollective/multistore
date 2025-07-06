// lib/data/models/order/order_status_update_request.dart
class OrderStatusUpdateRequest {
  final String orderStatus;

  OrderStatusUpdateRequest({
    required this.orderStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'order_status': orderStatus,
    };
  }
}
