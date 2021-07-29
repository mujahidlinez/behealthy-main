class SyncOneWay4Response {
  String id;
  SyncOneWay4Model synchOneWay4Model;
  String message;
  int status;
  bool success;
  int recordCount;

  SyncOneWay4Response(
      {this.id,
        this.synchOneWay4Model,
        this.message,
        this.status,
        this.success,
        this.recordCount});

  SyncOneWay4Response.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    synchOneWay4Model = json['SynchOneWay4Model'] != null
        ? new SyncOneWay4Model.fromJson(json['SynchOneWay4Model'])
        : null;
    message = json['message'];
    status = json['status'];
    success = json['success'];
    recordCount = json['RecordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.synchOneWay4Model != null) {
      data['SynchOneWay4Model'] = this.synchOneWay4Model.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    data['RecordCount'] = this.recordCount;
    return data;
  }
}

class SyncOneWay4Model {
  String id;
  List<LstTBLCONTACTDELADRES> lstTBLCONTACTDELADRES;
  Null lstPOSCompSetup;
  Null lstPOSLocSetup;
  Null lstPOSTermSetup;
  List<Lstplanmeal> lstplanmeal;

  SyncOneWay4Model(
      {this.id,
        this.lstTBLCONTACTDELADRES,
        this.lstPOSCompSetup,
        this.lstPOSLocSetup,
        this.lstPOSTermSetup,
        this.lstplanmeal});

  SyncOneWay4Model.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    if (json['lstTBLCONTACT_DEL_ADRES'] != null) {
      lstTBLCONTACTDELADRES = new List<LstTBLCONTACTDELADRES>();
      json['lstTBLCONTACT_DEL_ADRES'].forEach((v) {
        lstTBLCONTACTDELADRES.add(new LstTBLCONTACTDELADRES.fromJson(v));
      });
    }
    lstPOSCompSetup = json['lstPOSCompSetup'];
    lstPOSLocSetup = json['lstPOSLocSetup'];
    lstPOSTermSetup = json['lstPOSTermSetup'];
    if (json['lstplanmeal'] != null) {
      lstplanmeal = new List<Lstplanmeal>();
      json['lstplanmeal'].forEach((v) {
        lstplanmeal.add(new Lstplanmeal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.lstTBLCONTACTDELADRES != null) {
      data['lstTBLCONTACT_DEL_ADRES'] =
          this.lstTBLCONTACTDELADRES.map((v) => v.toJson()).toList();
    }
    data['lstPOSCompSetup'] = this.lstPOSCompSetup;
    data['lstPOSLocSetup'] = this.lstPOSLocSetup;
    data['lstPOSTermSetup'] = this.lstPOSTermSetup;
    if (this.lstplanmeal != null) {
      data['lstplanmeal'] = this.lstplanmeal.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstTBLCONTACTDELADRES {
  String id;
  int tenentID;
  int contactMyID;
  int deliveryAdressID;
  String googleName;
  String latitute;
  String longitute;
  String contactID;
  String adressShortName1;
  String adressName1;
  String aDDR1;
  String aDDR2;
  String cITY;
  String sTATE;
  int cOUNTRYID;
  String block;
  String building;
  String street;
  String lane;
  String forFlat;
  String rEMARKS;
  int cRUPID;
  String cUSERID;
  String eNTRYDATE;
  String eNTRYTIME;
  String uPDTTIME;
  String active;
  int defualt;
  String uploadDate;
  String uploadby;
  String syncDate;
  String syncby;
  int synID;
  String syncStatus;
  int compID;
  int compLoc;
  int pACKNumber;

  LstTBLCONTACTDELADRES(
      {this.id,
        this.tenentID,
        this.contactMyID,
        this.deliveryAdressID,
        this.googleName,
        this.latitute,
        this.longitute,
        this.contactID,
        this.adressShortName1,
        this.adressName1,
        this.aDDR1,
        this.aDDR2,
        this.cITY,
        this.sTATE,
        this.cOUNTRYID,
        this.block,
        this.building,
        this.street,
        this.lane,
        this.forFlat,
        this.rEMARKS,
        this.cRUPID,
        this.cUSERID,
        this.eNTRYDATE,
        this.eNTRYTIME,
        this.uPDTTIME,
        this.active,
        this.defualt,
        this.uploadDate,
        this.uploadby,
        this.syncDate,
        this.syncby,
        this.synID,
        this.syncStatus,
        this.compID,
        this.compLoc,
        this.pACKNumber});

  LstTBLCONTACTDELADRES.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    contactMyID = json['ContactMyID'];
    deliveryAdressID = json['DeliveryAdressID'];
    googleName = json['GoogleName'];
    latitute = json['Latitute'];
    longitute = json['Longitute'];
    contactID = json['ContactID'];
    adressShortName1 = json['AdressShortName1'];
    adressName1 = json['AdressName1'];
    aDDR1 = json['ADDR1'];
    aDDR2 = json['ADDR2'];
    cITY = json['CITY'];
    sTATE = json['STATE'];
    cOUNTRYID = json['COUNTRYID'];
    block = json['Block'];
    building = json['Building'];
    street = json['Street'];
    lane = json['Lane'];
    forFlat = json['ForFlat'];
    rEMARKS = json['REMARKS'];
    cRUPID = json['CRUP_ID'];
    cUSERID = json['CUSERID'];
    eNTRYDATE = json['ENTRYDATE'];
    eNTRYTIME = json['ENTRYTIME'];
    uPDTTIME = json['UPDTTIME'];
    active = json['Active'];
    defualt = json['Defualt'];
    uploadDate = json['UploadDate'];
    uploadby = json['Uploadby'];
    syncDate = json['SyncDate'];
    syncby = json['Syncby'];
    synID = json['SynID'];
    syncStatus = json['syncStatus'];
    compID = json['CompID'];
    compLoc = json['CompLoc'];
    pACKNumber = json['PACKNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['ContactMyID'] = this.contactMyID;
    data['DeliveryAdressID'] = this.deliveryAdressID;
    data['GoogleName'] = this.googleName;
    data['Latitute'] = this.latitute;
    data['Longitute'] = this.longitute;
    data['ContactID'] = this.contactID;
    data['AdressShortName1'] = this.adressShortName1;
    data['AdressName1'] = this.adressName1;
    data['ADDR1'] = this.aDDR1;
    data['ADDR2'] = this.aDDR2;
    data['CITY'] = this.cITY;
    data['STATE'] = this.sTATE;
    data['COUNTRYID'] = this.cOUNTRYID;
    data['Block'] = this.block;
    data['Building'] = this.building;
    data['Street'] = this.street;
    data['Lane'] = this.lane;
    data['ForFlat'] = this.forFlat;
    data['REMARKS'] = this.rEMARKS;
    data['CRUP_ID'] = this.cRUPID;
    data['CUSERID'] = this.cUSERID;
    data['ENTRYDATE'] = this.eNTRYDATE;
    data['ENTRYTIME'] = this.eNTRYTIME;
    data['UPDTTIME'] = this.uPDTTIME;
    data['Active'] = this.active;
    data['Defualt'] = this.defualt;
    data['UploadDate'] = this.uploadDate;
    data['Uploadby'] = this.uploadby;
    data['SyncDate'] = this.syncDate;
    data['Syncby'] = this.syncby;
    data['SynID'] = this.synID;
    data['syncStatus'] = this.syncStatus;
    data['CompID'] = this.compID;
    data['CompLoc'] = this.compLoc;
    data['PACKNumber'] = this.pACKNumber;
    return data;
  }
}

class Lstplanmeal {
  String id;
  int tenentID;
  int lOCATIONID;
  int planid;
  int mealType;
  int uOM;
  int plandays;
  String planInGram;
  String mealInGram;
  int calories;
  int protein;
  int carbs;
  int fat;
  int itemWeight;
  int planBasecost;
  int itemBasecost;
  int itemExtraCost;
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

  Lstplanmeal(
      {this.id,
        this.tenentID,
        this.lOCATIONID,
        this.planid,
        this.mealType,
        this.uOM,
        this.plandays,
        this.planInGram,
        this.mealInGram,
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

  Lstplanmeal.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    lOCATIONID = json['LOCATION_ID'];
    planid = json['planid'];
    mealType = json['MealType'];
    uOM = json['UOM'];
    plandays = json['plandays'];
    planInGram = json['PlanInGram'];
    mealInGram = json['MealInGram'];
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
    data['PlanInGram'] = this.planInGram;
    data['MealInGram'] = this.mealInGram;
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