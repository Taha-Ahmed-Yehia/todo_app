
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/size_config.dart';
import 'package:todo_app/Screens/edit_task_screen.dart';
import 'package:todo_app/Widgets/task_present_indicator.dart';

import '../Data/app_theme_data.dart';
import '../Models/task_model.dart';
import '../Data/task_data.dart';
import '../Screens/task_screen.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final AppThemeData appThemeData;
  final Function deleteCard;
  const TaskCard(this.task, this.appThemeData, this.deleteCard, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);
    double paddingSize = 32 * sizeConfig.safeBlockSmallest;

    return Hero(
      tag: task.id,
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: paddingSize, end: paddingSize),
        child: ElevatedButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskScreen(task)));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appThemeData.selectedTheme.secondaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.all(Radius.circular(paddingSize)))
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.all(sizeConfig.safeBlockSmallest),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(task.taskIcon, size: 64 * sizeConfig.safeBlockSmallest, color:appThemeData.selectedTheme.primaryDarkColor),
                  trailing: _popMenu(context),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _taskHeader(paddingSize, sizeConfig),
                      SizedBox(height: 5 * sizeConfig.safeBlockSmallest),
                      TaskPercentIndicator(appThemeData.selectedTheme, sizeConfig, task.progress()),
                      SizedBox(height: 5 * sizeConfig.safeBlockSmallest),
                      _taskDescription(sizeConfig),
                      SizedBox(height: 5 * sizeConfig.safeBlockSmallest),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _taskDescription(SizeConfig sizeConfig) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.only(right: 20.0 * sizeConfig.safeBlockSmallest),
        child: Text(
          task.taskDescription,
          overflow: TextOverflow.ellipsis,
          maxLines: 6,
          style: TextStyle(
            fontSize: 24 * sizeConfig.safeBlockSmallest,
            color: appThemeData.selectedTheme.textDarkColor,
          ),
        ),
      ),
    );
  }

  Widget _taskHeader(double paddingSize, SizeConfig sizeConfig) {
    return Padding(
        padding: EdgeInsetsDirectional.only(start: paddingSize, end: paddingSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              task.taskName,
              style: TextStyle(color: appThemeData.selectedTheme.textDarkColor, fontWeight: FontWeight.bold, fontSize: 50 * sizeConfig.safeBlockSmallest)
            ),
            Text(
                task.items.length > 1 ? "${task.items.length} Items" : "${task.items.length} Item",
                style: TextStyle(color: appThemeData.selectedTheme.textDarkColor.withAlpha(200), fontSize: 24 * sizeConfig.safeBlockSmallest)
            ),
          ],
        )
    );
  }

  Widget _popMenu(context){
    return PopupMenuButton(
      tooltip: "More",
      icon: Icon(Icons.more_vert_rounded, color: appThemeData.selectedTheme.primaryDarkColor,),
      color:  appThemeData.selectedTheme.secondaryColor,
      itemBuilder: (context)=> [
        PopupMenuItem(
            value: 0,
            child: Text("Edit", style: TextStyle(color: appThemeData.selectedTheme.textDarkColor))
        ),
        PopupMenuItem(
            value: 1,
            child: Text("Mark All Done", style: TextStyle(color: appThemeData.selectedTheme.textDarkColor))
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Delete", style: TextStyle(color: appThemeData.selectedTheme.primaryDarkColor)),
        )
      ],
      onSelected: (value) {
        switch(value){
          case 0:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditTaskScreen(task),));
            break;
          case 1:
            Provider.of<TaskData>(context, listen: false).markAllDone(task);
            break;
          case 2:
            deleteCard.call();
        }
      },
    );
  }
}