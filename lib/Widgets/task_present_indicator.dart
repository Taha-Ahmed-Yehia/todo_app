

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../Data/size_config.dart';
import '../Models/app_theme.dart';

class TaskPercentIndicator extends StatelessWidget {
  final double percentage;
  final AppTheme appTheme;
  final SizeConfig sizeConfig;
  const TaskPercentIndicator(this.appTheme,this.sizeConfig, this.percentage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double paddingSize = 32 * sizeConfig.blockSmallest;
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1000,
      lineHeight: 30 * sizeConfig.blockSmallest,
      percent: percentage,
      progressColor: appTheme.primaryDarkColor,
      backgroundColor: appTheme.primaryColor,
      barRadius: Radius.circular(paddingSize),
    );
  }
}