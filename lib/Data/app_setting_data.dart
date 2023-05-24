
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Constants.dart';
import 'package:todo_app/Enums/timing_task_enum.dart';
import 'package:todo_app/Enums/temperature_unit.dart';

import '../Enums/drawer_widget_type.dart';
import '../Models/user_app_setting.dart';

class AppSettingData extends ChangeNotifier {
  late UserAppSetting userAppSetting;
  bool isLoaded = false;

  AppSettingData(){
    userAppSetting = UserAppSetting.defaultConstructor();
    load();
  }




  void load() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey(appSettingDataSaveKey)){
      var data = sharedPreferences.getString(appSettingDataSaveKey) as String;
      try{
        userAppSetting = UserAppSetting.fromJson(jsonDecode(data));
      }catch(e){
        print(e);
      }
    }
    isLoaded = true;
  }

  void changeTemperatureUnit(TemperatureUnit temperatureUnit){
    userAppSetting.temperatureUnit = temperatureUnit;
    saveData();
  }
  void changeDrawerWidgetType(DrawerWidgetType drawerWidgetType){
    userAppSetting.drawerWidgetType = drawerWidgetType;
    saveData();
  }

  void changeClearFinishedTaskTime(TimingTask time){
    userAppSetting.autoClearFinishedTaskTime = time;
    saveData();
  }

  void saveData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var data = jsonEncode(userAppSetting);
    sharedPreferences.setString(appSettingDataSaveKey, data);
    notifyListeners();
  }
}