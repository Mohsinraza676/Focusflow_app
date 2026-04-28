import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskService {
  static const String _storageKey = 'focusflow_tasks';

  /// Saves the list of tasks to local storage
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      tasks.map((task) => task.toMap()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  /// Loads the list of tasks from local storage
  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString(_storageKey);
    
    if (tasksJson == null || tasksJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decodedList = json.decode(tasksJson);
      return decodedList.map((item) => Task.fromMap(item)).toList();
    } catch (e) {
      // If data is corrupted, return empty list
      return [];
    }
  }
}
