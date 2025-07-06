// lib/data/models/product/product_query_params.dart
class ProductQueryParams {
  final String? search;
  final int? perPage;
  final String? sortBy;
  final String? sortOrder;
  final int? adminId;
  final int? categoryId;
  final int? subcategoryId;
  final double? minPrice;
  final double? maxPrice;
  final bool? inStock;
  final int? page;

  ProductQueryParams({
    this.search,
    this.perPage,
    this.sortBy,
    this.sortOrder,
    this.adminId,
    this.categoryId,
    this.subcategoryId,
    this.minPrice,
    this.maxPrice,
    this.inStock,
    this.page,
  });

  Map<String, dynamic> toQueryParameters() {
    Map<String, dynamic> params = {};

    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (perPage != null) params['per_page'] = perPage.toString();
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    if (adminId != null) params['admin_id'] = adminId.toString();
    if (categoryId != null) params['category_id'] = categoryId.toString();
    if (subcategoryId != null) params['subcategory_id'] = subcategoryId.toString();
    if (minPrice != null) params['min_price'] = minPrice.toString();
    if (maxPrice != null) params['max_price'] = maxPrice.toString();
    if (inStock != null) params['in_stock'] = inStock.toString();
    if (page != null) params['page'] = page.toString();

    return params;
  }

  ProductQueryParams copyWith({
    String? search,
    int? perPage,
    String? sortBy,
    String? sortOrder,
    int? adminId,
    int? categoryId,
    int? subcategoryId,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    int? page,
  }) {
    return ProductQueryParams(
      search: search ?? this.search,
      perPage: perPage ?? this.perPage,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      adminId: adminId ?? this.adminId,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      inStock: inStock ?? this.inStock,
      page: page ?? this.page,
    );
  }
}