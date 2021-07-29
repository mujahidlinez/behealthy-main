import 'package:behealthy/providers/dashboard_items_dbprovider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'database/dbhelper.dart';

const int TenentID = 14;

class BeHealthyTheme {
  static const kMainOrange = Color(0xffFF9629);
  static const kLightOrange = Color(0xffFFEDDB);
  static const kInsideCard = Color(0xffEAEAEA);
  static TextStyle kMainTextStyle = GoogleFonts.montserrat(
      color: BeHealthyTheme.kMainOrange,
      fontSize: 15,
      fontWeight: FontWeight.bold);
  static TextStyle kInputFieldTextStyle = GoogleFonts.montserrat(
    color: BeHealthyTheme.kMainOrange,
    fontSize: 15,
  );

  static TextStyle kProfileFont = GoogleFonts.lato(
    color: Color(0xff707070),
    fontSize: 12,
  );

  static TextStyle kDhaaTextStyle = GoogleFonts.lato(
      color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold);
  static TextStyle kDeliverToStyle = GoogleFonts.montserrat(
      fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black);
  static TextStyle kAddressStyle = GoogleFonts.montserrat(
      fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black);
}

class SubscriptionSetup {
  int tenentId;
  int locationId;
  int localId;
  int daysInWeek;
  int displayWeek;
  String allowCopyFullPlan;
  int loadFullOrDayitem;
  int defaultDeliveryTime;
  int defaultDriverId;
  int defaultTotWeek;
  int defaultDayB4PlanStart;
  String whitchDayDelivery;
  String weekStartWithDay;
  int deliveryInDay;
  String deliveryTimeBegin;
  int changesAllowed;
  String beforeHowManyHours;
  int refundAllowed;
  int afterCompletionOfHowManyPercentageOfDelivery;
  int created;
  String createdDate;
  int active;
  int deleted;
  String kitchenRequestingStore;
  String mainStore;
  int incomingKitchenAutoAccept;
  String planImageLocation;
  String mealimageLocation;
  String uploadDate;
  String uploadby;
  String syncDate;
  String syncby;
  int synId;
  String permsyncdate;
  String permversion;
  int setMytransid;
  int countryid;
  int lifeCycle;
  String weekHoliday;
  SubscriptionSetup({
    this.afterCompletionOfHowManyPercentageOfDelivery,
    this.allowCopyFullPlan,
    this.beforeHowManyHours,
    this.changesAllowed,
    this.countryid,
    this.created,
    this.createdDate,
    this.daysInWeek,
    this.defaultDayB4PlanStart,
    this.defaultDeliveryTime,
    this.defaultDriverId,
    this.defaultTotWeek,
    this.deleted,
    this.deliveryInDay,
    this.deliveryTimeBegin,
    this.incomingKitchenAutoAccept,
    this.kitchenRequestingStore,
    this.lifeCycle,
    this.loadFullOrDayitem,
    this.mainStore,
    this.mealimageLocation,
    this.permsyncdate,
    this.permversion,
    this.planImageLocation,
    this.refundAllowed,
    this.setMytransid,
    this.weekHoliday,
    this.weekStartWithDay,
    this.whitchDayDelivery,
  });
  initializeData() async {
    final DatabaseHelper dbHelper = DatabaseHelper.instance;
    final rows = await dbHelper.querySubscriptionSetup();
    tenentId = rows["TenentID"];
    locationId = rows["locationID"];
    localId = rows["LocalID"];
    daysInWeek = rows["days_in_week"];
    displayWeek = rows["DisplayWeek"];
    allowCopyFullPlan = rows["AllowCopyFullPlan"];
    loadFullOrDayitem = rows["LoadFullOrDayitem"];
    defaultDeliveryTime = rows["DefaultDeliveryTime"];
    defaultDriverId = rows["DefaultDriverID"];
    defaultTotWeek = rows["DefaultTotWeek"];
    defaultDayB4PlanStart = rows["DefaultDayB4PlanStart"];
    whitchDayDelivery = rows["Whitch_day_delivery"];
    weekStartWithDay = rows["Week_Start_With_Day"];
    deliveryInDay = rows["Delivery_in_day"];
    deliveryTimeBegin = rows["Delivery_time_begin"];
    changesAllowed = rows["Changes_Allowed"];
    beforeHowManyHours = rows["Before_how_many_Hours"];
    refundAllowed = rows["Refund_Allowed"];
    afterCompletionOfHowManyPercentageOfDelivery =
        rows["After_Completion_of_how_many_Percentage_of_Delivery"];
    created = rows["Created"];
    createdDate = rows["CreatedDate"];
    active = rows["Active"];
    deleted = rows["Deleted"];
    kitchenRequestingStore = rows["KitchenRequestingStore"];
    mainStore = rows["MainStore"];
    incomingKitchenAutoAccept = rows["IncomingKitchenAutoAccept"];
    planImageLocation = rows["planImageLocation"];
    mealimageLocation = rows["mealimageLocation"];
    uploadDate = rows["UploadDate"];
    uploadby = rows["Uploadby"];
    syncDate = rows["SyncDate"];
    syncby = rows["Syncby"];
    synId = rows["SynID"];
    permsyncdate = rows["permsyncdate"];
    permversion = rows["permversion"];
    setMytransid = rows["SetMYTRANSID"];
    countryid = rows["COUNTRYID"];
    lifeCycle = rows["LifeCycle"];
    weekHoliday = rows["Week_Holiday"];
  }
}
