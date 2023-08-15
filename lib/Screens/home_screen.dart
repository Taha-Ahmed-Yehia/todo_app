
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/app_theme_data.dart';
import 'package:todo_app/Models/drawer_animation_notifier.dart';

import '../Data/size_config.dart';
import '../Data/task_data.dart';
import '../Widgets/custom_search_bar.dart';
import '../Widgets/tasks_carouserl_slider.dart';
import 'add_task_screen.dart';
import 'drawer_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final double bigFontSize = 48;
  final TextStyle boldTextStyle = TextStyle(fontWeight: FontWeight.bold);
  final TextStyle normalTextStyle = TextStyle(fontWeight: FontWeight.normal);
  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);

    var size = Size(sizeConfig.screenWidth, sizeConfig.screenHeight);
    if (kDebugMode) {
      print(size);
    }

    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => DrawerAnimation(),
        child: Consumer3<TaskData, AppThemeData, DrawerAnimation>(
        builder: (context, taskData, appThemeData, drawerAnimation, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: appThemeData.selectedTheme.primaryLightColor,
            body: ZoomDrawer(
              mainScreen: homeScreen(context, taskData, appThemeData, sizeConfig, drawerAnimation),
              menuScreen: DrawerScreen(),
              borderRadius: 50 * sizeConfig.safeBlockSmallest,
              showShadow: true,
              angle: -5,
              controller: drawerAnimation.zoomDrawerController,
              drawerShadowsBackgroundColor: appThemeData.selectedTheme.primaryColor,
              menuScreenTapClose: true,
              mainScreenTapClose: true,
              slideWidth: 720 * sizeConfig.safeBlockSmallest,
            ),
          );
          }
        ),
      ),
    );
  }

  Widget homeScreen(BuildContext context, TaskData taskData, AppThemeData appThemeData, SizeConfig sizeConfig, DrawerAnimation drawerAnimation){
    return Container(
      color: appThemeData.selectedTheme.primaryColor,
      child: Stack(
        children: [
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20) * sizeConfig.safeBlockSmallest,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: (){
                        drawerAnimation.toggleDrawer();
                      },
                      icon: Icon(Icons.menu, size: 72 * sizeConfig.safeBlockSmallest, color: appThemeData.selectedTheme.textColor),
                      iconSize: 72 * sizeConfig.safeBlockSmallest,
                    ),
                    SizedBox(width: 50 * sizeConfig.safeBlockSmallest),
                    CustomSearchBar(sizeConfig: sizeConfig, appThemeData: appThemeData, onTextFieldChange: (value){taskData.search(value);}),
                  ],
                )
            ),
            // date and tasks count info
            Padding(
                padding: EdgeInsetsDirectional.only(start: 20 * sizeConfig.safeBlockSmallest, end: 20 * sizeConfig.safeBlockSmallest),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _dateWidget(sizeConfig, appThemeData),
                    SizedBox(width: 10 * sizeConfig.safeBlockSmallest),
                    Expanded(
                        child: Container(
                          height: 185 * sizeConfig.safeBlockSmallest,
                          alignment: FractionalOffset.center,
                          decoration: BoxDecoration(
                              color: appThemeData.selectedTheme.primaryLightColor,
                              borderRadius: BorderRadius.circular(25 * sizeConfig.safeBlockSmallest),
                              boxShadow: [
                                BoxShadow(
                                  color: appThemeData.selectedTheme.primaryDarkColor.withAlpha(128),
                                  offset: Offset(0,2),
                                  blurRadius: 4,
                                )
                              ]
                          ),
                          padding: EdgeInsets.all(20.0 * sizeConfig.safeBlockSmallest),
                          child: Text("You have ${taskData.tasksCount} task${taskData.tasksCount > 1? "s" : ""} to complete",
                              style: normalTextStyle.copyWith(color: appThemeData.selectedTheme.textDarkColor.withAlpha(160), fontSize: 48 * sizeConfig.blockSmallest)),
                        )
                    )
                  ],
                )
            ),
            SizedBox(height: 10 * sizeConfig.safeBlockSmallest),
            // tasks cards
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50 * sizeConfig.safeBlockSmallest),
                  child: Center(child: TasksCarouselSlider()),
                )
            )
          ],
        ),
          Positioned(
            width: sizeConfig.screenWidth,
            bottom: 20 * sizeConfig.safeBlockSmallest,
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 150) * sizeConfig.safeBlockSmallest,
                  shape: const PolygonBorder(sides: 6),
                  backgroundColor: appThemeData.selectedTheme.primaryDarkColor,
                  elevation: 6,
                ),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTaskScreen()));
                },
                child: Icon(Icons.add, color: appThemeData.selectedTheme.textColor, size: 100 * sizeConfig.blockSmallest,)
            ),
            ),
          )
        ],
      )
    );
  }

  Widget _dateWidget(SizeConfig sizeConfig, AppThemeData appThemeData){
    var date = DateTime.now();
    var dayName = DateFormat('EEEE').format(date);
    var monthName = DateFormat('MMM').format(date);
    var dayNumber = date.day;

    return Container(
      height: 185 * sizeConfig.blockSmallest,
      decoration: BoxDecoration(
        color: appThemeData.selectedTheme.primaryLightColor,
        borderRadius: BorderRadius.circular(25 * sizeConfig.blockSmallest),
        boxShadow: [
          BoxShadow(
            color: appThemeData.selectedTheme.primaryDarkColor.withAlpha(128),
            offset: Offset(0,2),
            blurRadius: 4,
          )
        ]
      ),
      alignment: FractionalOffset.center,
      padding: EdgeInsets.all(20 * sizeConfig.safeBlockSmallest),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayName,
            style: boldTextStyle.copyWith(color: appThemeData.selectedTheme.textDarkColor.withAlpha(128), fontSize: 50 * sizeConfig.safeBlockSmallest)
          ),
          Row(
            children: [
              Text(
                "$dayNumber ",
                style: boldTextStyle.copyWith(color: appThemeData.selectedTheme.textDarkColor, fontSize: 50 * sizeConfig.safeBlockSmallest)
              ),
              Text(
                monthName,
                style: boldTextStyle.copyWith(color: appThemeData.selectedTheme.textDarkColor.withAlpha(128), fontSize: 50 * sizeConfig.safeBlockSmallest)
              ),
            ],
          )
        ],
      ),
    );
  }
}