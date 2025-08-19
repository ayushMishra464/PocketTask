import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_model.dart';

class TaskLocalDataSource {
  static const key = 'pocket_tasks_v1';

  Future<List<TaskModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];
    final List decoded = json.decode(jsonString);
    return decoded.map((item) => TaskModel.fromJson(item)).toList();
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(key, jsonString);
  }
}
