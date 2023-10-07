class ResponseDTO {
  final String? status;
  final int? statusCode;
  final String? message;
  final String? language;
  final dynamic data;

  ResponseDTO({
    this.status,
    this.statusCode,
    this.message,
    this.language,
    this.data,
  });

  factory ResponseDTO.fromJson(Map<String, dynamic> json) {
    return ResponseDTO(
      status: json['status'] ?? 'No Status',
      statusCode: json['statusCode'] ?? 'No Status Code',
      message: json['message'] ?? 'No Message',
      language: json['language'] ?? 'en',
      data: json['data'] ?? null,
    );
  }
}
