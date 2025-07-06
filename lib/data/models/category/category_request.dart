// lib/data/models/category/category_request.dart
class CategoryCreateRequest {
  final String name;
  final int position;
  final bool status;
  final double? tax;
  final String? image;

  CategoryCreateRequest({
    required this.name,
    required this.position,
    required this.status,
    this.tax,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'position': position,
      'status': status,
      if (tax != null) 'tax': tax,
      if (image != null) 'image': image,
    };
  }
}

class CategoryUpdateRequest {
  final String? name;
  final int? position;
  final bool? status;
  final double? tax;
  final String? image;

  CategoryUpdateRequest({
    this.name,
    this.position,
    this.status,
    this.tax,
    this.image,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (name != null) data['name'] = name;
    if (position != null) data['position'] = position;
    if (status != null) data['status'] = status;
    if (tax != null) data['tax'] = tax;
    if (image != null) data['image'] = image;

    return data;
  }
}