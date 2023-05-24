
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/AppThemeData.dart';

import '../Data/app_setting_data.dart';
import '../Data/size_config.dart';
import '../Widgets/back_to_prev_screen_button.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

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
                      "About",
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
                  SizedBox(width: 50 * sizeConfig.blockSizeHorizontal,)
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}