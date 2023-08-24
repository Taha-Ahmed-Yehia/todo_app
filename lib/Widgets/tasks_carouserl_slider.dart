
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/size_config.dart';
import 'package:todo_app/Widgets/task_card.dart';

import '../Data/app_theme_data.dart';
import '../Data/task_data.dart';

class TasksCarouselSlider extends StatelessWidget {
  const TasksCarouselSlider({
    Key? key,
  }) : super(key: key);

  static final List<String> _notasksTextList = [
    "No available tasks.",
    "No tasks has been found.",
    "No available tasks today.",
    "No available tasks.\nWhy you don't create a new one?!",
    "No available tasks but hey.\nWhy you don't create a new one?!"
  ];

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);

    return Consumer2<AppThemeData, TaskData>(
      builder: (context, appThemeData, taskData, child) {
        if(taskData.tasksCount == 0) {
          var randomIndex = 1 + Random().nextInt(_notasksTextList.length-1);
          return Center(
            child: Text(
              _notasksTextList[randomIndex], 
              style: TextStyle(
                color: appThemeData.selectedTheme.textColor, 
                fontSize: 72 * sizeConfig.safeBlockSmallest, 
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            )
          );
        }
        
        if(taskData.tasks.isEmpty) {
          var randomIndex = Random().nextInt(2);
          return Center(
            child: Text(
              _notasksTextList[randomIndex], 
              style: TextStyle(
                color: appThemeData.selectedTheme.textColor,
                fontSize: 72 * sizeConfig.safeBlockSmallest,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            )
          );
        }

        return CarouselSlider(
          items: taskData.tasks.map((task) => TaskCard(task, appThemeData, (){taskData.removeTask(task);})).toList(),
          options: CarouselOptions(
            autoPlay: false,
            pageSnapping: true,
            enableInfiniteScroll: false,
            height: 1080 * sizeConfig.autoScale.height
          ),
        );
      },
    );
  }
}