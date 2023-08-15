
import 'package:flutter/material.dart';
import 'package:todo_app/Data/size_config.dart';

import '../../Models/app_theme.dart';

class AnimatedDrawerWidget extends StatefulWidget {
  final AppTheme theme;
  final SizeConfig sizeConfig;
  const AnimatedDrawerWidget(this.theme, this.sizeConfig, {Key? key}) : super(key: key);
  @override
  State<AnimatedDrawerWidget> createState() => _AnimatedDrawerWidgetState();
}

class _AnimatedDrawerWidgetState extends State<AnimatedDrawerWidget> {
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
