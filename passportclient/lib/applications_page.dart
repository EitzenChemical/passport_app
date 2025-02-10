import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'application.dart';
import 'create_application_page.dart';
import 'get_user_applications.dart';

// Экран для отображения заявок
class ApplicationsPage extends StatefulWidget {
  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  late Future<List<Application>> futureApplications;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  void _loadApplications() {
    setState(() {
      futureApplications = getUserApplications();
    });
  }

  // Преобразование байтового массива в виджет изображения
  Widget _buildPhotoList(List<Uint8List> photos) {
    if (photos.isEmpty) {
      return const Text("No Photos");
    }

    return SizedBox(
      height: 60, // Высота для списка изображений
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Image.memory(
              photos[index],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Applications'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadApplications, // Ручная перезагрузка списка
          ),
        ],
      ),
      body: FutureBuilder<List<Application>>(
        future: futureApplications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No applications found.'));
          }

          List<Application> applications = snapshot.data!;

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              Application application = applications[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  title: Text('Reason: ${application.reason}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${application.status}'),
                      Text(
                        'Submitted: ${application.dateSubmitted?.toLocal()}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      _buildPhotoList(application.documentPhotos), // Список изображений
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Переход на страницу создания заявки и ожидание возврата
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateApplicationPage()),
          );
          _loadApplications(); // Обновляем список заявок после возврата
        },
        child: Icon(Icons.add),
        tooltip: 'Create Application',
      ),
    );
  }
}
