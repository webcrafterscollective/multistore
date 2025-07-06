// lib/data/models/order/order_query_params.dart
class OrderQueryParams {
  final String? search;
  final String? orderStatus;
  final String? paymentStatus;
  final String? paymentMode;
  final String? dateFilter;
  final int? perPage;
  final String? sortBy;
  final String? sortOrder;
  final int? page;

  OrderQueryParams({
    this.search,
    this.orderStatus,
    this.paymentStatus,
    this.paymentMode,
    this.dateFilter,
    this.perPage,
    this.sortBy,
    this.sortOrder,
    this.page,
  });

  Map<String, dynamic> toQueryParameters() {
    Map<String, dynamic> params = {};

    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (orderStatus != null && orderStatus!.isNotEmpty) params['order_status'] = orderStatus;
    if (paymentStatus != null && paymentStatus!.isNotEmpty) params['payment_status'] = paymentStatus;
    if (paymentMode != null && paymentMode!.isNotEmpty) params['payment_mode'] = paymentMode;
    if (dateFilter != null && dateFilter!.isNotEmpty) params['date_filter'] = dateFilter;
    if (perPage != null) params['per_page'] = perPage.toString();
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    if (page != null) params['page'] = page.toString();

    return params;
  }

  OrderQueryParams copyWith({
    String? search,
    String? orderStatus,
    String? paymentStatus,
    String? paymentMode,
    String? dateFilter,
    int? perPage,
    String? sortBy,
    String? sortOrder,
    int? page,
  }) {
    return OrderQueryParams(
      search: search ?? this.search,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMode: paymentMode ?? this.paymentMode,
      dateFilter: dateFilter ?? this.dateFilter,
      perPage: perPage ?? this.perPage,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      page: page ?? this.page,
    );
  }
}
