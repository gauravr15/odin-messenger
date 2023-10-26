class APIInfoResponseDTO {
  final int id;
  final String environment;
  final String action;
  final String module;
  final bool isAuthRequired;
  final String uri;
  final String createdTime;
  final String updateTime;

  APIInfoResponseDTO({
    required this.id,
    required this.environment,
    required this.action,
    required this.module,
    required this.isAuthRequired,
    required this.uri,
    required this.createdTime,
    required this.updateTime,
  });

  factory APIInfoResponseDTO.fromJson(Map<String, dynamic> json) {
    return APIInfoResponseDTO(
      id: json['id'],
      environment: json['environment'],
      action: json['action'],
      module: json['module'],
      isAuthRequired: json['isAuthRequired'],
      uri: json['uri'],
      createdTime: json['createdTime'],
      updateTime: json['updateTime'],
    );
  }
}
