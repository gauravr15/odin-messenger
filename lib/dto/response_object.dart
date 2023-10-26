class ResponseObject {
  final int statusCode;
  final String status;
  final dynamic data;
  final String language;

  ResponseObject({
    required this.statusCode,
    required this.status,
    required this.data,
    required this.language,
  });

  factory ResponseObject.fromJson(Map<String, dynamic> json) {
    return ResponseObject(
      statusCode: json['statusCode'],
      status: json['status'],
      data: json['data'],
      language: json['language'],
    );
  }
}
