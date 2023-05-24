
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/size_config.dart';
import 'package:todo_app/Widgets/task_card.dart';

import '../Data/AppThemeData.dart';
import '../Data/TaskData.dart';

class TasksCarouselSlider extends StatelessWidget {
  const TasksCarouselSlider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);

    return Consumer2<AppThemeData, TaskData>(
      builder: (context, appThemeData, taskData, child) => CarouselSlider(
        items: taskData.tasks.map((task) => TaskCard(task, appThemeData, (){taskData.removeTask(task);})).toList(),
        options: CarouselOptions(
          autoPlay: false,
          pageSnapping: true,
          enableInfiniteScroll: false,
          height: 1080 * sizeConfig.autoScale.height

        ),
      ),
    );
  }
}