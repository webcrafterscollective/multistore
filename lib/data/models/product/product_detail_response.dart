// lib/data/models/product/product_detail_response.dart
class ProductDetailResponse {
  final String status;
  final ProductDetail data;

  ProductDetailResponse({
    required this.status,
    required this.data,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      status: json['status'] ?? '',
      data: ProductDetail.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class ProductDetail {
  final int id;
  final int parentId;
  final int adminId;
  final int catId;
  final int subCatId;
  final String productUid;
  final String tags;
  final String audienceSpecific;
  final int status;
  final int trash;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryDetail category;
  final SubcategoryDetail subcategory;
  final ProductDetails details;
  final List<ProductAttribute> attributes;
  final List<ProductVariantDetail> variants;

  ProductDetail({
    required this.id,
    required this.parentId,
    required this.adminId,
    required this.catId,
    required this.subCatId,
    required this.productUid,
    required this.tags,
    required this.audienceSpecific,
    required this.status,
    required this.trash,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.subcategory,
    required this.details,
    required this.attributes,
    required this.variants,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      catId: json['cat_id'] ?? 0,
      subCatId: json['sub_cat_id'] ?? 0,
      productUid: json['product_uid'] ?? '',
      tags: json['tags'] ?? '',
      audienceSpecific: json['audience_specific'] ?? '',
      status: json['status'] ?? 0,
      trash: json['trash'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      category: CategoryDetail.fromJson(json['category'] ?? {}),
      subcategory: SubcategoryDetail.fromJson(json['subcategory'] ?? {}),
      details: ProductDetails.fromJson(json['details'] ?? {}),
      attributes: (json['attributes'] as List? ?? [])
          .map((item) => ProductAttribute.fromJson(item))
          .toList(),
      variants: (json['variants'] as List? ?? [])
          .map((item) => ProductVariantDetail.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'admin_id': adminId,
      'cat_id': catId,
      'sub_cat_id': subCatId,
      'product_uid': productUid,
      'tags': tags,
      'audience_specific': audienceSpecific,
      'status': status,
      'trash': trash,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'category': category.toJson(),
      'subcategory': subcategory.toJson(),
      'details': details.toJson(),
      'attributes': attributes.map((item) => item.toJson()).toList(),
      'variants': variants.map((item) => item.toJson()).toList(),
    };
  }
}

class CategoryDetail {
  final int id;
  final int parentId;
  final int adminId;
  final String name;
  final String title;
  final int? position;
  final String tax;
  final String img;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryDetail({
    required this.id,
    required this.parentId,
    required this.adminId,
    required this.name,
    required this.title,
    this.position,
    required this.tax,
    required this.img,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) {
    return CategoryDetail(
      id: json['id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      position: json['position'],
      tax: json['tax']?.toString() ?? '0',
      img: json['img'] ?? '',
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'admin_id': adminId,
      'name': name,
      'title': title,
      'position': position,
      'tax': tax,
      'img': img,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class SubcategoryDetail {
  final int id;
  final int parentId;
  final int adminId;
  final int catId;
  final String pageType;
  final String name;
  final String title;
  final int? position;
  final String tax;
  final String img;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubcategoryDetail({
    required this.id,
    required this.parentId,
    required this.adminId,
    required this.catId,
    required this.pageType,
    required this.name,
    required this.title,
    this.position,
    required this.tax,
    required this.img,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubcategoryDetail.fromJson(Map<String, dynamic> json) {
    return SubcategoryDetail(
      id: json['id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      catId: json['cat_id'] ?? 0,
      pageType: json['page_type'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      position: json['position'],
      tax: json['tax']?.toString() ?? '0',
      img: json['img'] ?? '',
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'admin_id': adminId,
      'cat_id': catId,
      'page_type': pageType,
      'name': name,
      'title': title,
      'position': position,
      'tax': tax,
      'img': img,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProductDetails {
  final int id;
  final int parentId;
  final int adminId;
  final int productId;
  final String description;
  final int returnDay;
  final String? returnDayUnit;
  final int warranty;
  final String warrantyUnit;
  final String manufacturerDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductDetails({
    required this.id,
    required this.parentId,
    required this.adminId,
    required this.productId,
    required this.description,
    required this.returnDay,
    this.returnDayUnit,
    required this.warranty,
    required this.warrantyUnit,
    required this.manufacturerDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      description: json['description'] ?? '',
      returnDay: json['return_day'] ?? 0,
      returnDayUnit: json['return_day_unit'],
      warranty: json['warranty'] ?? 0,
      warrantyUnit: json['warranty_unit'] ?? '',
      manufacturerDetails: json['manufacturer_details'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'admin_id': adminId,
      'product_id': productId,
      'description': description,
      'return_day': returnDay,
      'return_day_unit': returnDayUnit,
      'warranty': warranty,
      'warranty_unit': warrantyUnit,
      'manufacturer_details': manufacturerDetails,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProductAttribute {
  final String name;
  final String value;

  ProductAttribute({
    required this.name,
    required this.value,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

class ProductVariantDetail {
  final int id;
  final int parentId;
  final int adminId;
  final int productId;
  final String variantUid;
  final int groupId;
  final String keywords;
  final String slug;
  final String name;
  final String mainImg;
  final String? otherImg;
  final int status;
  final int? trash;
  final String optionName;
  final String optionValue;
  final String costPrice;
  final String printedPrice;
  final String price;
  final String finalPrice;
  final int stock;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductVariantDetail({
    required this.id,
    required this.parentId,
    required this.adminId,
    required this.productId,
    required this.variantUid,
    required this.groupId,
    required this.keywords,
    required this.slug,
    required this.name,
    required this.mainImg,
    this.otherImg,
    required this.status,
    this.trash,
    required this.optionName,
    required this.optionValue,
    required this.costPrice,
    required this.printedPrice,
    required this.price,
    required this.finalPrice,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductVariantDetail.fromJson(Map<String, dynamic> json) {
    return ProductVariantDetail(
      id: json['id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      variantUid: json['variant_uid'] ?? '',
      groupId: json['group_id'] ?? 0,
      keywords: json['keywords'] ?? '',
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      mainImg: json['main_img'] ?? '',
      otherImg: json['other_img'],
      status: json['status'] ?? 0,
      trash: json['trash'],
      optionName: json['option_name'] ?? '',
      optionValue: json['option_value'] ?? '',
      costPrice: json['cost_price']?.toString() ?? '0',
      printedPrice: json['printed_price']?.toString() ?? '0',
      price: json['price']?.toString() ?? '0',
      finalPrice: json['final_price']?.toString() ?? '0',
      stock: json['stock'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'admin_id': adminId,
      'product_id': productId,
      'variant_uid': variantUid,
      'group_id': groupId,
      'keywords': keywords,
      'slug': slug,
      'name': name,
      'main_img': mainImg,
      'other_img': otherImg,
      'status': status,
      'trash': trash,
      'option_name': optionName,
      'option_value': optionValue,
      'cost_price': costPrice,
      'printed_price': printedPrice,
      'price': price,
      'final_price': finalPrice,
      'stock': stock,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}