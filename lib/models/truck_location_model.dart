class TruckLocation {
  int id;
  double latitude;
  double longitude;
  DateTime uploadTime;

  TruckLocation({this.id, this.latitude, this.longitude, this.uploadTime});

  factory TruckLocation.fromJson(Map<String, dynamic> map) => TruckLocation(
      id: int.parse(map["location_id"]),
      latitude: double.parse(map["latitude"]),
      longitude: double.parse(map["longitude"]),
      uploadTime: DateTime.parse(map["upload_time"]));
}
