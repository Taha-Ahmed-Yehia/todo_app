
import 'package:flutter/material.dart';
import 'package:todo_app/Models/AppTheme.dart';

void showCustomDialog(String title, String message, BuildContext context, AppTheme theme, {double blockSmallest = 1}){
  showDialog(context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.primaryColor,
        title: Center(
          child: Text(
            title,
            style: TextStyle(
                color: theme.textColor,
                fontSize: 32 * blockSmallest,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        content: FittedBox(
          child: Text(
            message,
            style: TextStyle(
                color: theme.textColor,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      )
  );
}
