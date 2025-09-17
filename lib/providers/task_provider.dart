import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  static const _storageKey = 'tasks_v1';
  final SharedPreferences prefs;
  List<Task> _tasks = [];

  // filter: "all", "completed", "pending"
  String filter = 'all';
  bool sortByDueDateAsc = true;

  TaskProvider(this.prefs) {
    _loadFromPrefs();
  }

  List<Task> get tasks {
    var list = [..._tasks];
    if (filter == 'completed') list = list.where((t) => t.isCompleted).toList();
    if (filter == 'pending') list = list.where((t) => !t.isCompleted).toList();
    list.sort((a, b) => sortByDueDateAsc
        ? a.dueDate.compareTo(b.dueDate)
        : b.dueDate.compareTo(a.dueDate));
    return list;
  }

  // Future<void> _loadFromPrefs() async {
  //   final raw = prefs.getString(_storageKey);

  //   if (raw == null) {
  //     await _saveToPrefs();
  //     notifyListeners();
  //     return;
  //   }

  //   final List parsed = jsonDecode(raw);
  //   _tasks = parsed.map((e) => Task.fromJson(e)).toList().cast<Task>();
  //   notifyListeners();
  // }

  Future<void> _loadFromPrefs() async {
    final raw = prefs.getString(_storageKey);
    print("raw data: ${raw?.length}");

    // Load tasks from SharedPreferences if they exist
    if (raw != null) {
      final List parsed = jsonDecode(raw);
      _tasks = parsed.map((e) => Task.fromJson(e)).toList().cast<Task>();
    }

    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final raw = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> restoreTask(Task task) async {
    _tasks.add(task);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> toggleComplete(String taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        isCompleted: !_tasks[taskIndex].isCompleted,
      );
      await _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> updateTask(String taskId, Task updatedTask) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = updatedTask;
      await _saveToPrefs();
      notifyListeners();
    }
  }

  void toggleSortOrder() {
    sortByDueDateAsc = !sortByDueDateAsc;
    notifyListeners();
  }

  void setFilter(String newFilter) {
    filter = newFilter;
    notifyListeners();
  }
}
