import 'package:flutter/material.dart';

import '../../Data/size_config.dart';
import '../../Models/AppTheme.dart';

class UserSelectedImageWidget extends StatefulWidget {
  final AppTheme theme;
  final SizeConfig sizeConfig;
  const UserSelectedImageWidget(this.theme, this.sizeConfig,{Key? key}) : super(key: key);

  @override
  State<UserSelectedImageWidget> createState() => _UserSelectedImageWidgetState();
}

class _UserSelectedImageWidgetState extends State<UserSelectedImageWidget> {
  @override
  Widget build(BuildContext context) {
    int width = (400 * widget.sizeConfig.safeBlockSmallest).toInt();
    int height = (200 * widget.sizeConfig.safeBlockSmallest).toInt();
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.theme.primaryDarkColor,
              widget.theme.primaryColor,
              widget.theme.primaryLightColor,
            ],
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
          )
      ),
      width: width.toDouble(),
      height: height.toDouble(),

    );
  }
}
