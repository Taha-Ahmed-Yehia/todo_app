
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Data/AppThemeData.dart';
import 'package:todo_app/Data/app_setting_data.dart';
import 'package:todo_app/Data/TaskData.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
import 'package:todo_app/Models/drawer_animation_notifier.dart';
import 'Data/network_image_data.dart';
import 'Screens/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
    )
  );
  //await Firebase.initializeApp();
  //runApp(const MyApp());
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      isToolbarVisible: true,
      builder: (context) => const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppThemeData(),
      child: ChangeNotifierProvider(
        create: (context)=> TaskData(),
        child: ChangeNotifierProvider(
          create: (context) => AppSettingData(),
          child: MaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            home: HomeScreen()//SignInScreen(),
          ),
        ),
      ),
    );
  }
}
