import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Функция хэширования пароля
String _hashPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
}

// Функция авторизации
Future<void> login(String fullName, String password) async {
  // Хэшируем пароль
  String hashedPassword = _hashPassword(password);

  final response = await http.post(
    Uri.parse('http://62.60.234.81:2004/Passport/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'FullName': fullName,
      'PasswordHash': hashedPassword,
    }),
  );

  if (response.statusCode == 200) {
    // Пароль и имя пользователя верные, сохраняем UserId
    var userId = await getUserId(fullName);
    _saveUserId(userId);
    print('Login successful, UserId: $userId');
  } else {
    print('Login failed: ${response.body}');
  }
}

// Функция для получения UserId (например, по имени пользователя)
Future<int> getUserId(String fullName) async {
  final response = await http.get(
    Uri.parse('http://62.60.234.81:2004/Passport/user/$fullName'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data['UserId'];  // Получаем UserId из ответа
  } else {
    throw Exception('Failed to load user ID');
  }
}

// Сохранение UserId в SharedPreferences
Future<void> _saveUserId(int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('userId', userId);
}

// Получение UserId из SharedPreferences
Future<int?> _getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId');
}