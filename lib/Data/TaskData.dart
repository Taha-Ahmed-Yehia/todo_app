
import 'dart:convert';

import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Models/Item.dart';
import '../Models/Task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> tasks = [];
  List<Task> _finishedTasks = [];

  int lastId = 0;

  String taskName = "";
  String taskDescription = "";
  IconData taskIcon = Icons.playlist_add_check;
  DateTime selectedDate = DateTime.now();
  int get tasksCount => _tasks.length;

  TaskData() {
    load();
  }

  void load() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var data = sharedPreferences.getString(taskDataSaveKey);
    try{
      if(data != null){
        if(data.isNotEmpty){
          var tasksJson = jsonDecode(data);
          _tasks = List<Task>.from(tasksJson.map((model)=> Task.fromJson(model)));
          lastId = _tasks.length;
          tasks = _tasks;
        }
      }
    }catch(e){
      sharedPreferences.remove(taskDataSaveKey);
    }
  }

  void save() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    var pref = jsonEncode(_tasks);
    sharedPreferences.setString(taskDataSaveKey, pref);
  }

  void addTask(){
    _tasks.add(Task(taskName, taskIcon, taskDescription, lastId, selectedDate));
    tasks = _tasks;
    lastId++;

    taskName = "";
    taskDescription = "";
    taskIcon = Icons.playlist_add_check;
    save();
    notifyListeners();
  }

  void removeTask(Task task){
    _tasks.remove(task);
    tasks = _tasks;
    lastId--;
    save();
    notifyListeners();
  }

  void refresh(){
    save();
    notifyListeners();
  }

  void addItemToTask(Task task, String itemTitle)
  {
    if(_tasks.contains(task)){
      _tasks[_tasks.indexOf(task)].addItem(itemTitle);
    }
    save();
    notifyListeners();
  }

  void removeItemFromTask(Task task, Item item)
  {
    if(_tasks.contains(task)){
      _tasks[_tasks.indexOf(task)].removeItem(item);
    }
    save();
    notifyListeners();
  }

  void markAllDone(Task task) {
    if(_tasks.contains(task)){
      _tasks[_tasks.indexOf(task)].markAllDone();
    }
    tasks = _tasks;
    save();
    notifyListeners();
  }

  void updateItemInTask(Task task, Item item) {
    if(_tasks.contains(task)){
      _tasks[_tasks.indexOf(task)].updateItem(item);
    }
    save();
    notifyListeners();
  }

  void deleteAllItems(Task task) {
    if(_tasks.contains(task)){
      _tasks[_tasks.indexOf(task)].deleteAllItems();
    }
    save();
    notifyListeners();
  }

  void updateTask(Task task, int id) {
    tasks[id] = task;
    save();
    notifyListeners();
  }

  void setTaskIcon(IconData icon) {
    taskIcon = icon;
    notifyListeners();
  }
  void setTaskEndDate(DateTime date) {
    selectedDate = selectedDate.copyWith(day: date.day, month: date.month, year: date.year);
  }
  void setTaskEndTime(DateTime date) {
    selectedDate = selectedDate.copyWith(hour: date.hour, minute: date.minute);
  }

  void search(String value){
    if(value.isEmpty || value == ""){
      tasks = _tasks;
    }
    else{
      tasks = [];
      for(Task task in _tasks){
        if(task.taskName.toLowerCase().contains(value.toLowerCase())){
          tasks.add(task);
        }
      }
    }
    notifyListeners();
  }
}