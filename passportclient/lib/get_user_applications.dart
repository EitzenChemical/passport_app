import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'application.dart';

Future<List<Application>> getUserApplications() async {
  var userId = await _getUserId();
  if (userId == null) {
    return [];
  }
  final url = Uri.parse('http://62.60.234.81:2004/Passport/User/$userId');

  final response = await http.get(url, headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Application> result = data.map((item) => Application.fromJson(item)).toList();
    return result;
  } else {
    print('Failed to load applications');
    return [];
  }
}

Future<int?> _getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId');
}