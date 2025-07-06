// lib/data/models/order/order_detail_response.dart
class OrderDetailResponse {
  final String status;
  final OrderDetail data;

  OrderDetailResponse({
    required this.status,
    required this.data,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      status: json['status'] ?? '',
      data: OrderDetail.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class OrderDetail {
  final int id;
  final int userId;
  final String orderId;
  final String userName;
  final String userMobile;
  final String? userEmail;
  final String shippingPin;
  final String shippingAddress;
  final int totalItem;
  final String totalPrice;
  final String? tax;
  final String deliveryCharge;
  final String? discount;
  final String totalPaid;
  final String? couponCode;
  final String paymentMode;
  final String paymentStatus;
  final String? transactionId;
  final String orderStatus;
  final String statusInfo;
  final String? rejectNote;
  final String? deliveryOtp;
  final String orderDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderDetailItem> orderDetails;

  OrderDetail({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.userName,
    required this.userMobile,
    this.userEmail,
    required this.shippingPin,
    required this.shippingAddress,
    required this.totalItem,
    required this.totalPrice,
    this.tax,
    required this.deliveryCharge,
    this.discount,
    required this.totalPaid,
    this.couponCode,
    required this.paymentMode,
    required this.paymentStatus,
    this.transactionId,
    required this.orderStatus,
    required this.statusInfo,
    this.rejectNote,
    this.deliveryOtp,
    required this.orderDate,
    required this.createdAt,
    required this.updatedAt,
    required this.orderDetails,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      orderId: json['order_id'] ?? '',
      userName: json['user_name'] ?? '',
      userMobile: json['user_mobile'] ?? '',
      userEmail: json['user_email'],
      shippingPin: json['shipping_pin'] ?? '',
      shippingAddress: json['shipping_address'] ?? '',
      totalItem: json['total_item'] ?? 0,
      totalPrice: json['total_price']?.toString() ?? '0',
      tax: json['tax']?.toString(),
      deliveryCharge: json['delivery_charge']?.toString() ?? '0',
      discount: json['discount']?.toString(),
      totalPaid: json['total_paid']?.toString() ?? '0',
      couponCode: json['coupon_code'],
      paymentMode: json['payment_mode'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      transactionId: json['transaction_id'],
      orderStatus: json['order_status'] ?? '',
      statusInfo: json['status_info'] ?? '',
      rejectNote: json['reject_note'],
      deliveryOtp: json['delivery_otp'],
      orderDate: json['order_date'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      orderDetails: (json['order_details'] as List? ?? [])
          .map((item) => OrderDetailItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_id': orderId,
      'user_name': userName,
      'user_mobile': userMobile,
      'user_email': userEmail,
      'shipping_pin': shippingPin,
      'shipping_address': shippingAddress,
      'total_item': totalItem,
      'total_price': totalPrice,
      'tax': tax,
      'delivery_charge': deliveryCharge,
      'discount': discount,
      'total_paid': totalPaid,
      'coupon_code': couponCode,
      'payment_mode': paymentMode,
      'payment_status': paymentStatus,
      'transaction_id': transactionId,
      'order_status': orderStatus,
      'status_info': statusInfo,
      'reject_note': rejectNote,
      'delivery_otp': deliveryOtp,
      'order_date': orderDate,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'order_details': orderDetails.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderDetailItem {
  final int id;
  final int orderId;
  final int productId;
  final int variantId;
  final String? productImg;
  final String productName;
  final String optionName;
  final String optionValue;
  final int quantity;
  final String price;
  final String printedPrice;
  final String orderStatus;
  final String statusInfo;
  final String? rejectNote;
  final String? refundAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OrderProduct product;
  final OrderVariant variants;

  OrderDetailItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.variantId,
    this.productImg,
    required this.productName,
    required this.optionName,
    required this.optionValue,
    required this.quantity,
    required this.price,
    required this.printedPrice,
    required this.orderStatus,
    required this.statusInfo,
    this.rejectNote,
    this.refundAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
    required this.variants,
  });

  factory OrderDetailItem.fromJson(Map<String, dynamic> json) {
    return OrderDetailItem(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      variantId: json['variant_id'] ?? 0,
      productImg: json['product_img'],
      productName: json['product_name'] ?? '',
      optionName: json['option_name'] ?? '',
      optionValue: json['option_value'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: json['price']?.toString() ?? '0',
      printedPrice: json['printed_price']?.toString() ?? '0',
      orderStatus: json['order_status'] ?? '',
      statusInfo: json['status_info'] ?? '',
      rejectNote: json['reject_note'],
      refundAmount: json['refund_amount']?.toString(),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      product: OrderProduct.fromJson(json['product'] ?? {}),
      variants: OrderVariant.fromJson(json['variants'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'variant_id': variantId,
      'product_img': productImg,
      'product_name': productName,
      'option_name': optionName,
      'option_value': optionValue,
      'quantity': quantity,
      'price': price,
      'printed_price': printedPrice,
      'order_status': orderStatus,
      'status_info': statusInfo,
      'reject_note': rejectNote,
      'refund_amount': refundAmount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'product': product.toJson(),
      'variants': variants.toJson(),
    };
  }
}

class OrderProduct {
  final int id;
  final int parentId;
  final int adminId;
  final int catId;
  final int subCatId;
  final String productUid;
  final String? tags;
  final String audienceSpecific;
  final int status;
  final int trash;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderProduct({
    required this.id,
    required this.parentId,
    required this.adminId,
    required this.catId,
    required this.subCatId,
    required this.productUid,
    this.tags,
    required this.audienceSpecific,
    required this.status,
    required this.trash,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      adminId: json['admin_id'] ?? 0,
      catId: json['cat_id'] ?? 0,
      subCatId: json['sub_cat_id'] ?? 0,
      productUid: json['product_uid'] ?? '',
      tags: json['tags'],
      audienceSpecific: json['audience_specific'] ?? '',
      status: json['status'] ?? 0,
      trash: json['trash'] ?? 0,
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
      'sub_cat_id': subCatId,
      'product_uid': productUid,
      'tags': tags,
      'audience_specific': audienceSpecific,
      'status': status,
      'trash': trash,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class OrderVariant {
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

  OrderVariant({
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

  factory OrderVariant.fromJson(Map<String, dynamic> json) {
    return OrderVariant(
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

// Update the OrderItem model for list view
class OrderItem {
  final int id;
  final String orderId;
  final String userName;
  final String userMobile;
  final String orderStatus;
  final String paymentStatus;
  final String paymentMode;
  final String totalPrice;
  final String totalPaid;
  final int totalItem;
  final DateTime orderDate;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.userName,
    required this.userMobile,
    required this.orderStatus,
    required this.paymentStatus,
    required this.paymentMode,
    required this.totalPrice,
    required this.totalPaid,
    required this.totalItem,
    required this.orderDate,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? '',
      userName: json['user_name'] ?? '',
      userMobile: json['user_mobile'] ?? '',
      orderStatus: json['order_status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentMode: json['payment_mode'] ?? '',
      totalPrice: json['total_price']?.toString() ?? '0',
      totalPaid: json['total_paid']?.toString() ?? '0',
      totalItem: json['total_item'] ?? 0,
      orderDate: DateTime.parse(json['order_date'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'user_name': userName,
      'user_mobile': userMobile,
      'order_status': orderStatus,
      'payment_status': paymentStatus,
      'payment_mode': paymentMode,
      'total_price': totalPrice,
      'total_paid': totalPaid,
      'total_item': totalItem,
      'order_date': orderDate.toIso8601String(),
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