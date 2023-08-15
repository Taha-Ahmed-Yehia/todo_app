
//"hourly":
class Hourly {

  List<String> time;
  List<double> temperature;
  List<int> relativeHumidity;
  List<int> precipitationProbability;
  List<int> weatherCode;
  Hourly(
      this.time,
      this.temperature,
      this.relativeHumidity,
      this.precipitationProbability,
      this.weatherCode
      );

  factory Hourly.fromJson(Map<String, dynamic> json) {
    return Hourly(
      List.of(json["time"]).map((i) => i.toString()).toList(),
      List.of(json["temperature_2m"]).map((i) => i).cast<double>().toList(),
      List.of(json["relativehumidity_2m"]).map((i) => i).cast<int>().toList(),
      List.of(json["precipitation_probability"]).map((i) => i).cast<int>().toList(),
      List.of(json["weathercode"]).map((i) => i).cast<int>().toList(),
    );
  }
}