// lib/data/models/common/api_response.dart
class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;
  final dynamic error;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.error,
  });

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJsonT,
      ) {
    return ApiResponse<T>(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      error: json['error'],
    );
  }
}