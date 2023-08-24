
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../Enums/hourly_durations_enum.dart';

class NetworkImageData extends ChangeNotifier {
  static const List<int> internetPhotosIds = [
    35, 41, 83, 196, 201, 232, 237,
    261, 292, 306, 312, 360, 365, 393
  ];
  int _id = internetPhotosIds[Random().nextInt(internetPhotosIds.length)];
  bool _refreshNext = true;
  Timer? timer;

  //drawer widget network image settings
  late NetworkImageSettings networkImageSettings;

  NetworkImageData(){
    networkImageSettings = NetworkImageSettings(DurationUpdateType.every_minutes, 1);
    load();
  }

  void load() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey(networkDataSaveKey)){
      var data = sharedPreferences.getString(networkDataSaveKey) as String;
      try{
        networkImageSettings = NetworkImageSettings.fromJson(jsonDecode(data));
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }
    }
    _autoRefreshImage();
    notifyListeners();
  }

  void _autoRefreshImage(){
    if(networkImageSettings.durationUpdateType == DurationUpdateType.never){
      return;
    }
    var duration = const Duration(minutes: 1);

    switch(networkImageSettings.durationUpdateType){
      case DurationUpdateType.every_seconds:
        duration = Duration(seconds: networkImageSettings.durationAmount);
        break;
      case DurationUpdateType.every_minutes:
        duration = Duration(minutes: networkImageSettings.durationAmount);
        break;
      case DurationUpdateType.every_hours:
        duration = Duration(hours: networkImageSettings.durationAmount);
        break;
      case DurationUpdateType.never:
        break;
    }

    timer = Timer(
      duration, 
      () {
        if(_refreshNext){
            _id = internetPhotosIds[Random().nextInt(internetPhotosIds.length)];
            notifyListeners();
          }
          _autoRefreshImage();
          _refreshNext = true;
        },
      );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  String getCurrentAnimatedImageURL(){
      var adress = [
        "https://media.tenor.com/FIlAXMHf8vsAAAAd/naruto-background.gif",
        "https://media.tenor.com/TAIxD-ulneYAAAAC/anime-anime-background.gif",
        "https://media.tenor.com/erbfpVT0mPUAAAAC/red-and-black-red.gif",
        "https://media.tenor.com/cAxdEo0EsPkAAAAC/pixel-art.gif"
      ];
      return adress[Random().nextInt(adress.length)];
  }

  String getCurrentImageURL(int width, int height){
    _id = internetPhotosIds[Random().nextInt(internetPhotosIds.length)];
    return "https://picsum.photos/id/$_id/$width/$height";
  }

  void refreshImage(){
    _refreshNext = false;
    notifyListeners();
  }

  void changeNetworkImageUpdateDurationType(DurationUpdateType durationUpdateType){
    networkImageSettings.durationUpdateType = durationUpdateType;
    _refreshNext = false;
    saveData();
  }

  void changeNetworkImageUpdateDuration(int amount){
    networkImageSettings.durationAmount = amount;
    _refreshNext = false;
    saveData();
  }

  void saveData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pref = jsonEncode(networkImageSettings);
    sharedPreferences.setString(networkDataSaveKey, pref);
  }
}

class NetworkImageSettings {
  DurationUpdateType durationUpdateType = DurationUpdateType.every_minutes;
  int durationAmount = 30;
  NetworkImageSettings(this.durationUpdateType, this.durationAmount);

  factory NetworkImageSettings.fromJson(Map<String, dynamic> json) => NetworkImageSettings(
    DurationUpdateType.values[json["durationUpdateType"]],
    json["durationAmount"],
  );

  Map<String, dynamic> toJson() => {
    "durationUpdateType":durationUpdateType.index,
    "durationAmount":durationAmount
  };
}