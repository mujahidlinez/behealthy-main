// To parse this JSON data, do
//
//     final PlanMealCIHDSModel = PlanMealCIHDSModelFromMap(jsonString);

import 'dart:convert';

import 'dart:ffi';

List<PlanMealCIHDSModel> getPackageFromJson(String str) =>
    List<PlanMealCIHDSModel>.from(
        json.decode(str).map((x) => PlanMealCIHDSModel.fromJson(x)));

String getPackageToJson(List<PlanMealCIHDSModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlanMealCIHDSModel {
  PlanMealCIHDSModel({
    this.id,
    this.tenentId,
    this.mytransid,
    // this.locationId,
    this.customerId,
    this.planid,
    this.dayNumber,
    this.transId,
    this.contractId,
    this.defaultDriverId,
    this.contractDate,
    this.weekofDay,
    this.startDate,
    this.endDate,
    this.totalSubDays,
    this.deliveredDays,
    this.nExtDeliveryDate,
    this.nExtDeliveryNum,
    this.week1TotalCount,
    this.week1Count,
    this.week2Count,
    this.week2TotalCount,
    this.week3Count,
    this.week3TotalCount,
    this.week4Count,
    this.week4TotalCount,
    this.week5Count,
    this.week5TotalCount,
    this.contractTotalCount,
    this.contractSelectedCount,
    this.isFullPlanCopied,
    this.subscriptionOnHold,
    this.holdDate,
    this.unHoldDate,
    this.holdbyuser,
    this.holdREmark,
    this.subscriptonDayNumber,
    // this.totalPrice,
    this.shortRemark,
    this.active,
    // this.crupId,
    this.changesDate,
    this.driverId,
    this.cStatus,
    this.uploadDate,
    this.uploadby,
    this.syncDate,
    this.syncby,
    this.synId,
    this.paymentStatus,
    this.syncStatus,
    this.localId,
    this.offlineStatus,
    this.allergies,
    this.carbs,
    this.protein,
    this.remarks,
  });

  String id;
  int tenentId;
  int mytransid;
  // int locationId;
  int customerId;
  int planid;
  int dayNumber;
  int transId;
  String contractId;
  int defaultDriverId;
  String contractDate;
  String weekofDay;
  String startDate;
  String endDate;
  int totalSubDays;
  int deliveredDays;
  String nExtDeliveryDate;
  int nExtDeliveryNum;
  int week1TotalCount;
  int week1Count;
  int week2Count;
  int week2TotalCount;
  int week3Count;
  int week3TotalCount;
  int week4Count;
  int week4TotalCount;
  int week5Count;
  int week5TotalCount;
  int contractTotalCount;
  int contractSelectedCount;
  bool isFullPlanCopied;
  bool subscriptionOnHold;
  String holdDate;
  String unHoldDate;
  int holdbyuser;
  String holdREmark;
  int subscriptonDayNumber;
  // double totalPrice;
  String shortRemark;
  bool active;
  // int crupId;
  String changesDate;
  int driverId;
  String cStatus;
  String uploadDate;
  String uploadby;
  String syncDate;
  String syncby;
  int synId;
  String paymentStatus;
  String syncStatus;
  int localId;
  String offlineStatus;
  String allergies;
  int carbs;
  int protein;
  String remarks;

  factory PlanMealCIHDSModel.fromJson(String str) =>
      PlanMealCIHDSModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
        // locationId: json["LOCATION_ID"],
        // totalPrice: json["Total_price"],
        // crupId: json["CRUP_ID"],

  factory PlanMealCIHDSModel.fromMap(Map<String, dynamic> json) =>
      PlanMealCIHDSModel(
        id: json["\$id"],
        tenentId: json["TenentID"],
        mytransid: json["MYTRANSID"],
        customerId: json["CustomerID"],
        planid: json["planid"],
        dayNumber: json["DayNumber"],
        transId: json["TransID"],
        contractId: json["ContractID"],
        defaultDriverId: json["DefaultDriverID"],
        contractDate: json["ContractDate"],
        weekofDay: json["WeekofDay"],
        startDate: json["StartDate"],
        endDate: json["EndDate"],
        totalSubDays: json["TotalSubDays"],
        deliveredDays: json["DeliveredDays"],
        nExtDeliveryDate: json["NExtDeliveryDate"],
        nExtDeliveryNum: json["NExtDeliveryNum"],
        week1TotalCount: json["Week1TotalCount"],
        week1Count: json["Week1Count"],
        week2Count: json["Week2Count"],
        week2TotalCount: json["Week2TotalCount"],
        week3Count: json["Week3Count"],
        week3TotalCount: json["Week3TotalCount"],
        week4Count: json["Week4Count"],
        week4TotalCount: json["Week4TotalCount"],
        week5Count: json["Week5Count"],
        week5TotalCount: json["Week5TotalCount"],
        contractTotalCount: json["ContractTotalCount"],
        contractSelectedCount: json["ContractSelectedCount"],
        isFullPlanCopied: json["IsFullPlanCopied"],
        subscriptionOnHold: json["SubscriptionOnHold"],
        holdDate: json["HoldDate"],
        unHoldDate: json["UnHoldDate"],
        holdbyuser: json["Holdbyuser"],
        holdREmark: json["HoldREmark"],
        subscriptonDayNumber: json["SubscriptonDayNumber"],
        shortRemark: json["ShortRemark"],
        active: json["ACTIVE"],
        changesDate: json["ChangesDate"],
        driverId: json["DriverID"],
        cStatus: json["CStatus"],
        uploadDate: json["UploadDate"],
        uploadby: json["Uploadby"],
        syncDate: json["SyncDate"],
        syncby: json["Syncby"],
        synId: json["SynID"],
        paymentStatus: json["PaymentStatus"],
        syncStatus: json["syncStatus"],
        localId: json["LocalID"],
        offlineStatus: json["OfflineStatus"],
        allergies: json["Allergies"],
        carbs: json["Carbs"],
        protein: json["Protein"],
        remarks: json["Remarks"],
      );
        // "LOCATION_ID": locationId,

  Map<String, dynamic> toMap() => {
        "id": id,
        "TenentID": tenentId,
        "MYTRANSID": mytransid,
        "CustomerID": customerId,
        "planid": planid,
        "DayNumber": dayNumber,
        "TransID": transId,
        "ContractID": contractId,
        "DefaultDriverID": defaultDriverId,
        "ContractDate": contractDate,
        "WeekofDay": weekofDay,
        "StartDate": startDate,
        "EndDate": endDate,
        "TotalSubDays": totalSubDays,
        "DeliveredDays": deliveredDays,
        "NExtDeliveryDate": nExtDeliveryDate,
        "NExtDeliveryNum": nExtDeliveryNum,
        "Week1TotalCount": week1TotalCount,
        "Week1Count": week1Count,
        "Week2Count": week2Count,
        "Week2TotalCount": week2TotalCount,
        "Week3Count": week3Count,
        "Week3TotalCount": week3TotalCount,
        "Week4Count": week4Count,
        "Week4TotalCount": week4TotalCount,
        "Week5Count": week5Count,
        "Week5TotalCount": week5TotalCount,
        "ContractTotalCount": contractTotalCount,
        "ContractSelectedCount": contractSelectedCount,
        "IsFullPlanCopied": isFullPlanCopied,
        "SubscriptionOnHold": subscriptionOnHold,
        "HoldDate": holdDate,
        "UnHoldDate": unHoldDate,
        "Holdbyuser": holdbyuser,
        "HoldREmark": holdREmark,
        "SubscriptonDayNumber": subscriptonDayNumber,
        // "Total_price": totalPrice,
        "ShortRemark": shortRemark,
        "ACTIVE": active,
        // "CRUP_ID": crupId,
        "ChangesDate": changesDate,
        "DriverID": driverId,
        "CStatus": cStatus,
        "UploadDate": uploadDate,
        "Uploadby": uploadby,
        "SyncDate": syncDate,
        "Syncby": syncby,
        "SynID": synId,
        "PaymentStatus": paymentStatus,
        "syncStatus": syncStatus,
        "LocalID": localId,
        "OfflineStatus": offlineStatus,
        "Allergies": allergies,
        "Carbs": carbs,
        "Protein": protein,
        "Remarks": remarks,
      };
}
