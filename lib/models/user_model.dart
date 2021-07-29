class UserModel {
  String id;
  Data data;
  String message;
  int status;
  bool success;

  UserModel({this.id, this.data, this.message, this.status, this.success});

  UserModel.fromJson(Map<String, dynamic> json) {
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
  int tenentID;
  String cOMPNAME1;
  String eMAIL;
  String mOBPHONE;
  String cPASSWRD;
  String action;
  int cOUNTRYID;
  String sTATE;
  String gENDER;
  int cOMPID;
  Null fCNToken;

  Data(
      {this.id,
        this.tenentID,
        this.cOMPNAME1,
        this.eMAIL,
        this.mOBPHONE,
        this.cPASSWRD,
        this.action,
        this.cOUNTRYID,
        this.sTATE,
        this.gENDER,
        this.cOMPID,
        this.fCNToken});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    cOMPNAME1 = json['COMPNAME1'];
    eMAIL = json['EMAIL'];
    mOBPHONE = json['MOBPHONE'];
    cPASSWRD = json['CPASSWRD'];
    action = json['Action'];
    cOUNTRYID = json['COUNTRYID'];
    sTATE = json['STATE'];
    gENDER = json['GENDER'];
    cOMPID = json['COMPID'];
    fCNToken = json['FCNToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['COMPNAME1'] = this.cOMPNAME1;
    data['EMAIL'] = this.eMAIL;
    data['MOBPHONE'] = this.mOBPHONE;
    data['CPASSWRD'] = this.cPASSWRD;
    data['Action'] = this.action;
    data['COUNTRYID'] = this.cOUNTRYID;
    data['STATE'] = this.sTATE;
    data['GENDER'] = this.gENDER;
    data['COMPID'] = this.cOMPID;
    data['FCNToken'] = this.fCNToken;
    return data;
  }
}
