import 'package:flutter/material.dart';
import 'package:passport_app/applications_page.dart';
import 'create_application_page.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passport Service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/applications': (context) => ApplicationsPage(),
        '/create-application': (context) => CreateApplicationPage(),
      },
    );
  }
}