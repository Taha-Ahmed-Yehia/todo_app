import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/app_theme_data.dart';
import 'package:todo_app/Data/task_data.dart';
import 'package:todo_app/Screens/add_item_screen.dart';

import '../Data/size_config.dart';
import '../Models/task_model.dart';
import '../Widgets/back_to_prev_screen_button.dart';
import '../Widgets/task_items.dart';
import '../Widgets/task_present_indicator.dart';

class TaskScreen extends StatelessWidget {
  final Task task;

  const TaskScreen(this.task,{
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);
    var paddingSize =  20 * sizeConfig.blockSizeHorizontal;

    return Consumer2<AppThemeData, TaskData>(
      builder: (context, appThemeData, taskData, child) {
        return Hero(
          tag: task.id,
          child: SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(paddingSize),
                    color: appThemeData.selectedTheme.secondaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _topBar(appThemeData, context, taskData, sizeConfig),
                        Padding(
                            padding: EdgeInsetsDirectional.only(start: paddingSize, end: paddingSize),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(task.taskIcon, size: 100 * sizeConfig.safeBlockSmallest, color:appThemeData.selectedTheme.primaryDarkColor),
                                    SizedBox(width: 50 * sizeConfig.safeBlockSmallest,),
                                    Flexible(
                                      child: RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(text: task.taskName, style: TextStyle(
                                        color: appThemeData.selectedTheme.textDarkColor,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 64 * sizeConfig.safeBlockSmallest
                                        )),
                                      ),
                                    ),
                                    SizedBox(width: 150 * sizeConfig.safeBlockSmallest),
                                  ],
                                ),
                                Text(task.items.length > 1 ? " ${task.items.length} Items" : " ${task.items.length} Item",
                                  style: TextStyle(color: appThemeData.selectedTheme.textDarkColor.withAlpha(200), fontSize: 32 * sizeConfig.safeBlockSmallest)
                                ),
                              ],
                            )
                        ),
                        SizedBox(height: 10 * sizeConfig.safeBlockSmallest),
                        TaskPercentIndicator(appThemeData.selectedTheme, sizeConfig, task.progress()),
                        SizedBox(height: 10 * sizeConfig.safeBlockSmallest),
                        Expanded(child: TaskItems(task)),
                      ],
                    ),

                  ),
                  Positioned(
                    width: sizeConfig.screenWidth,
                    bottom: 20 * sizeConfig.safeBlockSmallest,
                    child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 150) * sizeConfig.safeBlockSmallest,
                            shape: const PolygonBorder(sides: 6),
                            backgroundColor: appThemeData.selectedTheme.primaryDarkColor,
                            elevation: 6,
                          ),
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddItemScreen(task)));
                          },
                          child: Icon(Icons.add, color: appThemeData.selectedTheme.textColor, size: 100 * sizeConfig.blockSmallest,)
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _topBar(AppThemeData appThemeData, BuildContext context, TaskData taskData, SizeConfig sizeConfig) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BackToPrevScreenButton(appThemeData.selectedTheme.textDarkColor, buttonSize: 50 * sizeConfig.safeBlockSmallest),
       _popMenu(context, appThemeData, taskData, sizeConfig)
      ],
    );
  }
  Widget _popMenu(context, AppThemeData appThemeData, TaskData taskData, SizeConfig sizeConfig){
    return PopupMenuButton(
      tooltip: "More",
      icon: Icon(Icons.more_vert_rounded, color: appThemeData.selectedTheme.textDarkColor, size: 50 * sizeConfig.safeBlockSmallest,),
      color:  appThemeData.selectedTheme.secondaryColor,
      itemBuilder: (context)=> [
        PopupMenuItem(
            value: 0,
            child: Text("Mark All Done", style: TextStyle(color: appThemeData.selectedTheme.textDarkColor))
        ),
        PopupMenuItem(
          value: 1,
          child: Text("Delete All", style: TextStyle(color: appThemeData.selectedTheme.primaryDarkColor)),
        )
      ],
      onSelected: (value){
        switch(value){
          case 0:
            taskData.markAllDone(task);
            break;
          case 1:
            taskData.deleteAllItems(task);
            break;
        }
      },
    );
  }
}