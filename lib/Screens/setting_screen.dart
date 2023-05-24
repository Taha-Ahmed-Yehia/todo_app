
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/AppThemeData.dart';
import 'package:todo_app/Data/network_image_data.dart';
import 'package:todo_app/Data/weather_data.dart';
import 'package:todo_app/Extensions/enum_toString.dart';
import 'package:todo_app/Widgets/custom_drop_down.dart';

import '../Data/app_setting_data.dart';
import '../Data/size_config.dart';
import '../Enums/drawer_widget_type.dart';
import '../Enums/hourly_durations_enum.dart';
import '../Enums/temperature_unit.dart';
import '../Enums/timing_task_enum.dart';
import '../Widgets/back_to_prev_screen_button.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

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
                      "Settings",
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
              Padding(
                padding: EdgeInsets.all(20 * sizeConfig.safeBlockSmallest),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      userSettingsWidget(appThemeData, appSettingData, sizeConfig.safeBlockSmallest),
                      SizedBox(height: 20 * sizeConfig.safeBlockSmallest),
                      drawerWidgetType(context, appThemeData, appSettingData, sizeConfig),
                      SizedBox(height: 20 * sizeConfig.safeBlockSmallest),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget drawerWidgetType(BuildContext context,AppThemeData appThemeData, AppSettingData appSettingData, SizeConfig sizeConfig){
    switch (appSettingData.userAppSetting.drawerWidgetType){
      case DrawerWidgetType.network_Image:
        return networkImageSettingsWidget(context, appThemeData, appSettingData, sizeConfig);
      case DrawerWidgetType.weather_Widget:
        return weatherSettingsWidget(appThemeData, appSettingData, sizeConfig);
    }
    return const SizedBox();
  }
  Widget weatherSettingsWidget(AppThemeData appThemeData, AppSettingData appSettingData, SizeConfig sizeConfig) {
    return Container(
      decoration: BoxDecoration(
        color: appThemeData.selectedTheme.primaryDarkColor,
        borderRadius: BorderRadius.circular(20 * sizeConfig.safeBlockSmallest)
      ),
      padding: EdgeInsets.all(20 * sizeConfig.safeBlockSmallest),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Weather",
            style: TextStyle(
              color: appThemeData.selectedTheme.textColor,
              fontSize: 32 * sizeConfig.safeBlockSmallest
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20 * sizeConfig.safeBlockSmallest),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              divider(appThemeData, sizeConfig.safeBlockSmallest),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Temperature Unit",
                    style: TextStyle(
                      color: appThemeData.selectedTheme.textColor,
                      fontSize: 24 * sizeConfig.safeBlockSmallest
                    ),
                    textAlign: TextAlign.center,
                  ),
                  CustomDropDown(
                    [
                      CustomDropDownItem(TemperatureUnit.celsius.name, (){appSettingData.changeTemperatureUnit(TemperatureUnit.celsius);}),
                      CustomDropDownItem(TemperatureUnit.fahrenheit.name, (){appSettingData.changeTemperatureUnit(TemperatureUnit.fahrenheit);})
                    ],
                    selectedItemID: appSettingData.userAppSetting.temperatureUnit.index,
                  )
                ],
              ),
              divider(appThemeData, sizeConfig.safeBlockSmallest),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appThemeData.selectedTheme.primaryLightColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10 * sizeConfig.safeBlockSmallest))
                ),
                onPressed: (){
                  WeatherData.instance.clearCash();
                },
                child: Text(
                  "Clear Weather Cash",
                  style: TextStyle(
                      color: appThemeData.selectedTheme.textColor,
                      fontSize: 24 * sizeConfig.safeBlockSmallest
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget networkImageSettingsWidget(BuildContext context,AppThemeData appThemeData, AppSettingData appSettingData, SizeConfig sizeConfig) {
    return ChangeNotifierProvider(
      create: (context) => NetworkImageData(),
      child: Container(
        decoration: BoxDecoration(
            color: appThemeData.selectedTheme.primaryDarkColor,
            borderRadius: BorderRadius.circular(20 * sizeConfig.safeBlockSmallest)
        ),
        padding: EdgeInsets.all(20 * sizeConfig.safeBlockSmallest),
        child:Consumer<NetworkImageData>(
          builder: (context, networkImageData, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Network Image",
                style: TextStyle(
                    color: appThemeData.selectedTheme.textColor,
                    fontSize: 32 * sizeConfig.safeBlockSmallest
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20 * sizeConfig.safeBlockSmallest),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  divider(appThemeData, sizeConfig.safeBlockSmallest),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Update Image Duration: ",
                        style: TextStyle(
                            color: appThemeData.selectedTheme.textColor,
                            fontSize: 24 * sizeConfig.safeBlockSmallest
                        ),
                        textAlign: TextAlign.center,
                      ),
                      CustomDropDown(
                        [
                          CustomDropDownItem(DurationUpdateType.every_seconds.name.enumNameToString(), (){networkImageData.changeNetworkImageUpdateDurationType(DurationUpdateType.every_seconds);}),
                          CustomDropDownItem(DurationUpdateType.every_minutes.name.enumNameToString(), (){networkImageData.changeNetworkImageUpdateDurationType(DurationUpdateType.every_minutes);}),
                          CustomDropDownItem(DurationUpdateType.every_hours.name.enumNameToString(), (){networkImageData.changeNetworkImageUpdateDurationType(DurationUpdateType.every_hours);}),
                          CustomDropDownItem(DurationUpdateType.never.name.enumNameToString(), (){networkImageData.changeNetworkImageUpdateDurationType(DurationUpdateType.never);})
                        ],
                        selectedItemID: networkImageData.networkImageSettings.durationUpdateType.index,
                      )
                    ],
                  ),
                  divider(appThemeData, sizeConfig.safeBlockSmallest),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: appThemeData.selectedTheme.primaryLightColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10 * sizeConfig.safeBlockSmallest))
                    ),
                    onPressed: (){
                      imageCache.clearLiveImages();
                      imageCache.clear();
                      /*DefaultCacheManager manager = DefaultCacheManager();
                      manager.emptyCache(); //clears all data in cache.*/
                    },
                    child: Text(
                      "Clear Images Cash",
                      style: TextStyle(
                          color: appThemeData.selectedTheme.textColor,
                          fontSize: 24 * sizeConfig.safeBlockSmallest
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget userSettingsWidget(AppThemeData appThemeData, AppSettingData appSettingData, double blockSmallest) {
    return Container(
      decoration: BoxDecoration(
          color: appThemeData.selectedTheme.primaryDarkColor,
          borderRadius: BorderRadius.circular(20 * blockSmallest)
      ),
      padding: EdgeInsets.all(20 * blockSmallest),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "General",
            style: TextStyle(
                color: appThemeData.selectedTheme.textColor,
                fontSize: 32 * blockSmallest
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20 * blockSmallest),
          Column(
            children: [
              divider(appThemeData, blockSmallest),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Drawer Widget",
                    style: TextStyle(
                        color: appThemeData.selectedTheme.textColor,
                        fontSize: 24 * blockSmallest
                    ),
                    textAlign: TextAlign.center,
                  ),
                  CustomDropDown(
                    [
                      CustomDropDownItem(DrawerWidgetType.animated_Widget.name.enumNameToString(), (){appSettingData.changeDrawerWidgetType(DrawerWidgetType.animated_Widget);}),
                      CustomDropDownItem(DrawerWidgetType.network_Image.name.enumNameToString(), (){appSettingData.changeDrawerWidgetType(DrawerWidgetType.network_Image);}),
                      CustomDropDownItem(DrawerWidgetType.weather_Widget.name.enumNameToString(), (){appSettingData.changeDrawerWidgetType(DrawerWidgetType.weather_Widget);}),
                      CustomDropDownItem(DrawerWidgetType.user_Image.name.enumNameToString(), (){appSettingData.changeDrawerWidgetType(DrawerWidgetType.user_Image);})
                    ],
                    selectedItemID: appSettingData.userAppSetting.drawerWidgetType.index,
                  )
                ],
              ),
              divider(appThemeData, blockSmallest),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Auto Clear Finished Task",
                    style: TextStyle(
                        color: appThemeData.selectedTheme.textColor,
                        fontSize: 24 * blockSmallest
                    ),
                    textAlign: TextAlign.center,
                  ),
                  CustomDropDown(
                    [
                      CustomDropDownItem(TimingTask.never.name.enumNameToString(), (){appSettingData.changeClearFinishedTaskTime(TimingTask.never);}),
                      CustomDropDownItem(TimingTask.daily.name.enumNameToString(), (){appSettingData.changeClearFinishedTaskTime(TimingTask.daily);}),
                      CustomDropDownItem(TimingTask.weakly.name.enumNameToString(), (){appSettingData.changeClearFinishedTaskTime(TimingTask.weakly);}),
                      CustomDropDownItem(TimingTask.monthly.name.enumNameToString(), (){appSettingData.changeClearFinishedTaskTime(TimingTask.monthly);})
                    ],
                    selectedItemID: appSettingData.userAppSetting.autoClearFinishedTaskTime.index,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Divider divider(AppThemeData appThemeData, double blockSmallest) => Divider(color: appThemeData.selectedTheme.primaryLightColor, indent: 100 * blockSmallest, endIndent: 100 * blockSmallest, thickness: 1,);

}
