

class UserLocation {
  double latitude;
  double longitude;

  UserLocation(this.latitude,this.longitude);

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(json["latitude"], json["longitude"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "latitude":latitude,
      "longitude":longitude
    };
  }
}