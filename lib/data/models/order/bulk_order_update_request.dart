// lib/data/models/order/bulk_order_update_request.dart
class BulkOrderUpdateRequest {
  final String action;
  final List<int> selectedItems;

  BulkOrderUpdateRequest({
    required this.action,
    required this.selectedItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'selected_items': selectedItems,
    };
  }
}