

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../Data/app_setting_data.dart';
import '../../Data/size_config.dart';
import '../../Data/AppThemeData.dart';
import '../../Data/weather_data.dart';
import '../../Enums/loading_state.dart';
import '../../Models/AppTheme.dart';
import '../gradient_icon.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget(
    this.appThemeData,
    this.sizeConfig,
    {
      super.key,
    }
  );
  final AppThemeData appThemeData;
  final SizeConfig sizeConfig;

  @override
  Widget build(BuildContext context) {
    var weather = WeatherData.instance;
    var appSettingData = Provider.of<AppSettingData>(context, listen: false);

    weather.loadWeather(temperatureUnit: appSettingData.userAppSetting.temperatureUnit);

    switch(weather.loadingState){
      case LoadingState.loading:
        return loadingWeatherWidget();
      case LoadingState.done:
        return weatherWidget(weather);
    }
    return errorWeatherWidget(weather, appThemeData.selectedTheme);
  }

  Widget loadingWeatherWidget(){
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50 * sizeConfig.safeBlockSmallest),
            ),
            gradient: LinearGradient(
                colors: [
                  appThemeData.selectedTheme.primaryDarkColor,
                  appThemeData.selectedTheme.primaryColor,
                ],
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
                stops: const [0.1,.9]
            )
        ),
        child: Padding(
          padding: EdgeInsets.all(20 * sizeConfig.safeBlockSmallest),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeShimmer(
                height: 32 * sizeConfig.safeBlockSmallest,
                width: 32 * sizeConfig.safeBlockSmallest,
                radius: 16 * sizeConfig.safeBlockSmallest,
                highlightColor: appThemeData.selectedTheme.primaryLightColor.withAlpha(200),
                baseColor: appThemeData.selectedTheme.primaryLightColor.withAlpha(64),
              ),
              SizedBox(
                height: 10 * sizeConfig.safeBlockSmallest,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeShimmer(
                    height: 32 * sizeConfig.safeBlockSmallest,
                    width: 32 * sizeConfig.safeBlockSmallest,
                    radius: 16 * sizeConfig.safeBlockSmallest,
                    highlightColor: appThemeData.selectedTheme.primaryLightColor.withAlpha(200),
                    baseColor: appThemeData.selectedTheme.primaryLightColor.withAlpha(64),
                  ),
                  FadeShimmer(
                    height: 128 * sizeConfig.safeBlockSmallest,
                    width: 128 * sizeConfig.safeBlockSmallest,
                    radius: 64 * sizeConfig.safeBlockSmallest,
                    highlightColor: appThemeData.selectedTheme.primaryLightColor.withAlpha(200),
                    baseColor: appThemeData.selectedTheme.primaryLightColor.withAlpha(64),
                  ),
                  FadeShimmer(
                    height: 32 * sizeConfig.safeBlockSmallest,
                    width: 32 * sizeConfig.safeBlockSmallest,
                    radius: 16 * sizeConfig.safeBlockSmallest,
                    highlightColor: appThemeData.selectedTheme.primaryLightColor.withAlpha(200),
                    baseColor: appThemeData.selectedTheme.primaryLightColor.withAlpha(64),
                  )
                ],
              ),
              SizedBox(
                height: 10 * sizeConfig.safeBlockSmallest,
              ),
              FadeShimmer(
                height: 24 * sizeConfig.safeBlockSmallest,
                width: 24 * sizeConfig.safeBlockSmallest,
                radius: 8 * sizeConfig.safeBlockSmallest,
                highlightColor: appThemeData.selectedTheme.primaryLightColor.withAlpha(200),
                baseColor: appThemeData.selectedTheme.primaryLightColor.withAlpha(64),
              ),
            ],
          ),
        )
    );
  }

  Widget weatherWidget(WeatherData weather){
    return GestureDetector(
      onLongPress: (){
        weather.forceUpdateWeatherData();
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50 * sizeConfig.safeBlockSmallest),
              ),
              gradient: LinearGradient(
                  colors: [
                    appThemeData.selectedTheme.primaryDarkColor,
                    appThemeData.selectedTheme.primaryColor,
                  ],
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                  stops: const [0.1,.9]
              )
          ),
          child: Padding(
            padding: EdgeInsets.all(20 * sizeConfig.safeBlockSmallest),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "10th of Ramadan City",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 32 * sizeConfig.safeBlockSmallest, color: appThemeData.selectedTheme.textColor.withAlpha(128)),
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10 * sizeConfig.safeBlockSmallest,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getWeatherRain(weather.currentWeather.precipitationProbability, weather.weatherData.hourlyUnits.precipitationProbability),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        getWeatherIcon(weather.currentWeather.getWeatherIcon()),
                        Text(
                          "${weather.currentWeather.temperature}${weather.weatherData.hourlyUnits.temperature}",
                          style: TextStyle(
                              color: appThemeData.selectedTheme.textColor,
                              fontSize: 32 * sizeConfig.safeBlockSmallest,
                              letterSpacing: -3 * sizeConfig.safeBlockSmallest,
                              fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    getWeatherHumidity(weather.currentWeather.relativeHumidity, weather.weatherData.hourlyUnits.relativeHumidity)
                  ],
                ),
                SizedBox(
                  height: 10 * sizeConfig.safeBlockSmallest,
                ),
                getWeatherFeel(weather.currentWeather.getWeatherFeel()),
              ],
            ),
          )
      ),
    );
  }

  Widget errorWeatherWidget(WeatherData weather, AppTheme theme){
    int width = (400 * sizeConfig.safeBlockSmallest).toInt();
    int height = (200 * sizeConfig.safeBlockSmallest).toInt();
    return  GestureDetector(
      onTapUp: (tapUpDetails){
        weather.forceUpdateWeatherData();
      },
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  appThemeData.selectedTheme.primaryDarkColor,
                  appThemeData.selectedTheme.primaryColor,
                  appThemeData.selectedTheme.primaryLightColor,
                ],
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
              )
          ),
          width: width.toDouble(),
          height: height.toDouble(),
          child: Center(child: Icon(Icons.error_outline_rounded, color: theme.textColor))
      )
    );
  }

  Widget getWeatherHumidity(int relativeHumidity, String relativeHumidityUnit){
    // TO-DO: use switch case and look what weatherCode is mean in Weather class and set text depends on weather code
    var weatherFeel = "$relativeHumidity$relativeHumidityUnit";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.water_drop_outlined, color: appThemeData.selectedTheme.secondaryColor,size: 24* sizeConfig.safeBlockSmallest),
        const SizedBox(width: 5,),
        Text(
          weatherFeel,
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24 * sizeConfig.safeBlockSmallest, color: appThemeData.selectedTheme.textColor.withAlpha(200)),
        ),
      ],
    );
  }

  Widget getWeatherRain(int relativeHumidity, String relativeHumidityUnit){
    // TO-DO: use switch case and look what weatherCode is mean in Weather class and set text depends on weather code
    var weatherFeel = "$relativeHumidity$relativeHumidityUnit";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(FontAwesomeIcons.cloudRain, color: appThemeData.selectedTheme.secondaryColor,size: 24 * sizeConfig.safeBlockSmallest),
        const SizedBox(width: 5,),
        Text(
          weatherFeel,
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24 * sizeConfig.safeBlockSmallest, color: appThemeData.selectedTheme.textColor.withAlpha(200)),
        ),
      ],
    );
  }

  Widget getWeatherFeel(String weatherFeel){
    return Center(
      child: Text(
        weatherFeel,
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18 * sizeConfig.safeBlockSmallest, color: appThemeData.selectedTheme.textColor.withAlpha(200)),
      ),
    );
  }

  Widget getWeatherIcon(IconData weatherIcon){
    return Icon(weatherIcon, color: appThemeData.selectedTheme.secondaryColor.withAlpha(128), size: 96 * sizeConfig.safeBlockSmallest,);
    return GradientIcon(
      weatherIcon,
      64 * sizeConfig.blockSmallest,
      LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          appThemeData.selectedTheme.secondaryColor,
          appThemeData.selectedTheme.secondaryColor.withAlpha(64),
        ],
        stops: const [0.3, 1]
      )
    );
  }
}