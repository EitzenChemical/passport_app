import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'applications_page.dart';

// Хэширование пароля
String _hashPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return base64.encode(hash.bytes);
}

// Авторизация
Future<void> login(String fullName, String password) async {
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
    int userId = int.parse(response.body);
    await _saveUserId(userId);
    print('Login successful, UserId: $userId');
  } else {
    print('Login failed: ${response.body}');
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

// Страница Логина
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Функция для логина и перехода на следующий экран
  Future<void> _handleLogin() async {
    String fullName = fullNameController.text;
    String password = passwordController.text;

    if (fullName.isNotEmpty && password.isNotEmpty) {
      await login(fullName, password);  // Пытаемся выполнить логин

      // Получаем UserId из SharedPreferences
      int? userId = await _getUserId();
      if (userId != null) {
        // Если вход успешен, переходим на экран заявок
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ApplicationsPage()),
        );
      } else {
        // Если UserId не найден, показываем ошибку
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка входа.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Заполните все поля.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Авторизация')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Полное имя'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Пароль'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}