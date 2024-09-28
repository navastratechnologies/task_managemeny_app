import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/services/local_database_service.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  final LocalDatabaseService _localDatabaseService = LocalDatabaseService();

  String apiUrl = 'https://primewayplus.com/api';

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _tasks = await _localDatabaseService.fetchTasks();
    } else {
      final response = await http.get(Uri.parse('$apiUrl/get_tasks.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _tasks = data.map((json) => Task.fromJson(json)).toList();
        for (var task in _tasks) {
          await _localDatabaseService.insertTask(task);
        }
      } else {
        throw Exception('Failed to load tasks');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await _localDatabaseService.insertTask(task);
    } else {
      final response = await http.post(
        Uri.parse('$apiUrl/add_task.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(task.toJson()),
      );
      log('task add ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Task newTask = Task.fromJson(json.decode(response.body));
        await _localDatabaseService.insertTask(newTask);
        _tasks.add(newTask);
      } else {
        throw Exception('Failed to add task');
      }
    }
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await _localDatabaseService.updateTask(task);
    } else {
      final response = await http.put(
        Uri.parse('https://your-api-endpoint.com/tasks/${task.id}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 200) {
        await _localDatabaseService.updateTask(task);
      } else {
        throw Exception('Failed to update task');
      }
    }
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await _localDatabaseService.deleteTask(id);
    } else {
      final response = await http.delete(
        Uri.parse('$apiUrl/delete_task.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"id": id}),
      );

      log('task delete ${response.body}');

      if (response.statusCode == 200) {
        await _localDatabaseService.deleteTask(id);
      } else {
        throw Exception('Failed to delete task: ${response.body}');
      }
    }
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  Future<void> deleteSelectedTasks() async {
    log('tasks $_tasks');
    List<int> selectedTaskIds = _tasks
        .where((task) => task.isSelected)
        .map((task) => task.id)
        .where((id) => id != null)
        .cast<int>()
        .toList();

    for (int id in selectedTaskIds) {
      await deleteTask(id.toString());
      _tasks.removeWhere((task) => task.id == id);
    }

    notifyListeners();
  }
}
