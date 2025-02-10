import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'application.dart';

// Функция для создания заявки
Future<bool> createApplication(int userId, String reason, List<Uint8List> documentPhotos) async {
  final url = Uri.parse('http://62.60.234.81:2004/Passport');

  final application = Application(
    userId: userId,
    reason: reason,
    documentPhotos: documentPhotos,
  );

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(application.toJson()),
  );

  if (response.statusCode == 201) {
    print('Application created successfully');
    return true;
  } else {
    print('Failed to create application');
    return false;
  }
}