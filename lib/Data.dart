import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class taskdata{
  static List<Map<String, dynamic>> tasks = [];

  static Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(taskdata.tasks));
  }

}