class MealsSyncDataModel {
  String id;
  Data data;
  String message;
  int status;
  bool success;

  MealsSyncDataModel(
      {this.id, this.data, this.message, this.status, this.success});

  MealsSyncDataModel.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    return data;
  }
}

class Data {
  String id;
  List<LstPlanmealcustinvoiceHD> lstPlanmealcustinvoiceHD;
  List<LstPlanmealcustinvoiceHD> lstPlanmealcustinvoice;
  List<LstPlanmealcustinvoiceMoreHD> lstPlanmealcustinvoiceMoreHD;
  List<LstSubscriptionsetup> lstSubscriptionsetup;
  List<LstPlanMeal> lstPlanMeal;

  Data(
      {this.id,
        this.lstPlanmealcustinvoiceHD,
        this.lstPlanmealcustinvoice,
        this.lstPlanmealcustinvoiceMoreHD,
        this.lstSubscriptionsetup,
        this.lstPlanMeal});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    if (json['lstPlanmealcustinvoiceHD'] != null) {
      lstPlanmealcustinvoiceHD = new List<LstPlanmealcustinvoiceHD>();
      json['lstPlanmealcustinvoiceHD'].forEach((v) {
        lstPlanmealcustinvoiceHD.add(new LstPlanmealcustinvoiceHD.fromJson(v));
      });
    }
    lstPlanmealcustinvoice = json['lstPlanmealcustinvoice'];
    if (json['lstPlanmealcustinvoiceMoreHD'] != null) {
      lstPlanmealcustinvoiceMoreHD = new List<LstPlanmealcustinvoiceMoreHD>();
      json['lstPlanmealcustinvoiceMoreHD'].forEach((v) {
        lstPlanmealcustinvoiceMoreHD
            .add(new LstPlanmealcustinvoiceMoreHD.fromJson(v));
      });
    }
    if (json['lstSubscriptionsetup'] != null) {
      lstSubscriptionsetup = new List<LstSubscriptionsetup>();
      json['lstSubscriptionsetup'].forEach((v) {
        lstSubscriptionsetup.add(new LstSubscriptionsetup.fromJson(v));
      });
    }
    if (json['lstPlanMeal'] != null) {
      lstPlanMeal = new List<LstPlanMeal>();
      json['lstPlanMeal'].forEach((v) {
        lstPlanMeal.add(new LstPlanMeal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.lstPlanmealcustinvoiceHD != null) {
      data['lstPlanmealcustinvoiceHD'] =
          this.lstPlanmealcustinvoiceHD.map((v) => v.toJson()).toList();
    }
    data['lstPlanmealcustinvoice'] = this.lstPlanmealcustinvoice;
    if (this.lstPlanmealcustinvoiceMoreHD != null) {
      data['lstPlanmealcustinvoiceMoreHD'] =
          this.lstPlanmealcustinvoiceMoreHD.map((v) => v.toJson()).toList();
    }
    if (this.lstSubscriptionsetup != null) {
      data['lstSubscriptionsetup'] =
          this.lstSubscriptionsetup.map((v) => v.toJson()).toList();
    }
    if (this.lstPlanMeal != null) {
      data['lstPlanMeal'] = this.lstPlanMeal.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstPlanmealcustinvoiceHD {
  String id;
  int tenentID;
  int mYTRANSID;
  int lOCATIONID;
  int customerID;
  int planid;
  int dayNumber;
  int transID;
  String contractID;
  int defaultDriverID;
  String contractDate;
  String weekofDay;
  String startDate;
  String endDate;
  double totalAmount;
  double paidAmount;
  int allowWeekend;
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
  double totalPrice;
  String shortRemark;
  bool aCTIVE;
  int cRUPID;
  String changesDate;
  int driverID;
  String cStatus;
  String uploadDate;
  String uploadby;
  String syncDate;
  String syncby;
  int synID;
  String paymentStatus;
  String syncStatus;
  int localID;
  String offlineStatus;
  String allergies;
  int carbs;
  int protein;
  String remarks;
  String updateDate;
  int uOM;
  int columndeliveredDays;
  LstPlanmealcustinvoiceHD(
      {this.id,
        this.tenentID,
        this.mYTRANSID,
        this.lOCATIONID,
        this.customerID,
        this.planid,
        this.dayNumber,
        this.transID,
        this.contractID,
        this.defaultDriverID,
        this.contractDate,
        this.weekofDay,
        this.startDate,
        this.endDate,
        this.totalAmount,
        this.paidAmount,
        this.allowWeekend,
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
        this.totalPrice,
        this.shortRemark,
        this.aCTIVE,
        this.cRUPID,
        this.changesDate,
        this.driverID,
        this.cStatus,
        this.uploadDate,
        this.uploadby,
        this.syncDate,
        this.syncby,
        this.synID,
        this.paymentStatus,
        this.syncStatus,
        this.localID,
        this.offlineStatus,
        this.allergies,
        this.carbs,
        this.protein,
        this.remarks,
        this.uOM,
        this.updateDate ,this.columndeliveredDays});

  LstPlanmealcustinvoiceHD.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    mYTRANSID = json['MYTRANSID'];
    lOCATIONID = json['LOCATION_ID'];
    customerID = json['CustomerID'];
    planid = json['planid'];
    dayNumber = json['DayNumber'];
    transID = json['TransID'];
    contractID = json['ContractID'];
    defaultDriverID = json['DefaultDriverID'];
    contractDate = json['ContractDate'];
    weekofDay = json['WeekofDay'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    totalAmount = json['TotalAmount'];
    paidAmount = json['PaidAmount'];
    allowWeekend = json['AllowWeekend'];
    totalSubDays = json['TotalSubDays'];
    deliveredDays = json['DeliveredDays'];
    nExtDeliveryDate = json['NExtDeliveryDate'];
    nExtDeliveryNum = json['NExtDeliveryNum'];
    week1TotalCount = json['Week1TotalCount'];
    week1Count = json['Week1Count'];
    week2Count = json['Week2Count'];
    week2TotalCount = json['Week2TotalCount'];
    week3Count = json['Week3Count'];
    week3TotalCount = json['Week3TotalCount'];
    week4Count = json['Week4Count'];
    week4TotalCount = json['Week4TotalCount'];
    week5Count = json['Week5Count'];
    week5TotalCount = json['Week5TotalCount'];
    contractTotalCount = json['ContractTotalCount'];
    contractSelectedCount = json['ContractSelectedCount'];
    isFullPlanCopied = json['IsFullPlanCopied'];
    subscriptionOnHold = json['SubscriptionOnHold'];
    holdDate = json['HoldDate'];
    unHoldDate = json['UnHoldDate'];
    holdbyuser = json['Holdbyuser'];
    holdREmark = json['HoldREmark'];
    subscriptonDayNumber = json['SubscriptonDayNumber'];
    totalPrice = json['Total_price'];
    shortRemark = json['ShortRemark'];
    aCTIVE = json['ACTIVE'];
    cRUPID = json['CRUP_ID'];
    changesDate = json['ChangesDate'];
    driverID = json['DriverID'];
    cStatus = json['CStatus'];
    uploadDate = json['UploadDate'];
    uploadby = json['Uploadby'];
    syncDate = json['SyncDate'];
    syncby = json['Syncby'];
    synID = json['SynID'];
    paymentStatus = json['PaymentStatus'];
    syncStatus = json['syncStatus'];
    localID = json['LocalID'];
    offlineStatus = json['OfflineStatus'];
    allergies = json['Allergies'];
    carbs = json['Carbs'];
    protein = json['Protein'];
    remarks = json['Remarks'];
    updateDate = json['UpdateDate'];
    uOM=json['uOM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['MYTRANSID'] = this.mYTRANSID;
   // data['LOCATION_ID'] = this.lOCATIONID;
    data['CustomerID'] = this.customerID;
    data['planid'] = this.planid;
    data['DayNumber'] = this.dayNumber;
    data['TransID'] = this.transID;
    data['ContractID'] = this.contractID;
    data['DefaultDriverID'] = this.defaultDriverID;
    data['ContractDate'] = this.contractDate;
    data['WeekofDay'] = this.weekofDay;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['TotalAmount'] = this.totalAmount;
    data['PaidAmount'] = this.paidAmount;
    data['AllowWeekend'] = this.allowWeekend;
    data['TotalSubDays'] = this.totalSubDays;
    data['DeliveredDays'] = this.deliveredDays;
    data['NExtDeliveryDate'] = this.nExtDeliveryDate;
    data['NExtDeliveryNum'] = this.nExtDeliveryNum;
    data['Week1TotalCount'] = this.week1TotalCount;
    data['Week1Count'] = this.week1Count;
    data['Week2Count'] = this.week2Count;
    data['Week2TotalCount'] = this.week2TotalCount;
    data['Week3Count'] = this.week3Count;
    data['Week3TotalCount'] = this.week3TotalCount;
    data['Week4Count'] = this.week4Count;
    data['Week4TotalCount'] = this.week4TotalCount;
    data['Week5Count'] = this.week5Count;
    data['Week5TotalCount'] = this.week5TotalCount;
    data['ContractTotalCount'] = this.contractTotalCount;
    data['ContractSelectedCount'] = this.contractSelectedCount;
    data['IsFullPlanCopied'] = this.isFullPlanCopied  ?1:0;
    data['SubscriptionOnHold'] = this.subscriptionOnHold ?1 :0;
    data['HoldDate'] = this.holdDate;
    data['UnHoldDate'] = this.unHoldDate;
    data['Holdbyuser'] = this.holdbyuser;
    data['HoldREmark'] = this.holdREmark;
    data['SubscriptonDayNumber'] = this.subscriptonDayNumber;
    data['totalprice'] = this.totalPrice;
    data['ShortRemark'] = this.shortRemark;
    data['ACTIVE'] = this.aCTIVE ?1:0;
    data['CRUP_ID'] = this.cRUPID;
    data['ChangesDate'] = this.changesDate;
    data['DriverID'] = this.driverID;
    data['CStatus'] = this.cStatus;
    data['UploadDate'] = this.uploadDate;
    data['Uploadby'] = this.uploadby;
    data['SyncDate'] = this.syncDate;
    data['Syncby'] = this.syncby;
    data['SynID'] = this.synID;
    data['PaymentStatus'] = this.paymentStatus;
    data['syncStatus'] = this.syncStatus;
    data['LocalID'] = this.localID;
    data['OfflineStatus'] = this.offlineStatus;
    data['Allergies'] = this.allergies;
    data['Carbs'] = this.carbs;
    data['Protein'] = this.protein;
    data['Remarks'] = this.remarks;
    data['UpdateDate'] = this.updateDate;
    data['uom'] = this.uOM;
    data['deliveredDays']=0;
    return data;
  }
}

class LstPlanmealcustinvoiceMoreHD {
  String id;
  int tenentID;
  int mYTRANSID;
  int mealType;
  int planid;
  String customized;
  int uOM;
  int totalMealAllowed;
  int weekMealAllowed;
  String planInGram;
  String mealFixFlexible;
  String mealInGram;
  double planBasecost;
  double itemBasecost;
  int baseMeal;
  int extraMeal;
  double extraMealCost;
  double amt;
  String uploadby;
  String syncby;
  int synID;
  double totalAmount;
  double paidAmount;
  int alloWeekend;
  String updateDate;
  int planDays;

  LstPlanmealcustinvoiceMoreHD(
      {this.id,
        this.tenentID,
        this.mYTRANSID,
        this.mealType,
        this.planid,
        this.customized,
        this.uOM,
        this.totalMealAllowed,
        this.weekMealAllowed,
        this.planInGram,
        this.mealFixFlexible,
        this.mealInGram,
        this.planBasecost,
        this.itemBasecost,
        this.baseMeal,
        this.extraMeal,
        this.extraMealCost,
        this.amt,
        this.uploadby,
        this.syncby,
        this.synID,
        this.totalAmount,
        this.paidAmount,
        this.alloWeekend,
        this.updateDate,
        this.planDays});

  LstPlanmealcustinvoiceMoreHD.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    mYTRANSID = json['MYTRANSID'];
    mealType = json['MealType'];
    planid = json['planid'];
    customized = json['Customized'];
    uOM = json['UOM'];
    totalMealAllowed = json['TotalMealAllowed'];
    weekMealAllowed = json['WeekMealAllowed'];
    planInGram = json['PlanInGram'];
    mealFixFlexible = json['MealFixFlexible'];
    mealInGram = json['MealInGram'];
    planBasecost = json['PlanBasecost'];
    itemBasecost = json['ItemBasecost'];
    baseMeal = json['BaseMeal'];
    extraMeal = json['ExtraMeal'];
    extraMealCost = json['ExtraMealCost'];
    amt = json['Amt'];
    uploadby = json['Uploadby'];
    syncby = json['Syncby'];
    synID = json['SynID'];
    totalAmount = json['TotalAmount'];
    paidAmount = json['PaidAmount'];
    alloWeekend = json['AlloWeekend'];
    updateDate = json['UpdateDate'];
    planDays = json['PlanDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   // data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['MYTRANSID'] = this.mYTRANSID;
    data['MealType'] = this.mealType;
    data['planid'] = this.planid;
    data['Customized'] = this.customized;
    data['UOM'] = this.uOM;
    data['TotalMealAllowed'] = this.totalMealAllowed;
    data['WeekMealAllowed'] = this.weekMealAllowed;
    data['PlanInGram'] = this.planInGram;
    data['MealFixFlexible'] = this.mealFixFlexible;
    data['MealInGram'] = this.mealInGram;
    data['PlanBasecost'] = this.planBasecost;
    data['ItemBasecost'] = this.itemBasecost;
    data['BaseMeal'] = this.baseMeal;
    data['ExtraMeal'] = this.extraMeal;
    data['ExtraMealCost'] = this.extraMealCost;
    data['Amt'] = this.amt;
    data['Uploadby'] = this.uploadby;
    data['Syncby'] = this.syncby;
    data['SynID'] = this.synID;
    data['TotalAmount'] = this.totalAmount;
    data['PaidAmount'] = this.paidAmount;
    data['AlloWeekend'] = this.alloWeekend;
    data['UpdateDate'] = this.updateDate;
    data['PlanDays'] = this.planDays;
    return data;
  }
}

class LstSubscriptionsetup {
  String id;
  int tenentID;
  int locationID;
  int localID;
  int daysInWeek;
  int displayWeek;
  int allowCopyFullPlan;
  int loadFullOrDayitem;
  int defaultDeliveryTime;
  int defaultDriverID;
  int defaultTotWeek;
  int defaultDayB4PlanStart;
  String whitchDayDelivery;
  String weekStartWithDay;
  int deliveryInDay;
  String deliveryTimeBegin;
  int changesAllowed;
  String beforeHowManyHours;
  int refundAllowed;
  String afterCompletionOfHowManyPercentageOfDelivery;
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
  int synID;
  String permsyncdate;
  String permversion;
  int setMYTRANSID;
  int cOUNTRYID;
  int lifeCycle;
  String weekHoliday;
  String updateDate;

  LstSubscriptionsetup(
      {this.id,
        this.tenentID,
        this.locationID,
        this.localID,
        this.daysInWeek,
        this.displayWeek,
        this.allowCopyFullPlan,
        this.loadFullOrDayitem,
        this.defaultDeliveryTime,
        this.defaultDriverID,
        this.defaultTotWeek,
        this.defaultDayB4PlanStart,
        this.whitchDayDelivery,
        this.weekStartWithDay,
        this.deliveryInDay,
        this.deliveryTimeBegin,
        this.changesAllowed,
        this.beforeHowManyHours,
        this.refundAllowed,
        this.afterCompletionOfHowManyPercentageOfDelivery,
        this.created,
        this.createdDate,
        this.active,
        this.deleted,
        this.kitchenRequestingStore,
        this.mainStore,
        this.incomingKitchenAutoAccept,
        this.planImageLocation,
        this.mealimageLocation,
        this.uploadDate,
        this.uploadby,
        this.syncDate,
        this.syncby,
        this.synID,
        this.permsyncdate,
        this.permversion,
        this.setMYTRANSID,
        this.cOUNTRYID,
        this.lifeCycle,
        this.weekHoliday,
        this.updateDate});

  LstSubscriptionsetup.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    locationID = json['locationID'];
    localID = json['LocalID'];
    daysInWeek = json['days_in_week'];
    displayWeek = json['DisplayWeek'];
    allowCopyFullPlan = json['AllowCopyFullPlan'];
    loadFullOrDayitem = json['LoadFullOrDayitem'];
    defaultDeliveryTime = json['DefaultDeliveryTime'];
    defaultDriverID = json['DefaultDriverID'];
    defaultTotWeek = json['DefaultTotWeek'];
    defaultDayB4PlanStart = json['DefaultDayB4PlanStart'];
    whitchDayDelivery = json['Whitch_day_delivery'];
    weekStartWithDay = json['Week_Start_With_Day'];
    deliveryInDay = json['Delivery_in_day'];
    deliveryTimeBegin = json['Delivery_time_begin'];
    changesAllowed = json['Changes_Allowed'];
    beforeHowManyHours = json['Before_how_many_Hours'];
    refundAllowed = json['Refund_Allowed'];
    afterCompletionOfHowManyPercentageOfDelivery =
    json['After_Completion_of_how_many_Percentage_of_Delivery'];
    created = json['Created'];
    createdDate = json['CreatedDate'];
    active = json['Active'];
    deleted = json['Deleted'];
    kitchenRequestingStore = json['KitchenRequestingStore'];
    mainStore = json['MainStore'];
    incomingKitchenAutoAccept = json['IncomingKitchenAutoAccept'];
    planImageLocation = json['planImageLocation'];
    mealimageLocation = json['mealimageLocation'];
    uploadDate = json['UploadDate'];
    uploadby = json['Uploadby'];
    syncDate = json['SyncDate'];
    syncby = json['Syncby'];
    synID = json['SynID'];
    permsyncdate = json['permsyncdate'];
    permversion = json['permversion'];
    setMYTRANSID = json['SetMYTRANSID'];
    cOUNTRYID = json['COUNTRYID'];
    lifeCycle = json['LifeCycle'];
    weekHoliday = json['Week_Holiday'];
    updateDate = json['UpdateDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['locationID'] = this.locationID;
    data['LocalID'] = this.localID;
    data['days_in_week'] = this.daysInWeek;
    data['DisplayWeek'] = this.displayWeek;
    data['AllowCopyFullPlan'] = this.allowCopyFullPlan;
    data['LoadFullOrDayitem'] = this.loadFullOrDayitem;
    data['DefaultDeliveryTime'] = this.defaultDeliveryTime;
    data['DefaultDriverID'] = this.defaultDriverID;
    data['DefaultTotWeek'] = this.defaultTotWeek;
    data['DefaultDayB4PlanStart'] = this.defaultDayB4PlanStart;
    data['Whitch_day_delivery'] = this.whitchDayDelivery;
    data['Week_Start_With_Day'] = this.weekStartWithDay;
    data['Delivery_in_day'] = this.deliveryInDay;
    data['Delivery_time_begin'] = this.deliveryTimeBegin;
    data['Changes_Allowed'] = this.changesAllowed;
    data['Before_how_many_Hours'] = this.beforeHowManyHours;
    data['Refund_Allowed'] = this.refundAllowed;
    data['After_Completion_of_how_many_Percentage_of_Delivery'] =
        this.afterCompletionOfHowManyPercentageOfDelivery;
    data['Created'] = this.created;
    data['CreatedDate'] = this.createdDate;
    data['Active'] = this.active;
    data['Deleted'] = this.deleted;
    data['KitchenRequestingStore'] = this.kitchenRequestingStore;
    data['MainStore'] = this.mainStore;
    data['IncomingKitchenAutoAccept'] = this.incomingKitchenAutoAccept;
    data['planImageLocation'] = this.planImageLocation;
    data['mealimageLocation'] = this.mealimageLocation;
    data['UploadDate'] = this.uploadDate;
    data['Uploadby'] = this.uploadby;
    data['SyncDate'] = this.syncDate;
    data['Syncby'] = this.syncby;
    data['SynID'] = this.synID;
    data['permsyncdate'] = this.permsyncdate;
    data['permversion'] = this.permversion;
    data['SetMYTRANSID'] = this.setMYTRANSID;
    data['COUNTRYID'] = this.cOUNTRYID;
    data['LifeCycle'] = this.lifeCycle;
    data['Week_Holiday'] = this.weekHoliday;
    data['UpdateDate'] = this.updateDate;
    return data;
  }
}

class LstPlanMeal {
  String id;
  int tenentID;
  int lOCATIONID;
  int planid;
  int mealType;
  int uOM;
  int plandays;
  Null customAllow;
  String planInGram;
  String mealInGram;
  Null groupID;
  Null groupName;
  Null plandesc;
  double calories;
  double protein;
  double carbs;
  double fat;
  double itemWeight;
  double planBasecost;
  double itemBasecost;
  double itemExtraCost;
  String shortRemark;
  String mealFixFlexible;
  int mealAllowed;
  int switch1;
  String switch2;
  String switch3;
  int aCTIVE;
  int cRUPID;
  String changesDate;
  String uploadDate;
  String uploadby;
  String syncDate;
  String syncby;
  int synID;
  String updateDate;

  LstPlanMeal(
      {this.id,
        this.tenentID,
        this.lOCATIONID,
        this.planid,
        this.mealType,
        this.uOM,
        this.plandays,
        this.customAllow,
        this.planInGram,
        this.mealInGram,
        this.groupID,
        this.groupName,
        this.plandesc,
        this.calories,
        this.protein,
        this.carbs,
        this.fat,
        this.itemWeight,
        this.planBasecost,
        this.itemBasecost,
        this.itemExtraCost,
        this.shortRemark,
        this.mealFixFlexible,
        this.mealAllowed,
        this.switch1,
        this.switch2,
        this.switch3,
        this.aCTIVE,
        this.cRUPID,
        this.changesDate,
        this.uploadDate,
        this.uploadby,
        this.syncDate,
        this.syncby,
        this.synID,
        this.updateDate});

  LstPlanMeal.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    lOCATIONID = json['LOCATION_ID'];
    planid = json['planid'];
    mealType = json['MealType'];
    uOM = json['UOM'];
    plandays = json['plandays'];
    customAllow = json['CustomAllow'];
    planInGram = json['PlanInGram'];
    mealInGram = json['MealInGram'];
    groupID = json['GroupID'];
    groupName = json['GroupName'];
    plandesc = json['plandesc'];
    calories = json['Calories'];
    protein = json['Protein'];
    carbs = json['Carbs'];
    fat = json['Fat'];
    itemWeight = json['ItemWeight'];
    planBasecost = json['PlanBasecost'];
    itemBasecost = json['ItemBasecost'];
    itemExtraCost = json['ItemExtraCost'];
    shortRemark = json['ShortRemark'];
    mealFixFlexible = json['MealFixFlexible'];
    mealAllowed = json['MealAllowed'];
    switch1 = json['switch1'];
    switch2 = json['switch2'];
    switch3 = json['switch3'];
    aCTIVE = json['ACTIVE'];
    cRUPID = json['CRUP_ID'];
    changesDate = json['ChangesDate'];
    uploadDate = json['UploadDate'];
    uploadby = json['Uploadby'];
    syncDate = json['SyncDate'];
    syncby = json['Syncby'];
    synID = json['SynID'];
    updateDate = json['UpdateDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['LOCATION_ID'] = this.lOCATIONID;
    data['planid'] = this.planid;
    data['MealType'] = this.mealType;
    data['UOM'] = this.uOM;
    data['plandays'] = this.plandays;
    data['CustomAllow'] = this.customAllow;
    data['PlanInGram'] = this.planInGram;
    data['MealInGram'] = this.mealInGram;
    data['GroupID'] = this.groupID;
    data['GroupName'] = this.groupName;
    data['plandesc'] = this.plandesc;
    data['Calories'] = this.calories;
    data['Protein'] = this.protein;
    data['Carbs'] = this.carbs;
    data['Fat'] = this.fat;
    data['ItemWeight'] = this.itemWeight;
    data['PlanBasecost'] = this.planBasecost;
    data['ItemBasecost'] = this.itemBasecost;
    data['ItemExtraCost'] = this.itemExtraCost;
    data['ShortRemark'] = this.shortRemark;
    data['MealFixFlexible'] = this.mealFixFlexible;
    data['MealAllowed'] = this.mealAllowed;
    data['switch1'] = this.switch1;
    data['switch2'] = this.switch2;
    data['switch3'] = this.switch3;
    data['ACTIVE'] = this.aCTIVE;
    data['CRUP_ID'] = this.cRUPID;
    data['ChangesDate'] = this.changesDate;
    data['UploadDate'] = this.uploadDate;
    data['Uploadby'] = this.uploadby;
    data['SyncDate'] = this.syncDate;
    data['Syncby'] = this.syncby;
    data['SynID'] = this.synID;
    data['UpdateDate'] = this.updateDate;
    return data;
  }
}
