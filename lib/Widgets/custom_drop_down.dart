
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Data/app_theme_data.dart';
import '../Data/size_config.dart';
import '../Models/app_theme.dart';

class CustomDropDown extends StatefulWidget {
  final Function? onSelect;
  final int selectedItemID;
  final List<CustomDropDownItem> dropDownItems;

  const CustomDropDown(this.dropDownItems, {this.onSelect, this.selectedItemID = 0,Key? key}) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  bool _isDropDown = false;
  OverlayEntry? entry;
  int selectedItemID = 0;

  @override
  void initState() {
    super.initState();
    selectedItemID = widget.selectedItemID;
  }
  @override
  void dispose() {
    super.dispose();
    if(_isDropDown) {
      entry?.remove();
    }
  }

  void showOverlay(BuildContext context, SizeConfig sizeConfig){
    var overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(
      builder: (context) => Consumer<AppThemeData>(
        builder: (context, appThemeData, child) => Stack(
          children: [
            GestureDetector(
              onTap: (){
                setState((){
                  _isDropDown = !_isDropDown;
                });
                entry?.remove();
              },
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height,
              width: size.width,
              child: buildOverly(sizeConfig, appThemeData)
            ),
          ],
        ),
      )
    );
    overlay.insert(entry!);
  }

  Widget buildOverly(SizeConfig sizeConfig, AppThemeData appThemeData) {
    return Material(
      borderRadius: BorderRadius.circular(10 * sizeConfig.blockSmallest),
      color: appThemeData.selectedTheme.primaryDarkColor,
      elevation: 8,
      child:  Padding(
        padding: EdgeInsets.all(20.0 * sizeConfig.blockSmallest),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.dropDownItems.map((e) => dropDownItemTile(e, appThemeData.selectedTheme, sizeRatio: sizeConfig.blockSmallest)).toList(),
        ),
      )
    );
  }

  Widget dropDownItemTile(CustomDropDownItem item, AppTheme theme, {double sizeRatio = 1}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10 * sizeRatio)
            ),
          ),
          onPressed: (){
            widget.onSelect?.call();
            item.onSelect.call();

            entry?.remove();
            setState(() {
              selectedItemID = widget.dropDownItems.indexOf(item);
              _isDropDown = !_isDropDown;
            });
          },
          child: FittedBox(child: Text(item.title, textAlign: TextAlign.center, style: TextStyle(color: theme.textColor, ))),
        ),
        SizedBox(height: 5 * sizeRatio,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var sizeConfig = SizeConfig(context);
    return Consumer<AppThemeData>(
        builder: (context, appThemeData, child) => ElevatedButton(
          onPressed: (){
            setState(() {
              _isDropDown = !_isDropDown;
              if(_isDropDown){
                WidgetsBinding.instance.addPostFrameCallback((_)=> showOverlay(context, sizeConfig));
              }else{
                entry?.remove();
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appThemeData.selectedTheme.primaryLightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10 * sizeConfig.blockSmallest),
            ),
            elevation: 0,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 20 * sizeConfig.blockSmallest,bottom: 20 * sizeConfig.blockSmallest),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.dropDownItems[selectedItemID].title, style: TextStyle(color: appThemeData.selectedTheme.textColor, fontSize: 24 * sizeConfig.blockSmallest), ),
                SizedBox(width: 50 * sizeConfig.blockSmallest,),
                Icon(
                  _isDropDown ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown,
                  color: appThemeData.selectedTheme.textColor,
                  size: 24 * sizeConfig.blockSmallest,
                )
              ],
            ),
          ),
      )
    );
  }
}

class CustomDropDownItem {
  String title;
  Function onSelect;
  CustomDropDownItem(this.title, this.onSelect);
}
