
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/app_theme_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Data/app_setting_data.dart';
import '../Data/size_config.dart';
import '../Widgets/back_to_prev_screen_button.dart';


class FinishedTasksScreen extends StatelessWidget {
  const FinishedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);

    return Consumer2<AppThemeData, AppSettingData>(
      builder: (context, appThemeData, appSettingData, child) => SafeArea(
        child: Scaffold(
          backgroundColor: appThemeData.selectedTheme.primaryColor,
          body: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackToPrevScreenButton(appThemeData.selectedTheme.textColor, buttonSize: 50 * sizeConfig.safeBlockSmallest),
                  Text(
                      "Finished Tasks",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 50 * sizeConfig.safeBlockSmallest, fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                                blurRadius: 2,
                                color: appThemeData.selectedTheme.textDarkColor.withAlpha(128),
                                offset: const Offset(2, 2)
                            )
                          ]
                      )
                  ),
                  SizedBox(width: 50 * sizeConfig.safeBlockSmallest,)
                ],
              ),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: appThemeData.selectedTheme.secondaryColor,
                        ),
                        width: 10 * sizeConfig.safeBlockSmallest,
                        height: sizeConfig.screenHeight * .865,
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20 * sizeConfig.safeBlockSmallest),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(25 * sizeConfig.safeBlockSmallest),
                              color: appThemeData.selectedTheme.secondaryColor,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 1),
                                  color: appThemeData.selectedTheme.textDarkColor
                                )
                              ]
                            ),
                            width: sizeConfig.screenWidth,
                            padding: EdgeInsetsDirectional.all(10 * sizeConfig.safeBlockSmallest),
                            child: Column(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: IconButton(
                                    onPressed: (){},
                                    icon: Icon(FontAwesomeIcons.circleXmark, size: 64 * sizeConfig.safeBlockSmallest,),
                                    color: appThemeData.selectedTheme.primaryColor
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.only(start: 50 * sizeConfig.safeBlockSmallest, end:  50 * sizeConfig.safeBlockSmallest, top:  10 * sizeConfig.safeBlockSmallest, bottom:  50 * sizeConfig.safeBlockSmallest),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(FontAwesomeIcons.listUl, size: 64 * sizeConfig.safeBlockSmallest, color: appThemeData.selectedTheme.primaryColor,),
                                          SizedBox(width: 32 * sizeConfig.safeBlockSmallest),
                                          Text("Task Name", style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 32 * sizeConfig.safeBlockSmallest),),
                                        ],
                                      ),
                                      Text("0/0", style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 32 * sizeConfig.safeBlockSmallest),),
                                      Text("Task End Date", style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 32 * sizeConfig.safeBlockSmallest),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}