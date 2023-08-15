
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/size_config.dart';
import 'package:todo_app/Data/app_theme_data.dart';
import '../Models/task_model.dart';
import '../Data/task_data.dart';
import '../Widgets/back_to_prev_screen_button.dart';
import '../Widgets/custom_text_field.dart';

class EditTaskScreen extends StatelessWidget {
  final Task task;
  const EditTaskScreen(this.task, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);
    return Consumer2<AppThemeData, TaskData>(
        builder: (context, appThemeData, taskData, child){
          return SafeArea(
            child: Scaffold(
              backgroundColor: appThemeData.selectedTheme.primaryColor,
              body: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackToPrevScreenButton(appThemeData.selectedTheme.textColor, buttonSize: 50 * sizeConfig.safeBlockSmallest),
                          Text(
                            "Edit Task",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 50 * sizeConfig.blockSmallest, fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  color: appThemeData.selectedTheme.textDarkColor.withAlpha(128),
                                  offset: Offset(2, 2)
                                )
                              ]
                            )
                          ),
                          SizedBox(width: 50 * sizeConfig.blockSizeHorizontal,)
                        ],
                      ),
                      _bottomScreen(appThemeData, taskData, context, sizeConfig),
                    ],
                  ),
                  Positioned(
                    width: sizeConfig.screenWidth,
                    bottom: 20 * sizeConfig.safeBlockSmallest,
                    child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Container(
                        width: sizeConfig.screenWidth,
                        padding: EdgeInsetsDirectional.all(50 * sizeConfig.blockSmallest),
                        child: ElevatedButton(
                          onPressed: (){
                            if(task.taskName.isNotEmpty) {
                              taskData.updateTask(task, task.id);
                            }
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: appThemeData.selectedTheme.primaryDarkColor,
                              elevation: 1
                          ),
                          child: Text(
                              "Done",
                              style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 40 * sizeConfig.blockSmallest)
                          ),
                        ),
                      )
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  Widget _bottomScreen(AppThemeData appThemeData, TaskData taskData, BuildContext context, SizeConfig sizeConfig) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 32 * sizeConfig.safeBlockSmallest, end: 32 * sizeConfig.safeBlockSmallest, bottom: 16 * sizeConfig.safeBlockSmallest, top: 16 * sizeConfig.safeBlockSmallest),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Task Icon: ",
                style: TextStyle(
                    color: appThemeData.selectedTheme.textColor,
                    fontSize: 32 * sizeConfig.safeBlockSmallest,
                    shadows: [
                      Shadow(
                          blurRadius: 2,
                          color: appThemeData.selectedTheme.textDarkColor.withAlpha(128),
                          offset: Offset(2, 2)
                      )
                    ]
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    IconData? icon = await FlutterIconPicker.showIconPicker(
                        context,
                        iconPackModes: [
                          IconPack.fontAwesomeIcons,
                          IconPack.cupertino,
                          IconPack.lineAwesomeIcons,
                          IconPack.material
                        ]
                    );
                    if(icon != null) {
                      task.taskIcon = icon;
                      taskData.refresh();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: appThemeData.selectedTheme.primaryDarkColor,
                      elevation: 1
                  ),
                  child: Icon(
                      task.taskIcon,
                      color: appThemeData.selectedTheme.textColor,
                      shadows: [
                        Shadow(blurRadius: 2, color: appThemeData.selectedTheme.textDarkColor.withAlpha(128), offset: Offset(2, 2))
                      ]
                  )
              ),
            ],
          ),
          SizedBox(height: 20 * sizeConfig.safeBlockSmallest),
          CustomTextField(sizeConfig, appThemeData,
              hintText: "Task Name", maxLength: 45,
              onChanged: (value){ task.taskName = value;}, text: task.taskName
          ),
          SizedBox(height: 20 * sizeConfig.safeBlockSmallest),
          CustomTextField(sizeConfig, appThemeData,
            hintText: "Description", keyboardType: TextInputType.multiline,
            onChanged: (value){ task.taskDescription = value;},
            text: task.taskDescription,
          ),
        ],
      ),
    );
  }


}
