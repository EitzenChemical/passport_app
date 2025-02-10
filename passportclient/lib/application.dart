import 'dart:convert';
import 'dart:typed_data';

class Application {
  int? applicationId;
  int userId;
  DateTime? dateSubmitted;
  String reason;
  String? status;
  List<Uint8List> documentPhotos; // Сохраняем список фото как List<Uint8List>

  Application({
    this.applicationId,
    required this.userId,
    this.dateSubmitted,
    required this.reason,
    this.status,
    required this.documentPhotos,
  });

  // Метод для создания объекта из JSON
  factory Application.fromJson(Map<String, dynamic> json) {
    List<dynamic> photoList = json['documentPhotos'] ?? [];
    List<Uint8List> decodedPhotos = photoList.map((photo) => base64Decode(photo)).toList();

    return Application(
      applicationId: json['applicationId'],
      userId: json['userId'],
      dateSubmitted: json['dateSubmitted'] != null
          ? DateTime.parse(json['dateSubmitted'])
          : null,
      reason: json['reason'],
      status: json['status'],
      documentPhotos: decodedPhotos,
    );
  }

  // Метод для конвертации в JSON
  Map<String, dynamic> toJson() {
    return {
      'applicationId': applicationId,
      'userId': userId,
      'dateSubmitted': dateSubmitted?.toIso8601String(),
      'reason': reason,
      'status': status,
      'documentPhotos': documentPhotos.map((photo) => base64Encode(photo)).toList(),
    };
  }
}