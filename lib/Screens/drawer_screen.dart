
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/app_theme_data.dart';
import 'package:todo_app/Data/app_setting_data.dart';
import 'package:todo_app/Screens/setting_screen.dart';
import 'package:todo_app/Screens/theme_picker_screen.dart';

import '../Data/size_config.dart';
import '../Enums/drawer_widget_type.dart';
import '../Widgets/DrawerWidgets/animated_drawer_widget.dart';
import '../Widgets/DrawerWidgets/network_image.dart';
import '../Widgets/DrawerWidgets/user_selected_image.dart';
import '../Widgets/DrawerWidgets/weather_widget.dart';
import 'about_screen.dart';
import 'finished_tasks_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);

    return Consumer2<AppThemeData, AppSettingData>(
      builder: (context, appThemeData, appSettingData, child) => Container(
        color: appThemeData.selectedTheme.primaryLightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            drawerTopWidget(appThemeData, appSettingData,sizeConfig),
            drawerButtonList(appThemeData, sizeConfig, context)
          ],
        ),
      ),
    );
  }

  //this should return widget depends on user settings => { networkImage, userSelectedImage, weatherWidget, animatedWidget }
  Widget drawerTopWidget(AppThemeData appThemeData, AppSettingData appSettingData, SizeConfig sizeConfig) {
    if(!appSettingData.isLoaded) {
      return const SizedBox();
    }
    switch(appSettingData.userAppSetting.drawerWidgetType){
      case DrawerWidgetType.user_Image:
        return UserSelectedImageWidget(appThemeData.selectedTheme, sizeConfig);
      case DrawerWidgetType.network_Image:
        return NetworkImageView(sizeConfig: sizeConfig, appThemeData: appThemeData);
      case DrawerWidgetType.animated_Widget:
        return AnimatedDrawerWidget(sizeConfig: sizeConfig, appThemeData: appThemeData);
      case DrawerWidgetType.weather_Widget:
        return WeatherWidget(appThemeData, sizeConfig);
    }
  }

  Widget drawerButtonList(AppThemeData appThemeData, SizeConfig sizeConfig, BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _customButton(
          "Finished Tasks",
            FontAwesomeIcons.tableList,
          sizeConfig,
          appThemeData,
          (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FinishedTasksScreen(),));
          }
        ),
        _customButton(
            "Settings",
            FontAwesomeIcons.gear,
            sizeConfig,
            appThemeData,
            (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingScreen(),));
            }
        ),
        _customButton(
            "Themes",
            FontAwesomeIcons.palette,
            sizeConfig,
            appThemeData,
            (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ThemePickerScreen(),));
            }
        ),
        _customButton(
            "About",
            Icons.info_rounded,
            sizeConfig,
            appThemeData,
            (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutScreen(),));
            }
        ),
      ],
    );
  }

  SizedBox _customButton(String title,IconData icon,SizeConfig sizeConfig, AppThemeData appThemeData, Function()? onPressed) {
    return SizedBox(
        height: 100 * sizeConfig.safeBlockSmallest,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: appThemeData.selectedTheme.primaryLightColor,
            elevation: 0,
            surfaceTintColor: appThemeData.selectedTheme.primaryLightColor,
            shadowColor: Colors.transparent,
            foregroundColor: appThemeData.selectedTheme.primaryLightColor,
          ),
          onPressed: (){
            onPressed?.call();
          },
          child: Row(
            children: [
              Icon(icon, color: appThemeData.selectedTheme.textDarkColor, size: 32 * sizeConfig.safeBlockSmallest),
              SizedBox(width: 20 * sizeConfig.safeBlockSmallest,),
              Text(title, style: TextStyle(fontSize: 32 * sizeConfig.safeBlockSmallest, color: appThemeData.selectedTheme.textDarkColor)),
            ],
          )
        ),
      );
  }

}
