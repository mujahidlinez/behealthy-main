class MealsModel {
  String id;
  List<Data> data;
  String message;
  int status;
  bool success;

  MealsModel({this.id, this.data, this.message, this.status, this.success});

  MealsModel.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    return data;
  }
}

class Data {
  String id;
  int tenentID;
  int lOCATIONID;
  int planid;
  int mealType;
  int dayNumer;
  int serialNo;
  int mYPRODID;
  dynamic uOM;
  int prodNo;
  String dayName;
  String productionDate;
  double calories;
  double protein;
  double carbs;
  double fat;
 double itemWeight;
  double itemCost;
  String shortRemark;
  int kitchenWeek;
  int weekOfYear;
  // int mealRepeatInDay;
  // int mealRepeatInWeek;
  // int mealRepeatInMonth;
  // int mealRepeatInYear;
  int option1;
  String option2;
  int option3;
  String option4;
  bool aCTIVE;
  int cRUPID;
  String uploadDate;
  String uploadby;
  String syncDate;
  String syncby;
  int synID;
  String shortName;
  String prodName1;
  String prodName2;
  String prodName3;
  String descToprint;
  String updateDate;
  bool isSelected;

  Data(
      {this.id,
      this.tenentID,
      this.lOCATIONID,
      this.planid,
      this.mealType,
      this.dayNumer,
      this.serialNo,
      this.mYPRODID,
      this.uOM,
      this.prodNo,
      this.dayName,
      this.productionDate,
      this.calories,
      this.protein,
      this.carbs,
      this.fat,
       this.itemWeight,
      this.itemCost,
      this.shortRemark,
      this.kitchenWeek,
      this.weekOfYear,
      // this.mealRepeatInDay,
      // this.mealRepeatInWeek,
      // this.mealRepeatInMonth,
      // this.mealRepeatInYear,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.aCTIVE,
      this.cRUPID,
      this.uploadDate,
      this.uploadby,
      this.syncDate,
      this.syncby,
      this.synID,
      this.shortName,
      this.prodName1,
      this.prodName2,
      this.prodName3,
      this.descToprint,
      this.updateDate,
      this.isSelected});

  Data.fromJson(Map<String, dynamic> json) {
    print('in parsing data ');
    id = json['$id'];
    tenentID = json['TenentID'];
    lOCATIONID = json['LOCATION_ID'];
    planid = json['planid'];
    mealType = json['MealType'];
    dayNumer = json['DayNumer'];
    serialNo = json['serial_no'];
    mYPRODID = json['MYPRODID'];
    uOM = json['UOM'];
    prodNo = json['ProdNo'];
    dayName = json['DayName'];
    productionDate = json['ProductionDate'];
    calories = json['Calories'];
    protein = json['Protein'];
    carbs = json['Carbs'];
    fat = json['Fat'];
     itemWeight = json['ItemWeight'];
      itemCost = json['Item_cost'];
    shortRemark = json['ShortRemark'];
    kitchenWeek = json['KitchenWeek'];
    weekOfYear = json['WeekOfYear'];
    // mealRepeatInDay = json['MealRepeatInDay'];
    // mealRepeatInWeek = json['MealRepeatInWeek'];
    // mealRepeatInMonth = json['MealRepeatInMonth'];
    // mealRepeatInYear = json['MealRepeatInYear'];
    option1 = json['Option1'];
    option2 = json['Option2'];
    option3 = json['Option3'];
    option4 = json['Option4'];
    aCTIVE = json['ACTIVE'];
    cRUPID = json['CRUP_ID'];
    uploadDate = json['UploadDate'];
    uploadby = json['Uploadby'];
    syncDate = json['SyncDate'];
    syncby = json['Syncby'];
    synID = json['SynID'];
    shortName = json['ShortName'];
    prodName1 = json['ProdName1'];
    prodName2 = json['ProdName2'];
    prodName3 = json['ProdName3'];
    descToprint = json['DescToprint'];
    updateDate = json['UpdateDate'];
    isSelected=false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['LOCATION_ID'] = this.lOCATIONID;
    data['planid'] = this.planid;
    data['MealType'] = this.mealType;
    data['DayNumer'] = this.dayNumer;
    data['serial_no'] = this.serialNo;
    data['MYPRODID'] = this.mYPRODID;
    data['UOM'] = this.uOM;
    data['ProdNo'] = this.prodNo;
    data['DayName'] = this.dayName;
    data['ProductionDate'] = this.productionDate;
    data['Calories'] = this.calories;
    data['Protein'] = this.protein;
    data['Carbs'] = this.carbs;
    data['Fat'] = this.fat;
    data['ItemWeight'] = this.itemWeight;
      data['Item_cost'] = this.itemCost;
    data['ShortRemark'] = this.shortRemark;
    data['KitchenWeek'] = this.kitchenWeek;
    data['WeekOfYear'] = this.weekOfYear;
    // data['MealRepeatInDay'] = this.mealRepeatInDay;
    // data['MealRepeatInWeek'] = this.mealRepeatInWeek;
    // data['MealRepeatInMonth'] = this.mealRepeatInMonth;
    // data['MealRepeatInYear'] = this.mealRepeatInYear;
    data['Option1'] = this.option1;
    data['Option2'] = this.option2;
    data['Option3'] = this.option3;
    data['Option4'] = this.option4;
    data['ACTIVE'] = this.aCTIVE;
    data['CRUP_ID'] = this.cRUPID;
    data['UploadDate'] = this.uploadDate;
    data['Uploadby'] = this.uploadby;
    data['SyncDate'] = this.syncDate;
    data['Syncby'] = this.syncby;
    data['SynID'] = this.synID;
    data['ShortName'] = this.shortName;
    data['ProdName1'] = this.prodName1;
    data['ProdName2'] = this.prodName2;
    data['ProdName3'] = this.prodName3;
    data['DescToprint'] = this.descToprint;
    data['UpdateDate'] = this.updateDate;
    return data;
  }
}
