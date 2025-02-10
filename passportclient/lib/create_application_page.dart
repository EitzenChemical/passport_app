import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:passport_app/pick_img.dart'; // Предположим, что здесь у вас метод pickImage
import 'package:shared_preferences/shared_preferences.dart';

import 'create_application.dart';

class CreateApplicationPage extends StatefulWidget {
  CreateApplicationPage();

  @override
  _CreateApplicationPageState createState() => _CreateApplicationPageState();
}

class _CreateApplicationPageState extends State<CreateApplicationPage> {
  late TextEditingController reasonController;
  late List<Uint8List> selectedImages; // Теперь список изображений

  @override
  void initState() {
    super.initState();
    reasonController = TextEditingController();
    selectedImages = []; // Инициализируем пустой список изображений
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Application')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле для ввода причины
            TextField(
              controller: reasonController,
              decoration: InputDecoration(labelText: 'Reason'),
            ),
            SizedBox(height: 10),

            // Кнопка для выбора изображения
            ElevatedButton(
              onPressed: () async {
                // Выбираем изображение и добавляем его в список
                var selectedImage = await pickImage();
                if (selectedImage != null) {
                  setState(() {
                    selectedImages.add(selectedImage); // Добавляем изображение в список
                  });
                }
              },
              child: Text('Pick Document Photo'),
            ),
            SizedBox(height: 10),

            // Отображаем выбранные изображения с возможностью удаления
            if (selectedImages.isNotEmpty)
              Column(
                children: selectedImages.map((image) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Отображаем изображение
                      Image.memory(image, width: 100, height: 100, fit: BoxFit.cover),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Удаляем изображение из списка
                          setState(() {
                            selectedImages.remove(image);
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),

            SizedBox(height: 10),

            // Кнопка для отправки заявки
            ElevatedButton(
              onPressed: () async {
                var userId = await _getUserId();
                if (userId == null) {
                  return;
                }
                if (selectedImages.isNotEmpty && reasonController.text.isNotEmpty) {
                  // Отправляем заявку
                  await createApplication(userId, reasonController.text, selectedImages);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application Created')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
                }
              },
              child: Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }

  // Функция для получения userId
  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}