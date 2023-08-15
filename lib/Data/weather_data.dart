
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

import '../Enums/loading_state.dart';
import '../Enums/temperature_unit.dart';
import '../Models/user_location.dart';
import '../Models/WeatherModels/current_weather_model.dart';
import '../Models/WeatherModels/weather_model.dart';

class WeatherData {
  /*
  * API Site: https://open-meteo.com/
  * API CALL: https://api.open-meteo.com/v1/forecast?latitude=26.35&longitude=34.09&hourly=temperature_2m,relativehumidity_2m,precipitation_probability,weathercode&forecast_days=1&timezone=auto
  */

  /* Response Data JSON
  {
    "latitude":26.4,
    "longitude":34.1,
    "generationtime_ms":0.9620189666748047,
    "utc_offset_seconds":7200,
    "timezone":"Africa/Cairo",
    "timezone_abbreviation":"EET",
    "elevation":64.0,
    "hourly_units":
    {
      "time":"iso8601",
      "temperature_2m":"°C",
      "relativehumidity_2m":"%",
      "weathercode":"wmo code"
    },
    "hourly":
    {
      "time":
      [
        "2023-04-20T00:00","2023-04-20T01:00","2023-04-20T02:00","2023-04-20T03:00","2023-04-20T04:00","2023-04-20T05:00","2023-04-20T06:00","2023-04-20T07:00",
        "2023-04-20T08:00","2023-04-20T09:00","2023-04-20T10:00","2023-04-20T11:00","2023-04-20T12:00","2023-04-20T13:00","2023-04-20T14:00","2023-04-20T15:00",
        "2023-04-20T16:00","2023-04-20T17:00","2023-04-20T18:00","2023-04-20T19:00","2023-04-20T20:00","2023-04-20T21:00","2023-04-20T22:00","2023-04-20T23:00"
      ],
      "temperature_2m":
      [
        25.4,24.7,24.2,24.7,24.6,25.4,24.2,25.0,
        26.9,27.3,27.5,27.3,27.2,27.3,27.2,26.7,
        26.3,26.1,26.2,26.5,26.3,25.3,24.3,24.4
      ],
      "relativehumidity_2m":
      [
        34,50,53,40,29,47,69,65,
        54,53,53,53,52,50,50,51,
        51,48,43,37,37,43,39,32
      ],
      "weathercode":
      [
        1,2,2,2,1,1,2,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0
      ]
    }
  }
  */

  /*
  * Error json
  * "error": true,
  * "reason": "Cannot initialize WeatherVariable from invalid String value tempeture_2m for key hourly"
  */

  WeatherData._privateConstructor();
  static final WeatherData _instance = WeatherData._privateConstructor();
  static WeatherData get instance => _instance;

  late String cityName;
  late Weather weatherData;
  late CurrentWeather currentWeather;
  UserLocation? location;

  LoadingState loadingState = LoadingState.loading;

  Future<UserLocation> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      if (kDebugMode) {
        print("serviceEnabled: $serviceEnabled");
      }
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Permission.location.request();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    var geLocation = await Geolocator.getCurrentPosition();

    return UserLocation(geLocation.latitude, geLocation.longitude);
  }

  Future<void> forceUpdateWeatherData({TemperatureUnit temperatureUnit = TemperatureUnit.celsius}) async{
    loadingState = LoadingState.loading;

    var sharedPreferences = await SharedPreferences.getInstance();

    location = await _getLocation().onError((error, stackTrace) {
      if (kDebugMode) {
        print("$stackTrace\n$error");
      }
      loadingState = LoadingState.error;
      return UserLocation(0,0);
    });
    if (kDebugMode) {
      print("Location: ${location?.latitude}, ${location?.longitude}");
    }

    //List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
    //print(placemarks[0].name);

    //var cityNameApiCall = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}&key=AIzaSyDKG4siYyZggig76W5UjXZr39bv9S0NhHo";

    var weatherApiCall = "https://api.open-meteo.com/v1/forecast?"
        "latitude=${location?.latitude}"
        "&longitude=${location?.longitude}"
        "&hourly=temperature_2m,relativehumidity_2m,precipitation_probability,weathercode"
        "&temperature_unit=${temperatureUnit.name}"
        "&timezone=auto";

    var dio = Dio();
    var response = await dio.get(weatherApiCall);
    if (kDebugMode) {
      print(response);
    }
    //save to json
    var data = response.toString();
    //check if response data has error and what error type
    if(data.contains("error")) {
      loadingState = LoadingState.error;
      if (kDebugMode) {
        print(data);
      }
    }
    //if no error then save json to drive and convert json to model and load
    else {
      saveWeatherData(sharedPreferences, data);

      Map<String, dynamic> jsonData = json.decode(data.toString());
      weatherData = Weather.fromJson(jsonData);

      var time = DateFormat('yyyy-MM-ddThh:00').format(DateTime.now());
      var dateID = weatherData.hourly.time.indexOf(time);
      currentWeather = CurrentWeather(
          weatherData.hourly.time[dateID],
          weatherData.hourly.temperature[dateID].round(),
          weatherData.hourly.relativeHumidity[dateID],
          weatherData.hourly.precipitationProbability[dateID],
          weatherData.hourly.weatherCode[dateID]
      );

      loadingState = LoadingState.done;
    }
  }

  Future<void> loadWeather({TemperatureUnit temperatureUnit = TemperatureUnit.celsius}) async{
    try {
      //check if sharedPrefs have saved key or not
      var sharedPreferences = await SharedPreferences.getInstance();
      //sharedPreferences.clear();
      location ??= await _getLocation().onError((error, stackTrace) {
        if (kDebugMode) {
          print("$stackTrace\n$error");
        }
        return UserLocation(0,0);
      });

      if (kDebugMode) {
        print("Location: ${location?.latitude}, ${location?.longitude}");
      }

      //List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      //print(placemarks[0].name);
      //var cityNameApiCall = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}&key=AIzaSyDKG4siYyZggig76W5UjXZr39bv9S0NhHo";

      var weatherApiCall = "https://api.open-meteo.com/v1/forecast?"
          "latitude=${location?.latitude}"
          "&longitude=${location?.longitude}"
          "&hourly=temperature_2m,relativehumidity_2m,precipitation_probability,weathercode"
          "&temperature_unit=${temperatureUnit.name}"
          "&timezone=auto";

      if(sharedPreferences.containsKey(weatherDataSaveKey)) {
        String savedData = sharedPreferences.getString(weatherDataSaveKey).toString();
        Map<String, dynamic> jsonData = json.decode(savedData);
        weatherData = Weather.fromJson(jsonData);
        var time = DateFormat('yyyy-MM-ddThh:00').format(DateTime.now());
        var dateID = weatherData.hourly.time.indexOf(time);
        //check if weather date is updated or need to update
        if(dateID != -1) {
          currentWeather = CurrentWeather(
              weatherData.hourly.time[dateID],
              weatherData.hourly.temperature[dateID].round(),
              weatherData.hourly.relativeHumidity[dateID],
              weatherData.hourly.precipitationProbability[dateID],
              weatherData.hourly.weatherCode[dateID]);
          loadingState = LoadingState.done;
        }
        else{
          loadDataFromInternet(weatherApiCall, sharedPreferences);
        }
      }
      else {
        loadDataFromInternet(weatherApiCall, sharedPreferences);
      }
    }catch (e){
      if (kDebugMode) {
        print(e);
      }
      loadingState = LoadingState.error;
    }
  }

  void loadDataFromInternet(String weatherApiCall, SharedPreferences sharedPreferences) async {
    loadingState = LoadingState.loading;
    var dio = Dio();

    var response = await dio.get(weatherApiCall).onError((error, stackTrace) {
      if (kDebugMode) {
        print("Printed Error:\n$stackTrace\n$error");
      }
      loadingState = LoadingState.error;
      return Response(data: "$stackTrace\n$error",requestOptions: RequestOptions());
    });

    if (kDebugMode) {
      print(response);
    }
    //save to json
    var data = response.toString();
    //check if response data has error and what error type
    if(data.contains("error")) {
      if (kDebugMode) {
        print(data);
      }
      loadingState = LoadingState.error;
    }
    //if no error then save json to drive and convert json to model and load
    else {
      saveWeatherData(sharedPreferences, data);
      Map<String, dynamic> jsonData = json.decode(data.toString());
      weatherData = Weather.fromJson(jsonData);

      var time = DateFormat('yyyy-MM-ddThh:00').format(DateTime.now());
      var dateID = weatherData.hourly.time.indexOf(time);
      currentWeather = CurrentWeather(
          weatherData.hourly.time[dateID],
          weatherData.hourly.temperature[dateID].round(),
          weatherData.hourly.relativeHumidity[dateID],
          weatherData.hourly.precipitationProbability[dateID],
          weatherData.hourly.weatherCode[dateID]
      );

      loadingState = LoadingState.done;
    }
  }

  void saveWeatherData(SharedPreferences sharedPreferences, String data){
    sharedPreferences.setString(weatherDataSaveKey, data);
  }

  void clearCash() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(weatherDataSaveKey);
  }

}


