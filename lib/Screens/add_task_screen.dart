
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/size_config.dart';
import 'package:todo_app/Data/AppThemeData.dart';
import 'package:todo_app/Widgets/show_dialog_window.dart';
import '../Data/TaskData.dart';
import '../Widgets/back_to_prev_screen_button.dart';
import '../Widgets/custom_text_field.dart';

// ignore: must_be_immutable
class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BackToPrevScreenButton(appThemeData.selectedTheme.textColor, buttonSize: 50 * sizeConfig.safeBlockSmallest),
                            Text(
                                "Add Task",
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
                                if(taskData.taskName.isNotEmpty) {
                                  taskData.addTask();
                                }
                                taskData.taskName = "";
                                taskData.taskDescription = "";
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
      padding: EdgeInsetsDirectional.only(
          start: 32 * sizeConfig.safeBlockSmallest,
          end: 32 * sizeConfig.safeBlockSmallest,
          bottom: 16 * sizeConfig.safeBlockSmallest,
          top: 16 * sizeConfig.safeBlockSmallest),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Selected Task Icon: ",
                style: TextStyle(
                  color: appThemeData.selectedTheme.textColor,
                  fontSize: 64 * sizeConfig.safeBlockSmallest,
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
                      taskData.setTaskIcon(icon);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appThemeData.selectedTheme.primaryDarkColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20 * sizeConfig.safeBlockSmallest)),
                    fixedSize: Size(200 * sizeConfig.safeBlockSmallest, 150 * sizeConfig.safeBlockSmallest)
                  ),
                  child: Icon(
                    taskData.taskIcon,
                    color: appThemeData.selectedTheme.textColor,
                    size: 75 * sizeConfig.safeBlockSmallest,
                    shadows: [
                      Shadow(blurRadius: 2, color: appThemeData.selectedTheme.textDarkColor.withAlpha(128), offset: const Offset(2, 2))
                    ]
                  )
              ),
            ],
          ),
          SizedBox(height: 20 * sizeConfig.safeBlockSmallest),
          _endDateWidget(taskData, appThemeData, sizeConfig, context),
          SizedBox(height: 20 * sizeConfig.safeBlockSmallest),
          _endTimeWidget(taskData, appThemeData, sizeConfig, context),
          SizedBox(height: 20 * sizeConfig.safeBlockSmallest),
          CustomTextField(sizeConfig, appThemeData, hintText: "Task Name", maxLength: 45, onChanged: (value){ taskData.taskName = value;}),
          SizedBox(height: 20 * sizeConfig.safeBlockSmallest),
          CustomTextField(sizeConfig, appThemeData,
              hintText: "Description", keyboardType: TextInputType.multiline,
              onChanged: (value){ taskData.taskDescription = value;}
          ),
        ],
      ),
    );
  }
  Widget _endDateWidget(TaskData taskData, AppThemeData appThemeData, SizeConfig sizeConfig, BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WidgetStateUpdater(),
      child: Consumer<WidgetStateUpdater>(
        builder: (context, widgetStateUpdater, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "End Date: ${DateFormat("dd/MM/yyyy").format(taskData.selectedDate)}",
                  style: TextStyle(
                    color: appThemeData.selectedTheme.textColor,
                    fontSize: 64 * sizeConfig.safeBlockSmallest,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      DateTime currentDate = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
                      DateTime? date = await showDatePicker(context: context, initialDate: currentDate, firstDate: DateTime(currentDate.year), lastDate: DateTime(2050));
                      if(date != null) {
                        if(date.difference(currentDate) < const Duration()){
                          date = currentDate;
                          // ignore: use_build_context_synchronously
                          showCustomDialog("Warning", "Task end date must be in future or today.", context, appThemeData.selectedTheme, blockSmallest: sizeConfig.safeBlockSmallest);
                        }else{
                          taskData.setTaskEndDate(date);
                        }
                      }
                      widgetStateUpdater.update();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: appThemeData.selectedTheme.primaryDarkColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20 * sizeConfig.safeBlockSmallest)),
                        fixedSize: Size(200 * sizeConfig.safeBlockSmallest, 150 * sizeConfig.safeBlockSmallest)
                    ),
                    child: Icon(
                        FontAwesomeIcons.clock,
                        color: appThemeData.selectedTheme.textColor,
                        size: 75 * sizeConfig.safeBlockSmallest,
                        shadows: [
                          Shadow(blurRadius: 2, color: appThemeData.selectedTheme.textDarkColor.withAlpha(128), offset: const Offset(2, 2))
                        ]
                    )
                ),
              ],
            ),
      ),
    );
  }

  Widget _endTimeWidget(TaskData taskData, AppThemeData appThemeData, SizeConfig sizeConfig, BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WidgetStateUpdater(),
      child: Consumer<WidgetStateUpdater>(
        builder: (context, widgetStateUpdater, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "End Time: ${DateFormat(DateFormat.HOUR_MINUTE).format(taskData.selectedDate)}",
                  style: TextStyle(
                    color: appThemeData.selectedTheme.textColor,
                    fontSize: 64 * sizeConfig.safeBlockSmallest,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      var timeNow = TimeOfDay.now();
                      TimeOfDay? time = await showTimePicker(context: context, initialTime: timeNow);
                      if(time != null) {
                        var date = taskData.selectedDate.copyWith(hour: timeNow.hour, minute: timeNow.minute);
                        var pickedDate = date.copyWith(hour: time.hour, minute: time.minute);
                        print(pickedDate.difference(date));
                        if(pickedDate.difference(date) < const Duration()){
                          // ignore: use_build_context_synchronously
                          showCustomDialog("Warning", "Time must be in future.", context, appThemeData.selectedTheme, blockSmallest: sizeConfig.safeBlockSmallest);
                        }else{
                          taskData.setTaskEndTime(pickedDate);
                        }
                      }
                      widgetStateUpdater.update();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: appThemeData.selectedTheme.primaryDarkColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20 * sizeConfig.safeBlockSmallest)),
                        fixedSize: Size(200 * sizeConfig.safeBlockSmallest, 150 * sizeConfig.safeBlockSmallest)
                    ),
                    child: Icon(
                        FontAwesomeIcons.clock,
                        color: appThemeData.selectedTheme.textColor,
                        size: 75 * sizeConfig.safeBlockSmallest,
                        shadows: [
                          Shadow(blurRadius: 2, color: appThemeData.selectedTheme.textDarkColor.withAlpha(128), offset: const Offset(2, 2))
                        ]
                    )
                ),
              ],
            ),
      ),
    );
  }


}

class WidgetStateUpdater extends ChangeNotifier{
  void update(){
    notifyListeners();
  }
}