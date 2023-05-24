
//hourly_units
class HourlyUnits {
  /*
  * json data
  * "hourly_units":
  * {
  *   "time":"iso8601",
  *   "temperature_2m":"°C",
  *   "relativehumidity_2m":"%",
  *   "precipitation_probability": %,
  *   "weathercode":"wmo code"
  * }
  */
  String temperature;
  String relativeHumidity;
  String precipitationProbability;

  HourlyUnits(
      this.temperature,
      this.relativeHumidity,
      this.precipitationProbability
      );

  factory HourlyUnits.fromJson(Map<String, dynamic> json) {
    return HourlyUnits(json["temperature_2m"], json["relativehumidity_2m"], json["precipitation_probability"]);
  }
}