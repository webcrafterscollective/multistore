// lib/data/models/customer/customer_query_params.dart
class CustomerQueryParams {
  final String? search;
  final bool? isActive;
  final int? perPage;
  final String? sortBy;
  final String? sortOrder;
  final int? page;

  CustomerQueryParams({
    this.search,
    this.isActive,
    this.perPage,
    this.sortBy,
    this.sortOrder,
    this.page,
  });

  Map<String, dynamic> toQueryParameters() {
    Map<String, dynamic> params = {};

    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (isActive != null) params['is_active'] = isActive.toString();
    if (perPage != null) params['per_page'] = perPage.toString();
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    if (page != null) params['page'] = page.toString();

    return params;
  }

  CustomerQueryParams copyWith({
    String? search,
    bool? isActive,
    int? perPage,
    String? sortBy,
    String? sortOrder,
    int? page,
  }) {
    return CustomerQueryParams(
      search: search ?? this.search,
      isActive: isActive ?? this.isActive,
      perPage: perPage ?? this.perPage,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      page: page ?? this.page,
    );
  }
}