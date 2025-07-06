// lib/data/models/vendor/vendor_query_params.dart
class VendorQueryParams {
  final String? search;
  final String? category;
  final String? sortBy;
  final String? sortOrder;
  final bool? isOpen;
  final int? perPage;
  final int? page;

  VendorQueryParams({
    this.search,
    this.category,
    this.sortBy,
    this.sortOrder,
    this.isOpen,
    this.perPage,
    this.page,
  });

  Map<String, dynamic> toQueryParameters() {
    Map<String, dynamic> params = {};

    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (category != null && category!.isNotEmpty) params['category'] = category;
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    if (isOpen != null) params['is_open'] = isOpen.toString();
    if (perPage != null) params['per_page'] = perPage.toString();
    if (page != null) params['page'] = page.toString();

    return params;
  }

  VendorQueryParams copyWith({
    String? search,
    String? category,
    String? sortBy,
    String? sortOrder,
    bool? isOpen,
    int? perPage,
    int? page,
  }) {
    return VendorQueryParams(
      search: search ?? this.search,
      category: category ?? this.category,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      isOpen: isOpen ?? this.isOpen,
      perPage: perPage ?? this.perPage,
      page: page ?? this.page,
    );
  }
}