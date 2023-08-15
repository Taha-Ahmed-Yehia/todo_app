import 'package:flutter/foundation.dart';

import '../Enums/drawer_widget_type.dart';
import '../Enums/temperature_unit.dart';
import '../Enums/timing_task_enum.dart';

class UserAppSetting {
  //drawer widget type
  DrawerWidgetType drawerWidgetType = DrawerWidgetType.animated_Widget;
  //drawer widget weather settings
  TemperatureUnit temperatureUnit = TemperatureUnit.celsius;
  //user settings
  TimingTask autoClearFinishedTaskTime = TimingTask.never;
  DateTime autoClearFinishedTaskLastDate = DateTime.now();

  UserAppSetting.defaultConstructor();
  UserAppSetting(this.temperatureUnit, this.drawerWidgetType, this.autoClearFinishedTaskTime, this.autoClearFinishedTaskLastDate);

  factory UserAppSetting.fromJson(Map<String, dynamic> json){
    if (kDebugMode) {
      print(DateTime.parse(json["autoClearFinishedTaskLastDate"]));
    }
    return UserAppSetting(
        TemperatureUnit.values[json["temperatureUnit"]],
        DrawerWidgetType.values[(json["drawerWidgetType"])],
        TimingTask.values[json["autoClearFinishedTaskTime"]],
        DateTime.parse(json["autoClearFinishedTaskLastDate"])
    );
  }
  Map<String,dynamic> toJson()=>{
    'temperatureUnit':(temperatureUnit.index),
    'drawerWidgetType':(drawerWidgetType.index),
    'autoClearFinishedTaskTime':(autoClearFinishedTaskTime.index),
    'autoClearFinishedTaskLastDate':autoClearFinishedTaskLastDate.toString()
  };

}