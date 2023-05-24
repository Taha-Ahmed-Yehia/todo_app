
import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';

class CurrentWeather {
  String time;
  int temperature;
  int relativeHumidity;
  int precipitationProbability;
  int weatherCode;
  /*
  * WMO Weather interpretation codes (WW)
  * Code	Description
  * 0	Clear sky
  * 1, 2, 3	Mainly clear, partly cloudy, and overcast
  * 45, 48	Fog and depositing rime fog
  * 51, 53, 55	Drizzle: Light, moderate, and dense intensity
  * 56, 57	Freezing Drizzle: Light and dense intensity
  * 61, 63, 65	Rain: Slight, moderate and heavy intensity
  * 66, 67	Freezing Rain: Light and heavy intensity
  * 71, 73, 75	Snow fall: Slight, moderate, and heavy intensity
  * 77	Snow grains
  * 80, 81, 82	Rain showers: Slight, moderate, and violent
  * 85, 86	Snow showers slight and heavy
  * 95 Thunderstorm: Slight or moderate
  * 96, 99 Thunderstorm with slight and heavy hail
  */


  CurrentWeather(this.time, this.temperature, this.relativeHumidity, this.precipitationProbability, this.weatherCode);


  String getWeatherFeel(){
    switch(weatherCode){
      case 0:
        return "Clear Sky";

      case 1:
        return "Mainly Clear";
      case 2:
        return "Partly Cloudy";
      case 3:
        return "Overcast";

      case 45:
        return "Fog";
      case 48:
        return "Depositing Rime Fog";

      case 51:
        return "Light Drizzle";
      case 53:
        return "Moderate Drizzle";
      case 55:
        return "Dense Drizzle";

      case 56:
        return "Light Freezing Drizzle";
      case 57:
        return "Dense Freezing Drizzle";

      case 61:
        return "Slight Rain";
      case 63:
        return "Moderate Rain";
      case 65:
        return "Heavy Rain";

      case 66:
        return "Light Freezing Rain";
      case 67:
        return "Heavy Freezing Rain";

      case 71:
        return "Slight Snow Fall";
      case 73:
        return "Moderate Snow Fall";
      case 75:
        return "Heavy Snow Fall";

      case 77:
        return "Snow Grains";

      case 80:
        return "Slight Rain Showers";
      case 81:
        return "Moderate Rain Showers";
      case 82:
        return "Heavy Rain Showers";

      case 95:
        return "Thunderstorm";

      case 96:
        return "Slight Hail Thunderstorm";
      case 99:
        return "Heavy Hail Thunderstorm";
    }
    return "Clear sky";
  }

  IconData getWeatherIcon(){
    switch(weatherCode){
      case 0:
        return WeatherIcons.alien;

      case 1:
      case 2:
        return WeatherIcons.day_cloudy;
      case 3:
        return WeatherIcons.day_sunny_overcast;

      case 45:
      case 48:
        return WeatherIcons.fog;

      /*case 51:
        return "Light Drizzle";
      case 53:
        return "Moderate Drizzle";
      case 55:
        return "Dense Drizzle";

      case 56:
        return "Light Freezing Drizzle";
      case 57:
        return "Dense Freezing Drizzle";*/

      case 61:
        return WeatherIcons.raindrop;
      case 63:
        return WeatherIcons.raindrops;
      case 65:
        return WeatherIcons.rain;

      case 66:
      case 67:
        return WeatherIcons.hail;

      case 71:
      case 73:
      case 75:
      case 77:
        return WeatherIcons.snow;

      case 80:
      case 81:
      case 82:
        return WeatherIcons.showers;

      case 95:
        return WeatherIcons.thunderstorm;

      case 96:
      case 99:
        return WeatherIcons.day_snow_thunderstorm;
    }
    return WeatherIcons.day_sunny;
  }

}
