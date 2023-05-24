
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/AppThemeData.dart';
import 'package:todo_app/Data/TaskData.dart';
import '../Data/size_config.dart';
import '../Models/Task.dart';
import '../Widgets/back_to_prev_screen_button.dart';
import '../Widgets/custom_text_field.dart';
//TODO: convert to overlay widget card
// ignore: must_be_immutable
class AddItemScreen extends StatelessWidget {
  final Task task;
  const AddItemScreen(this.task, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String itemTitle = "";
    var sizeConfig = SizeConfig(context);
    return Hero(
      tag: task.id,
      child: SafeArea(
        child: Scaffold(
          body:  Consumer2<AppThemeData, TaskData>(
              builder: (context, appThemeData, taskData, child){
                return Container(
                  color: appThemeData.selectedTheme.primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackToPrevScreenButton(appThemeData.selectedTheme.textColor, buttonSize: 50 * sizeConfig.safeBlockSmallest),
                          Text(
                              "Add Item",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 50 * sizeConfig.safeBlockSmallest, fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                        blurRadius: 2,
                                        color: appThemeData.selectedTheme.textDarkColor.withAlpha(128),
                                        offset: Offset(2, 2)
                                    )
                                  ]
                              )
                          ),
                          SizedBox(width: 50 * sizeConfig.safeBlockSmallest,)
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            CustomTextField(sizeConfig, appThemeData, hintText: "Item Name", maxLength: 45, onChanged: (value) { itemTitle = value; }),
                            const SizedBox(height: 20),
                            Container(
                              width: sizeConfig.screenWidth,
                              padding: EdgeInsetsDirectional.all(50 * sizeConfig.safeBlockSmallest),
                              child: ElevatedButton(
                                onPressed: (){
                                  if(itemTitle.isNotEmpty) {
                                    taskData.addItemToTask(task, itemTitle!);
                                  }
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: appThemeData.selectedTheme.primaryDarkColor,
                                    elevation: 1
                                ),
                                child: Text(
                                  "Add",
                                  style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 32 * sizeConfig.safeBlockSmallest)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}