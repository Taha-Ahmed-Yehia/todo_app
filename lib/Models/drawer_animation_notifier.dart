
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';

class DrawerAnimation with ChangeNotifier {
  final zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    notifyListeners();
  }
}