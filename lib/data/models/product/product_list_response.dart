// lib/data/models/product/product_list_response.dart
class ProductListResponse {
  final String status;
  final ProductListData data;

  ProductListResponse({
    required this.status,
    required this.data,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      status: json['status'] ?? '',
      data: ProductListData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class ProductListData {
  final int currentPage;
  final List<ProductVariant> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  ProductListData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory ProductListData.fromJson(Map<String, dynamic> json) {
    return ProductListData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List? ?? [])
          .map((item) => ProductVariant.fromJson(item))
          .toList(),
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'] ?? '',
      links: (json['links'] as List? ?? [])
          .map((item) => PaginationLink.fromJson(item))
          .toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((item) => item.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((item) => item.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class ProductVariant {
  final int id;
  final int productId;
  final String variantUid;
  final String name;
  final String price;
  final int stock;
  final int status;
  final DateTime createdAt;
  final String optionValue;
  final String totalSold;
  final Product product;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.variantUid,
    required this.name,
    required this.price,
    required this.stock,
    required this.status,
    required this.createdAt,
    required this.optionValue,
    required this.totalSold,
    required this.product,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      variantUid: json['variant_uid'] ?? '',
      name: json['name'] ?? '',
      price: json['price']?.toString() ?? '0',
      stock: json['stock'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      optionValue: json['option_value'] ?? '',
      totalSold: json['total_sold']?.toString() ?? '0',
      product: Product.fromJson(json['product'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'variant_uid': variantUid,
      'name': name,
      'price': price,
      'stock': stock,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'option_value': optionValue,
      'total_sold': totalSold,
      'product': product.toJson(),
    };
  }
}

class Product {
  final int id;
  final String productUid;
  final int catId;
  final int subCatId;
  final Category category;
  final Subcategory subcategory;

  Product({
    required this.id,
    required this.productUid,
    required this.catId,
    required this.subCatId,
    required this.category,
    required this.subcategory,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      productUid: json['product_uid'] ?? '',
      catId: json['cat_id'] ?? 0,
      subCatId: json['sub_cat_id'] ?? 0,
      category: Category.fromJson(json['category'] ?? {}),
      subcategory: Subcategory.fromJson(json['subcategory'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_uid': productUid,
      'cat_id': catId,
      'sub_cat_id': subCatId,
      'category': category.toJson(),
      'subcategory': subcategory.toJson(),
    };
  }
}

class Category {
  final int id;
  final String name;
  final String? tax;

  Category({
    required this.id,
    required this.name,
    this.tax,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      tax: json['tax']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tax': tax,
    };
  }
}

class Subcategory {
  final int id;
  final String name;
  final String? tax;

  Subcategory({
    required this.id,
    required this.name,
    this.tax,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      tax: json['tax']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tax': tax,
    };
  }
}

class PaginationLink {
  final String? url;
  final String label;
  final bool active;

  PaginationLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}