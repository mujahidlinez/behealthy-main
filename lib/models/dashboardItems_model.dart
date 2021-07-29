import 'dart:convert';

List<GetPackage> getPackageFromJson(String str) =>
    List<GetPackage>.from(json.decode(str).map((x) => GetPackage.fromJson(x)));

String getPackageToJson(List<GetPackage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetPackage {
  String id;
  int planID;
  String arabicName;
  String planName;
  String planWeight;
  String planImage;
  String sortBy;
  int planPrice;

  GetPackage(
      {this.id,
      this.planID,
      this.planImage,
      this.planName,
      this.planPrice,
      this.arabicName,
      this.planWeight,
      this.sortBy});

  factory GetPackage.fromJson(Map<String, dynamic> json) => GetPackage(
        id: json['\$id'],
        planID: json["PlanID"],
        planImage: json["Plan_Image"],
        planName: json["PlanName"],
        planPrice: json["Plan_price1"],
        arabicName: json['ArabicName'],
        planWeight: json['PlanWeight'],
        sortBy: json['SortBy'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "planID": planID,
        "planImage": planImage,
        "planName": planName,
        "planPrice": planPrice,
        "arabicName": arabicName,
        "planWeight": planWeight,
        "sortBy": sortBy
      };
}
