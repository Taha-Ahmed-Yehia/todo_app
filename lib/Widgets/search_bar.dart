
import 'package:flutter/material.dart';

import '../Data/AppThemeData.dart';
import '../Data/size_config.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.sizeConfig,
    required this.appThemeData,
    required this.onTextFieldChange,
  });

  final SizeConfig sizeConfig;
  final AppThemeData appThemeData;
  final Function(String p1) onTextFieldChange;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: appThemeData.selectedTheme.primaryLightColor,
            borderRadius: BorderRadius.circular(20 * sizeConfig.safeBlockSmallest),
            boxShadow: [
              BoxShadow(
                  color: appThemeData.selectedTheme.primaryColor,
                  blurRadius: 4,
                  offset: const Offset(2,4)
              ),
            ]
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10 * sizeConfig.safeBlockSmallest, right: 10 * sizeConfig.safeBlockSmallest),
          child: Row(
              children: [
                Icon(Icons.search, color: appThemeData.selectedTheme.textDarkColor, size: 50 * sizeConfig.safeBlockSmallest,),
                SizedBox(width: 20 * sizeConfig.safeBlockSmallest,),
                Expanded(
                    child:TextField(
                      style: TextStyle(
                          color: appThemeData.selectedTheme.textDarkColor,
                          fontSize: 50 * sizeConfig.safeBlockSmallest
                      ),
                      decoration: InputDecoration(
                          hintText: "Search...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: appThemeData.selectedTheme.textDarkColor.withAlpha(128),
                              fontSize: 50 * sizeConfig.safeBlockSmallest
                          )
                      ),
                      onChanged: (value) => onTextFieldChange(value),
                    )
                ),
              ]
          ),
        ),
      ),
    );
  }
}