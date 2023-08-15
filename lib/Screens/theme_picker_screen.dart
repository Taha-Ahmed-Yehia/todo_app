
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Data/size_config.dart';
import '../Data/app_theme_data.dart';
import '../Widgets/back_to_prev_screen_button.dart';
import 'package:todo_app/Models/app_theme.dart';

import 'create_or_edit_theme_screen.dart';

class ThemePickerScreen extends StatelessWidget {
  const ThemePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);

    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => EditThemes(),
        child: Consumer2<AppThemeData, EditThemes>(
          builder: (context, appThemeData, editThemes, child) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: appThemeData.selectedTheme.primaryLightColor,
              body:Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackToPrevScreenButton(appThemeData.selectedTheme.textColor, buttonSize: 50 * sizeConfig.safeBlockSmallest),
                          Text(
                              "${editThemes.inEditMode ? "Edit: ":""}Themes",
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
                          IconButton(
                            onPressed: (){
                              editThemes.toggleEditMode();
                            },
                            icon: Icon(FontAwesomeIcons.solidPenToSquare, color: appThemeData.selectedTheme.textColor, size: 50 * sizeConfig.safeBlockSmallest,)
                          )
                        ],
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250 * sizeConfig.safeBlockSmallest,
                            childAspectRatio: 4/3,
                            crossAxisSpacing: 32 * sizeConfig.safeBlockSmallest,
                            mainAxisSpacing: 32 * sizeConfig.safeBlockSmallest
                          ),
                          itemCount: appThemeData.themes.length,
                          itemBuilder: (_, index){
                            var theme = appThemeData.themes[index];
                            return themeTile(context,sizeConfig, theme, appThemeData, index, editThemes.inEditMode);
                          },
                        ),
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
                          minimumSize: const Size(150, 150) * sizeConfig.safeBlockSmallest,
                          shape: const PolygonBorder(sides: 6),
                          backgroundColor: appThemeData.selectedTheme.primaryDarkColor,
                          elevation: 6,
                        ),
                        onPressed: (){
                          editThemes.setEditMode(false);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateOrEditTheme(appThemeData.selectedTheme)));
                        },
                        child: Icon(Icons.add, color: appThemeData.selectedTheme.textColor, size: 100 * sizeConfig.safeBlockSmallest,)
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        ),
      )
    );
  }

  Widget themeTile(BuildContext context,SizeConfig sizeConfig, AppTheme theme, AppThemeData appThemeData, int index, bool editMode) {
    return Padding(
      padding: EdgeInsetsDirectional.all(10 * sizeConfig.blockSmallest),
      child: Stack(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.all(Radius.circular(25 * sizeConfig.blockSmallest))),
                elevation: 2
            ),
            onPressed: (){
              if (editMode && !theme.isDefault){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateOrEditTheme(theme, editing: editMode,)));
              } else if(!editMode){
                appThemeData.selectTheme(index);
              }
            },
            child: Center(
              child: Text(
                theme.name,
                style: TextStyle(
                  fontSize: 32 * sizeConfig.blockSmallest,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
                textAlign: TextAlign.center,
              )
            )
          ),
          theme.name == appThemeData.selectedTheme.name ? selectedThemeDot(appThemeData, sizeConfig) : const SizedBox(),
          (editMode && !theme.isDefault) ? Align(
            alignment: AlignmentDirectional.topEnd,
            child: Padding(
              padding: EdgeInsets.only(left: 10 * sizeConfig.safeBlockSmallest, top: 10 * sizeConfig.safeBlockSmallest),
              child: GestureDetector(
                onTapUp: (tapUpDetails){
                  appThemeData.removeTheme(theme);
                },
                child: Icon(FontAwesomeIcons.circleXmark, color: theme.secondaryColor, size: 50 * sizeConfig.safeBlockSmallest,)),
            ),
          ) : const SizedBox()
        ],
      ),
    );
  }

  Widget selectedThemeDot(AppThemeData appThemeData, SizeConfig sizeConfig){
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Padding(
        padding: EdgeInsets.only(top: 10 * sizeConfig.blockSmallest, left: 10 * sizeConfig.blockSmallest),
        child: Icon(Icons.brightness_1, color: appThemeData.selectedTheme.secondaryColor, size: 18 * sizeConfig.blockSmallest,),
      )
    );
  }
}

class EditThemes extends ChangeNotifier{
  bool inEditMode = false;
  void setEditMode(bool editMode){
    inEditMode = editMode;
    notifyListeners();
  }
  void toggleEditMode(){
    inEditMode = !inEditMode;
    notifyListeners();
  }
}