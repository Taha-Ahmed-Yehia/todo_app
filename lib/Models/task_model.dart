
import 'dart:convert';
import 'package:flutter/material.dart';
import 'item_model.dart';

class Task {
  String taskName;
  IconData taskIcon;
  String taskDescription;
  DateTime endDate;
  int id;
  List<Item> items = [];

  Task(this.taskName, this.taskIcon, this.taskDescription, this.id, this.endDate,{List<Item>? items}) : items = items ?? [];

  factory Task.fromJson(Map<String,dynamic> json) => Task(
      json['taskHeader'],
      IconData(json['codePoint'],fontFamily: json['fontFamily'], fontPackage: json['fontPackage'], matchTextDirection: json['matchTextDirection']),
      json['taskDescription'],
      json['id'],
      DateTime.parse(json['endDate']),
      items: json['items'] == null ? [] : List<Item>.from(jsonDecode(json['items']).map((model)=> Item.fromJson(model)))
  );

  Map<String,dynamic> toJson() => {
    "taskHeader":taskName,
    'codePoint':taskIcon.codePoint,
    'fontFamily':taskIcon.fontFamily,
    'fontPackage':taskIcon.fontPackage,
    'matchTextDirection':taskIcon.matchTextDirection,
    "taskDescription":taskDescription,
    "id":id,
    "endDate":endDate.toString(),
    "items": jsonEncode(items),
  };

  void addItem(String itemTitle){
    items.add(Item(itemTitle));
  }
  void removeItem(Item item){
    items.remove(item);
  }
  void updateItem(Item item){
    item.doneChange();
  }

  double progress() {
    if(items.isNotEmpty){
      double doneCount = 0;
      for(var item in items){
        if(item.isDone){
          doneCount++;
        }
      }
      return doneCount/items.length;
    }
    return 0;
  }

  void markAllDone() {
    for(var item in items){ item.isDone = true; }
  }

  void deleteAllItems() {
    items = [];
  }

}