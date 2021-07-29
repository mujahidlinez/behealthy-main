


class SyncOneWay2Response {
  String id;
  SyncOneWay2Model syncOneWay2Model;
  String message;
  int status;
  bool success;
  int recordCount;

  SyncOneWay2Response(
      {this.id,
        this.syncOneWay2Model,
        this.message,
        this.status,
        this.success,
        this.recordCount});

  SyncOneWay2Response.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    syncOneWay2Model = json['data'] != null ? new SyncOneWay2Model.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
    success = json['success'];
    recordCount = json['RecordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.syncOneWay2Model != null) {
      data['data'] = this.syncOneWay2Model.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    data['RecordCount'] = this.recordCount;
    return data;
  }
}

class SyncOneWay2Model {
  String id;
  List<LstTBLPRODDTL> lstTBLPRODDTL;
  List<LstTBLOFFERPROD> lstTBLOFFERPROD;
  List<LstICPRODDISPLAY> lstICPRODDISPLAY;
  List<LstTBLCOUNTRY> lstTBLCOUNTRY;
  List<LsttblCityStatesCounty> lsttblCityStatesCounty;
  List<LstRefTable> lstRefTable;

  SyncOneWay2Model(
      {this.id,
        this.lstTBLPRODDTL,
        this.lstTBLOFFERPROD,
        this.lstICPRODDISPLAY,
        this.lstTBLCOUNTRY,
        this.lsttblCityStatesCounty,
        this.lstRefTable});

  SyncOneWay2Model.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    if (json['lstTBLPRODDTL'] != null) {
      lstTBLPRODDTL = new List<LstTBLPRODDTL>();
      json['lstTBLPRODDTL'].forEach((v) {
        lstTBLPRODDTL.add(new LstTBLPRODDTL.fromJson(v));
      });
    }
    if (json['lstTBLOFFERPROD'] != null) {
      lstTBLOFFERPROD = new List<LstTBLOFFERPROD>();
      json['lstTBLOFFERPROD'].forEach((v) {
        lstTBLOFFERPROD.add(new LstTBLOFFERPROD.fromJson(v));
      });
    }
    if (json['lstICPRODDISPLAY'] != null) {
      lstICPRODDISPLAY = new List<LstICPRODDISPLAY>();
      json['lstICPRODDISPLAY'].forEach((v) {
        lstICPRODDISPLAY.add(new LstICPRODDISPLAY.fromJson(v));
      });
    }
    if (json['lstTBLCOUNTRY'] != null) {
      lstTBLCOUNTRY = new List<LstTBLCOUNTRY>();
      json['lstTBLCOUNTRY'].forEach((v) {
        lstTBLCOUNTRY.add(new LstTBLCOUNTRY.fromJson(v));
      });
    }
    if (json['lsttblCityStatesCounty'] != null) {
      lsttblCityStatesCounty = new List<LsttblCityStatesCounty>();
      json['lsttblCityStatesCounty'].forEach((v) {
        lsttblCityStatesCounty.add(new LsttblCityStatesCounty.fromJson(v));
      });
    }
    if (json['lstRefTable'] != null) {
      lstRefTable = new List<LstRefTable>();
      json['lstRefTable'].forEach((v) {
        lstRefTable.add(new LstRefTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.lstTBLPRODDTL != null) {
      data['lstTBLPRODDTL'] =
          this.lstTBLPRODDTL.map((v) => v.toJson()).toList();
    }
    if (this.lstTBLOFFERPROD != null) {
      data['lstTBLOFFERPROD'] =
          this.lstTBLOFFERPROD.map((v) => v.toJson()).toList();
    }
    if (this.lstICPRODDISPLAY != null) {
      data['lstICPRODDISPLAY'] =
          this.lstICPRODDISPLAY.map((v) => v.toJson()).toList();
    }
    if (this.lstTBLCOUNTRY != null) {
      data['lstTBLCOUNTRY'] =
          this.lstTBLCOUNTRY.map((v) => v.toJson()).toList();
    }
    if (this.lsttblCityStatesCounty != null) {
      data['lsttblCityStatesCounty'] =
          this.lsttblCityStatesCounty.map((v) => v.toJson()).toList();
    }
    if (this.lstRefTable != null) {
      data['lstRefTable'] = this.lstRefTable.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstTBLPRODDTL {
  String id;
  int tenentID;
  int mYPRODID;
  String oVERVIEW;
  String fEATURES;
  String sPECIFICATIONS;
  String fAQDOWNLOAD;
  String rEMARKS;
  int aCTIVE;
  int cRUPID;
  int cOMPANYID;
  String lINK2DIRECT;
  String keywords;
  String boxshot;
  String largeBoxshot;
  String mediumBoxshot;
  String smallBoxshot;
  String osPlatform;
  String corpLogo;
  String link;
  String trialUrl;
  String cartLink;
  String productDetailLink;
  String lead;
  String other;
  String promotionType;
  String payout;
  String ladingPage;

  LstTBLPRODDTL(
      {this.id,
        this.tenentID,
        this.mYPRODID,
        this.oVERVIEW,
        this.fEATURES,
        this.sPECIFICATIONS,
        this.fAQDOWNLOAD,
        this.rEMARKS,
        this.aCTIVE,
        this.cRUPID,
        this.cOMPANYID,
        this.lINK2DIRECT,
        this.keywords,
        this.boxshot,
        this.largeBoxshot,
        this.mediumBoxshot,
        this.smallBoxshot,
        this.osPlatform,
        this.corpLogo,
        this.link,
        this.trialUrl,
        this.cartLink,
        this.productDetailLink,
        this.lead,
        this.other,
        this.promotionType,
        this.payout,
        this.ladingPage});

  LstTBLPRODDTL.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    mYPRODID = json['MYPRODID'];
    oVERVIEW = json['OVERVIEW'];
    fEATURES = json['FEATURES'];
    sPECIFICATIONS = json['SPECIFICATIONS'];
    fAQDOWNLOAD = json['FAQ_DOWNLOAD'];
    rEMARKS = json['REMARKS'];
    aCTIVE = json['ACTIVE'];
    cRUPID = json['CRUP_ID'];
    cOMPANYID = json['COMPANYID'];
    lINK2DIRECT = json['LINK2DIRECT'];
    keywords = json['keywords'];
    boxshot = json['boxshot'];
    largeBoxshot = json['large_boxshot'];
    mediumBoxshot = json['medium_boxshot'];
    smallBoxshot = json['small_boxshot'];
    osPlatform = json['os_platform'];
    corpLogo = json['corp_logo'];
    link = json['link'];
    trialUrl = json['trial_url'];
    cartLink = json['cart_link'];
    productDetailLink = json['product_detail_link'];
    lead = json['lead'];
    other = json['other'];
    promotionType = json['promotion_type'];
    payout = json['payout'];
    ladingPage = json['lading_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['MYPRODID'] = this.mYPRODID;
    data['OVERVIEW'] = this.oVERVIEW;
    data['FEATURES'] = this.fEATURES;
    data['SPECIFICATIONS'] = this.sPECIFICATIONS;
    data['FAQ_DOWNLOAD'] = this.fAQDOWNLOAD;
    data['REMARKS'] = this.rEMARKS;
    data['ACTIVE'] = this.aCTIVE;
    data['CRUP_ID'] = this.cRUPID;
    data['COMPANYID'] = this.cOMPANYID;
    data['LINK2DIRECT'] = this.lINK2DIRECT;
    data['keywords'] = this.keywords;
    data['boxshot'] = this.boxshot;
    data['large_boxshot'] = this.largeBoxshot;
    data['medium_boxshot'] = this.mediumBoxshot;
    data['small_boxshot'] = this.smallBoxshot;
    data['os_platform'] = this.osPlatform;
    data['corp_logo'] = this.corpLogo;
    data['link'] = this.link;
    data['trial_url'] = this.trialUrl;
    data['cart_link'] = this.cartLink;
    data['product_detail_link'] = this.productDetailLink;
    data['lead'] = this.lead;
    data['other'] = this.other;
    data['promotion_type'] = this.promotionType;
    data['payout'] = this.payout;
    data['lading_page'] = this.ladingPage;
    return data;
  }
}

class LstTBLOFFERPROD {
  String id;
  int tenentID;
  int mYPRODID;
  int rEFID;
  String rEFTYPE;
  String rEFSUBTYPE;
  int mYID;
  String dISPDATE3;
  String fROMDATE;
  int iNTERVAL;
  String tILLDATE;
  String rEMARKS;
  int sORTNUMBER;
  int dISPLAYID;
  int aCTIVE;
  int cRUPID;
  int cOMPANYID;
  int pLACEHOLDERLINE;
  int pLACEHOLDERCOLUMN;
  int pLACEHOLDERALIRL;
  String lINK2DIRECT;
  String tODATE;
  int oeledPrice;
  int discount;
  int newPrice;
  int offerID;
  int devlperActive;

  LstTBLOFFERPROD(
      {this.id,
        this.tenentID,
        this.mYPRODID,
        this.rEFID,
        this.rEFTYPE,
        this.rEFSUBTYPE,
        this.mYID,
        this.dISPDATE3,
        this.fROMDATE,
        this.iNTERVAL,
        this.tILLDATE,
        this.rEMARKS,
        this.sORTNUMBER,
        this.dISPLAYID,
        this.aCTIVE,
        this.cRUPID,
        this.cOMPANYID,
        this.pLACEHOLDERLINE,
        this.pLACEHOLDERCOLUMN,
        this.pLACEHOLDERALIRL,
        this.lINK2DIRECT,
        this.tODATE,
        this.oeledPrice,
        this.discount,
        this.newPrice,
        this.offerID,
        this.devlperActive});

  LstTBLOFFERPROD.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    mYPRODID = json['MYPRODID'];
    rEFID = json['REFID'];
    rEFTYPE = json['REFTYPE'];
    rEFSUBTYPE = json['REFSUBTYPE'];
    mYID = json['MYID'];
    dISPDATE3 = json['DISPDATE3'];
    fROMDATE = json['FROMDATE'];
    iNTERVAL = json['INTERVAL'];
    tILLDATE = json['TILLDATE'];
    rEMARKS = json['REMARKS'];
    sORTNUMBER = json['SORTNUMBER'];
    dISPLAYID = json['DISPLAY_ID'];
    aCTIVE = json['ACTIVE'];
    cRUPID = json['CRUP_ID'];
    cOMPANYID = json['COMPANYID'];
    pLACEHOLDERLINE = json['PLACEHOLDERLINE'];
    pLACEHOLDERCOLUMN = json['PLACEHOLDERCOLUMN'];
    pLACEHOLDERALIRL = json['PLACEHOLDERALIRL'];
    lINK2DIRECT = json['LINK2DIRECT'];
    tODATE = json['TODATE'];
    oeledPrice = json['OeledPrice'];
    discount = json['Discount'];
    newPrice = json['NewPrice'];
    offerID = json['OfferID'];
    devlperActive = json['DevlperActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['MYPRODID'] = this.mYPRODID;
    data['REFID'] = this.rEFID;
    data['REFTYPE'] = this.rEFTYPE;
    data['REFSUBTYPE'] = this.rEFSUBTYPE;
    data['MYID'] = this.mYID;
    data['DISPDATE3'] = this.dISPDATE3;
    data['FROMDATE'] = this.fROMDATE;
    data['INTERVAL'] = this.iNTERVAL;
    data['TILLDATE'] = this.tILLDATE;
    data['REMARKS'] = this.rEMARKS;
    data['SORTNUMBER'] = this.sORTNUMBER;
    data['DISPLAY_ID'] = this.dISPLAYID;
    data['ACTIVE'] = this.aCTIVE;
    data['CRUP_ID'] = this.cRUPID;
    data['COMPANYID'] = this.cOMPANYID;
    data['PLACEHOLDERLINE'] = this.pLACEHOLDERLINE;
    data['PLACEHOLDERCOLUMN'] = this.pLACEHOLDERCOLUMN;
    data['PLACEHOLDERALIRL'] = this.pLACEHOLDERALIRL;
    data['LINK2DIRECT'] = this.lINK2DIRECT;
    data['TODATE'] = this.tODATE;
    data['OeledPrice'] = this.oeledPrice;
    data['Discount'] = this.discount;
    data['NewPrice'] = this.newPrice;
    data['OfferID'] = this.offerID;
    data['DevlperActive'] = this.devlperActive;
    return data;
  }
}

class LstICPRODDISPLAY {
  String id;
  int tenentID;
  int mYPRODID;
  int displayId;
  String tableName;
  int rEFID;
  String rEFTYPE;
  String rEFSUBTYPE;
  int sortnumber;
  int pLACEHOLDERLINE;
  int pLACEHOLDERCOLUMN;
  int pLACEHOLDERALIRL;
  String lINK2DIRECT;
  int aCTIVE2;
  int cRUPID;

  LstICPRODDISPLAY(
      {this.id,
        this.tenentID,
        this.mYPRODID,
        this.displayId,
        this.tableName,
        this.rEFID,
        this.rEFTYPE,
        this.rEFSUBTYPE,
        this.sortnumber,
        this.pLACEHOLDERLINE,
        this.pLACEHOLDERCOLUMN,
        this.pLACEHOLDERALIRL,
        this.lINK2DIRECT,
        this.aCTIVE2,
        this.cRUPID});

  LstICPRODDISPLAY.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    mYPRODID = json['MYPRODID'];
    displayId = json['Display_Id'];
    tableName = json['TableName'];
    rEFID = json['REFID'];
    rEFTYPE = json['REFTYPE'];
    rEFSUBTYPE = json['REFSUBTYPE'];
    sortnumber = json['sortnumber'];
    pLACEHOLDERLINE = json['PLACEHOLDERLINE'];
    pLACEHOLDERCOLUMN = json['PLACEHOLDERCOLUMN'];
    pLACEHOLDERALIRL = json['PLACEHOLDERALIRL'];
    lINK2DIRECT = json['LINK2DIRECT'];
    aCTIVE2 = json['ACTIVE2'];
    cRUPID = json['CRUP_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['MYPRODID'] = this.mYPRODID;
    data['Display_Id'] = this.displayId;
    data['TableName'] = this.tableName;
    data['REFID'] = this.rEFID;
    data['REFTYPE'] = this.rEFTYPE;
    data['REFSUBTYPE'] = this.rEFSUBTYPE;
    data['sortnumber'] = this.sortnumber;
    data['PLACEHOLDERLINE'] = this.pLACEHOLDERLINE;
    data['PLACEHOLDERCOLUMN'] = this.pLACEHOLDERCOLUMN;
    data['PLACEHOLDERALIRL'] = this.pLACEHOLDERALIRL;
    data['LINK2DIRECT'] = this.lINK2DIRECT;
    data['ACTIVE2'] = this.aCTIVE2;
    data['CRUP_ID'] = this.cRUPID;
    return data;
  }
}

class LstTBLCOUNTRY {
  String id;
  int tenentID;
  int cOUNTRYID;
  String rEGION1;
  String cOUNAME1;
  String cOUNAME2;
  String cOUNAME3;
  String cAPITAL;
  String nATIONALITY1;
  String nATIONALITY2;
  String nATIONALITY3;
  String cURRENCYNAME1;
  String cURRENCYNAME2;
  String cURRENCYNAME3;
  String cURRENTCONVRATE;
  String cURRENCYSHORTNAME1;
  String cURRENCYSHORTNAME2;
  String cURRENCYSHORTNAME3;
  String countryType;
  String countryTSubType;
  String sovereignty;
  String iSO4217CurCode;
  String iSO4217CurName;
  String iTUTTelephoneCode;
  int faxLength;
  int telLength;
  String iSO316612LetterCode;
  String iSO316613LetterCode;
  String iSO31661Number;
  String iANACountryCodeTLD;
  String active;
  int cRUPID;
  String uploadDate;
  String uploadby;
  String syncDate;
  String syncby;
  int synID;

  LstTBLCOUNTRY(
      {this.id,
        this.tenentID,
        this.cOUNTRYID,
        this.rEGION1,
        this.cOUNAME1,
        this.cOUNAME2,
        this.cOUNAME3,
        this.cAPITAL,
        this.nATIONALITY1,
        this.nATIONALITY2,
        this.nATIONALITY3,
        this.cURRENCYNAME1,
        this.cURRENCYNAME2,
        this.cURRENCYNAME3,
        this.cURRENTCONVRATE,
        this.cURRENCYSHORTNAME1,
        this.cURRENCYSHORTNAME2,
        this.cURRENCYSHORTNAME3,
        this.countryType,
        this.countryTSubType,
        this.sovereignty,
        this.iSO4217CurCode,
        this.iSO4217CurName,
        this.iTUTTelephoneCode,
        this.faxLength,
        this.telLength,
        this.iSO316612LetterCode,
        this.iSO316613LetterCode,
        this.iSO31661Number,
        this.iANACountryCodeTLD,
        this.active,
        this.cRUPID,
        this.uploadDate,
        this.uploadby,
        this.syncDate,
        this.syncby,
        this.synID});

  LstTBLCOUNTRY.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    cOUNTRYID = json['COUNTRYID'];
    rEGION1 = json['REGION1'];
    cOUNAME1 = json['COUNAME1'];
    cOUNAME2 = json['COUNAME2'];
    cOUNAME3 = json['COUNAME3'];
    cAPITAL = json['CAPITAL'];
    nATIONALITY1 = json['NATIONALITY1'];
    nATIONALITY2 = json['NATIONALITY2'];
    nATIONALITY3 = json['NATIONALITY3'];
    cURRENCYNAME1 = json['CURRENCYNAME1'];
    cURRENCYNAME2 = json['CURRENCYNAME2'];
    cURRENCYNAME3 = json['CURRENCYNAME3'];
    cURRENTCONVRATE = json['CURRENTCONVRATE'];
    cURRENCYSHORTNAME1 = json['CURRENCYSHORTNAME1'];
    cURRENCYSHORTNAME2 = json['CURRENCYSHORTNAME2'];
    cURRENCYSHORTNAME3 = json['CURRENCYSHORTNAME3'];
    countryType = json['CountryType'];
    countryTSubType = json['CountryTSubType'];
    sovereignty = json['Sovereignty'];
    iSO4217CurCode = json['ISO4217CurCode'];
    iSO4217CurName = json['ISO4217CurName'];
    iTUTTelephoneCode = json['ITUTTelephoneCode'];
    faxLength = json['FaxLength'];
    telLength = json['TelLength'];
    iSO316612LetterCode = json['ISO3166_1_2LetterCode'];
    iSO316613LetterCode = json['ISO3166_1_3LetterCode'];
    iSO31661Number = json['ISO3166_1Number'];
    iANACountryCodeTLD = json['IANACountryCodeTLD'];
    active = json['Active'];
    cRUPID = json['CRUP_ID'];
    uploadDate = json['UploadDate'];
    uploadby = json['Uploadby'];
    syncDate = json['SyncDate'];
    syncby = json['Syncby'];
    synID = json['SynID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['COUNTRYID'] = this.cOUNTRYID;
    data['REGION1'] = this.rEGION1;
    data['COUNAME1'] = this.cOUNAME1;
    data['COUNAME2'] = this.cOUNAME2;
    data['COUNAME3'] = this.cOUNAME3;
    data['CAPITAL'] = this.cAPITAL;
    data['NATIONALITY1'] = this.nATIONALITY1;
    data['NATIONALITY2'] = this.nATIONALITY2;
    data['NATIONALITY3'] = this.nATIONALITY3;
    data['CURRENCYNAME1'] = this.cURRENCYNAME1;
    data['CURRENCYNAME2'] = this.cURRENCYNAME2;
    data['CURRENCYNAME3'] = this.cURRENCYNAME3;
    data['CURRENTCONVRATE'] = this.cURRENTCONVRATE;
    data['CURRENCYSHORTNAME1'] = this.cURRENCYSHORTNAME1;
    data['CURRENCYSHORTNAME2'] = this.cURRENCYSHORTNAME2;
    data['CURRENCYSHORTNAME3'] = this.cURRENCYSHORTNAME3;
    data['CountryType'] = this.countryType;
    data['CountryTSubType'] = this.countryTSubType;
    data['Sovereignty'] = this.sovereignty;
    data['ISO4217CurCode'] = this.iSO4217CurCode;
    data['ISO4217CurName'] = this.iSO4217CurName;
    data['ITUTTelephoneCode'] = this.iTUTTelephoneCode;
    data['FaxLength'] = this.faxLength;
    data['TelLength'] = this.telLength;
    data['ISO3166_1_2LetterCode'] = this.iSO316612LetterCode;
    data['ISO3166_1_3LetterCode'] = this.iSO316613LetterCode;
    data['ISO3166_1Number'] = this.iSO31661Number;
    data['IANACountryCodeTLD'] = this.iANACountryCodeTLD;
    data['Active'] = this.active;
    data['CRUP_ID'] = this.cRUPID;
    data['UploadDate'] = this.uploadDate;
    data['Uploadby'] = this.uploadby;
    data['SyncDate'] = this.syncDate;
    data['Syncby'] = this.syncby;
    data['SynID'] = this.synID;
    return data;
  }
}

class LsttblCityStatesCounty {
  String id;
  int cityID;
  int stateID;
  int cOUNTRYID;
  String cityEnglish;
  String cityArabic;
  String cityOther;
  String landLine;
  String aCTIVE1;
  String aCTIVE2;
  int cRUPID;
  String assignedRoute;
  String sHORTCODE;
  String zONE;
  String uploadDate;
  String uploadby;
  String syncDate;
  String syncby;
  int synID;

  LsttblCityStatesCounty(
      {this.id,
        this.cityID,
        this.stateID,
        this.cOUNTRYID,
        this.cityEnglish,
        this.cityArabic,
        this.cityOther,
        this.landLine,
        this.aCTIVE1,
        this.aCTIVE2,
        this.cRUPID,
        this.assignedRoute,
        this.sHORTCODE,
        this.zONE,
        this.uploadDate,
        this.uploadby,
        this.syncDate,
        this.syncby,
        this.synID});

  LsttblCityStatesCounty.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    cityID = json['CityID'];
    stateID = json['StateID'];
    cOUNTRYID = json['COUNTRYID'];
    cityEnglish = json['CityEnglish'];
    cityArabic = json['CityArabic'];
    cityOther = json['CityOther'];
    landLine = json['LandLine'];
    aCTIVE1 = json['ACTIVE1'];
    aCTIVE2 = json['ACTIVE2'];
    cRUPID = json['CRUP_ID'];
    assignedRoute = json['AssignedRoute'];
    sHORTCODE = json['SHORTCODE'];
    zONE = json['ZONE'];
    uploadDate = json['UploadDate'];
    uploadby = json['Uploadby'];
    syncDate = json['SyncDate'];
    syncby = json['Syncby'];
    synID = json['SynID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['CityID'] = this.cityID;
    data['StateID'] = this.stateID;
    data['COUNTRYID'] = this.cOUNTRYID;
    data['CityEnglish'] = this.cityEnglish;
    data['CityArabic'] = this.cityArabic;
    data['CityOther'] = this.cityOther;
    data['LandLine'] = this.landLine;
    data['ACTIVE1'] = this.aCTIVE1;
    data['ACTIVE2'] = this.aCTIVE2;
    data['CRUP_ID'] = this.cRUPID;
    data['AssignedRoute'] = this.assignedRoute;
    data['SHORTCODE'] = this.sHORTCODE;
    data['ZONE'] = this.zONE;
    data['UploadDate'] = this.uploadDate;
    data['Uploadby'] = this.uploadby;
    data['SyncDate'] = this.syncDate;
    data['Syncby'] = this.syncby;
    data['SynID'] = this.synID;
    return data;
  }
}

class LstRefTable {
  String id;
  int tenentID;
  int rEFID;
  String rEFTYPE;
  String rEFSUBTYPE;
  String sHORTNAME;
  String rEFNAME1;
  String rEFNAME2;
  String rEFNAME3;
  String sWITCH1;
  String sWITCH2;
  String sWITCH3;
  int sWITCH4;
  String remarks;
  String aCTIVE;
  int cRUPID;
  String infrastructure;
  String rEFImage;
  String uploadDate;
  String uploadby;
  String syncDate;
  String syncby;
  int synID;
  String sMSTableMapped;
  String sMSColumnMapped;

  LstRefTable(
      {this.id,
        this.tenentID,
        this.rEFID,
        this.rEFTYPE,
        this.rEFSUBTYPE,
        this.sHORTNAME,
        this.rEFNAME1,
        this.rEFNAME2,
        this.rEFNAME3,
        this.sWITCH1,
        this.sWITCH2,
        this.sWITCH3,
        this.sWITCH4,
        this.remarks,
        this.aCTIVE,
        this.cRUPID,
        this.infrastructure,
        this.rEFImage,
        this.uploadDate,
        this.uploadby,
        this.syncDate,
        this.syncby,
        this.synID,
        this.sMSTableMapped,
        this.sMSColumnMapped});

  LstRefTable.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    tenentID = json['TenentID'];
    rEFID = json['REFID'];
    rEFTYPE = json['REFTYPE'];
    rEFSUBTYPE = json['REFSUBTYPE'];
    sHORTNAME = json['SHORTNAME'];
    rEFNAME1 = json['REFNAME1'];
    rEFNAME2 = json['REFNAME2'];
    rEFNAME3 = json['REFNAME3'];
    sWITCH1 = json['SWITCH1'];
    sWITCH2 = json['SWITCH2'];
    sWITCH3 = json['SWITCH3'];
    sWITCH4 = json['SWITCH4'];
    remarks = json['Remarks'];
    aCTIVE = json['ACTIVE'];
    cRUPID = json['CRUP_ID'];
    infrastructure = json['Infrastructure'];
    rEFImage = json['REF_Image'];
    uploadDate = json['UploadDate'];
    uploadby = json['Uploadby'];
    syncDate = json['SyncDate'];
    syncby = json['Syncby'];
    synID = json['SynID'];
    sMSTableMapped = json['SMSTableMapped'];
    sMSColumnMapped = json['SMSColumnMapped'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TenentID'] = this.tenentID;
    data['REFID'] = this.rEFID;
    data['REFTYPE'] = this.rEFTYPE;
    data['REFSUBTYPE'] = this.rEFSUBTYPE;
    data['SHORTNAME'] = this.sHORTNAME;
    data['REFNAME1'] = this.rEFNAME1;
    data['REFNAME2'] = this.rEFNAME2;
    data['REFNAME3'] = this.rEFNAME3;
    data['SWITCH1'] = this.sWITCH1;
    data['SWITCH2'] = this.sWITCH2;
    data['SWITCH3'] = this.sWITCH3;
    data['SWITCH4'] = this.sWITCH4;
    data['Remarks'] = this.remarks;
    data['ACTIVE'] = this.aCTIVE;
    data['CRUP_ID'] = this.cRUPID;
    data['Infrastructure'] = this.infrastructure;
    data['REF_Image'] = this.rEFImage;
    data['UploadDate'] = this.uploadDate;
    data['Uploadby'] = this.uploadby;
    data['SyncDate'] = this.syncDate;
    data['Syncby'] = this.syncby;
    data['SynID'] = this.synID;
    data['SMSTableMapped'] = this.sMSTableMapped;
    data['SMSColumnMapped'] = this.sMSColumnMapped;
    return data;
  }
}