class Report {
  Report({
    this.complaintId,
    this.userId,
    this.complaintDate,
    this.wardId,
    this.phone,
    this.latitude,
    this.longitude,
    this.userName,
    this.houseName,
    this.wardName,
  });

  String complaintId;
  String userId;
  DateTime complaintDate;
  String wardId;
  String phone;
  String latitude;
  String longitude;
  String userName;
  String houseName;
  String wardName;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        complaintId: json["complaint_id"],
        userId: json["user_id"],
        complaintDate: DateTime.parse(json["complaint_date"]),
        wardId: json["ward_id"],
        phone: json["phone"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        userName: json["user_name"],
        houseName: json["house_name"],
        wardName: json["ward_name"],
      );

  Map<String, dynamic> toJson() => {
        "complaint_id": complaintId,
        "user_id": userId,
        "complaint_date": complaintDate.toIso8601String(),
        "ward_id": wardId,
        "phone": phone,
        "latitude": latitude,
        "longitude": longitude,
        "user_name": userName,
        "house_name": houseName,
        "ward_name": wardName,
      };
}
