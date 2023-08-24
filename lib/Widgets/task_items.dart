
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/app_theme_data.dart';
import '../Models/task_model.dart';
import '../Data/task_data.dart';
import 'item_tile.dart';

class TaskItems extends StatelessWidget {
  final Task task;
  const TaskItems(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppThemeData, TaskData>(builder: (context, appThemeData, taskData, child){
      return ListView.builder(
          itemCount: task.items.length,
          itemBuilder: (context, index){
            return ItemTile(
              taskTitle: task.items[index].name,
              isChecked: task.items[index].isDone,
              checkboxChange: (bool? value){ taskData.updateItemInTask(task, task.items[index]); },
              deleteChange:  (){ taskData.removeItemFromTask(task, task.items[index]); },
              theme: appThemeData.selectedTheme,
            );
          }
      );
    });
  }
}