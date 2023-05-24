
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Data/size_config.dart';

import '../Data/AppThemeData.dart';
import '../Models/AppTheme.dart';

class ItemTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final AppTheme theme;
  final Function(bool?) checkboxChange;
  final Function() deleteChange;

  const ItemTile({required this.taskTitle, required this.isChecked, required this.checkboxChange, required this.deleteChange, required this.theme, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);
    return Padding(
      padding: EdgeInsets.only(left: 50.0 * sizeConfig.safeBlockSmallest, right: 50.0 * sizeConfig.safeBlockSmallest),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _customCheckbox(sizeConfig),
              SizedBox(width: 50 * sizeConfig.safeBlockSmallest,),
              Text(
                taskTitle,
                style: TextStyle(
                  decoration: isChecked ?  TextDecoration.lineThrough : null,
                  color: theme.textDarkColor,
                  fontSize: 50 * sizeConfig.safeBlockSmallest,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                useSafeArea: false,
                builder: (context) {
                  return Center(
                    child: FittedBox(
                      child: Container(
                        width: sizeConfig.screenWidth - 100 * sizeConfig.safeBlockSmallest,
                        decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadiusDirectional.circular(20 * sizeConfig.safeBlockSmallest)),
                        padding: EdgeInsets.all(50 * sizeConfig.safeBlockSmallest),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Delete item?", style: TextStyle(color: theme.textColor, fontSize: 50 * sizeConfig.safeBlockSmallest),),
                            SizedBox(height: 50 * sizeConfig.safeBlockSmallest,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.primaryLightColor,
                                        fixedSize: Size(200 * sizeConfig.safeBlockSmallest, 100 * sizeConfig.safeBlockSmallest)
                                    ),
                                    onPressed: deleteChange,
                                    child: Text("Yes", style: TextStyle(color: theme.textColor, fontSize: 50 * sizeConfig.safeBlockSmallest),)
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.primaryLightColor,
                                        fixedSize: Size(200 * sizeConfig.safeBlockSmallest, 100 * sizeConfig.safeBlockSmallest)
                                    ),
                                    onPressed: (){Navigator.of(context).pop();},
                                    child: Text("No", style: TextStyle(color: theme.textColor, fontSize: 50 * sizeConfig.safeBlockSmallest),)
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.delete, color:theme.primaryDarkColor, size: 50 * sizeConfig.safeBlockSmallest,)
          )
        ],
      ),
    );
  }

  Widget _customCheckbox(SizeConfig sizeConfig) {
    return GestureDetector(
      onTap: (){ checkboxChange.call(isChecked);},
      child: Container(
        width: 50 * sizeConfig.safeBlockSmallest,
        height: 50 * sizeConfig.safeBlockSmallest,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10 * sizeConfig.safeBlockSmallest),
            color: theme.primaryColor
        ),
        padding: EdgeInsets.all(5 * sizeConfig.safeBlockSmallest),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5 * sizeConfig.safeBlockSmallest),
              color: isChecked ? theme.primaryColor : theme.secondaryColor
          ),
          child: isChecked ? Icon(Icons.check, color: theme.secondaryColor, size: 25 * sizeConfig.safeBlockSmallest,) : SizedBox(),
        ),
      ),
    );
    return Checkbox(
        activeColor: theme.primaryDarkColor,
        value: isChecked,
        onChanged: checkboxChange,
      );
  }

}
