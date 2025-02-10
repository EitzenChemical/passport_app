import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

// Функция для выбора изображения
Future<Uint8List?> pickImage() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    return await image.readAsBytes(); // Получаем байты изображения
  }
  return null;
}