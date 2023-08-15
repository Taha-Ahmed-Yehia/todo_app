
import 'weather_hourly_model.dart';
import 'weather_hourly_units.dart';

class Weather {
  String timezone;
  HourlyUnits hourlyUnits;
  Hourly hourly;
  double latitude;
  double longitude;

  Weather(
      this.timezone,
      this.hourlyUnits,
      this.hourly,
      this.latitude,
      this.longitude
      );

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(json["timezone"], HourlyUnits.fromJson(json["hourly_units"]), Hourly.fromJson(json["hourly"]), json["latitude"], json["longitude"]);
  }
}
