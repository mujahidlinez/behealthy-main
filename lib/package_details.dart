
import 'dart:convert';
import 'package:behealthy/database/dbhelper.dart';
import 'package:behealthy/meal_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:behealthy/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:get/get.dart';
import 'database/table_fields.dart';

class PackageDetails extends StatefulWidget {
  final genratedContract;
  final int transId;
  PackageDetails({
    this.genratedContract,
    this.transId
  });
  @override
  _PackageDetailsState createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {
  String planTitle;
  final dataBaseHelper = DatabaseHelper.instance;

  final String mAPIUrl = "https://apitest.myfatoorah.com/";

  final String mAPIKey =
      "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";
  String _response = '';
  String _loading = "Loading...";
  int planDays = 0;
  double planAmount = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MFSDK.init(mAPIUrl, mAPIKey);
    setPlaDays();
  }

  setPlaDays() async {
    var preferences = await SharedPreferences.getInstance();
    var temp = widget.genratedContract['data']['PlanPrice'];
    if(temp != 0.0){
      preferences.setDouble('planAmount',temp);
    }
    setState(() {
      planDays = preferences.getInt('planDays');
      planAmount = preferences.getDouble('planAmount');
    });

  }

  void initiatePayment() {
    var request = new MFInitiatePaymentRequest(5.5, MFCurrencyISO.KUWAIT_KWD);
    print('start executing');
    MFSDK.initiatePayment(
      request,
      MFAPILanguage.EN,
      (MFResult<MFInitiatePaymentResponse> result) => {
        if (result.isSuccess()){
            setState(() {
              _response = result.response.toJson().toString();
              var json = result.response.toJson();
              for (var res in json['PaymentMethods']) {
               // print(res);
              }
            })
          } else{
            setState(() {
              print(result.error.toJson());
              _response = result.error.message;
            })
          }
      },
    );
    print('done');
    setState(() {
      _response = _loading;
    });
  }
  void executeRegularPayment() {
    int paymentMethod = 1;

    var request = new MFExecutePaymentRequest(
        paymentMethod, widget.genratedContract['data']['PlanPrice']);

    MFSDK.executePayment(
        context,
        request,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess()){
                  setState(() {
                    print(invoiceId);
                   // print(result.response.toJson());
                    _response = result.response.toJson().toString();
                  })
                } else {
                  setState(() {
                   // print(invoiceId);
                   // print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }
  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dataBaseHelper.queryRowCount();
    final rowsDeleted = await dataBaseHelper.deleteFromTablePlanMealCustInvoiceHD(id);
    print('deleted $rowsDeleted row(s): row $id');
  }



  _insertinPlanMealCustinvoiceDb(List allData) async {
    allData.forEach((element) async {
      Map<String, dynamic> newRow = {
        TableFields.tenentId: element['TenentID'],
        TableFields.mytransid: widget.transId,
        TableFields.deliveryId: element['DeliveryID'],
        TableFields.myprodid: element['MYPRODID'],
        TableFields.uom: element['UOM'],
        TableFields.locationId: element['LOCATION_ID'],
        TableFields.customerId: element['CustomerID'],
        TableFields.planid: element['planid'],
        TableFields.mealType: element['MealType'],
        TableFields.prodName1: element['ProdName1'],
        TableFields.oprationDay: element['OprationDay'],
        TableFields.dayNumber: element['DayNumber'],
        TableFields.transId: widget.transId,
        TableFields.contractId: widget.transId,
        TableFields.weekofDay: element['WeekofDay'],
        TableFields.nameOfDay: element['NameOfDay'],
        TableFields.totalWeek: element['TotalWeek'],
        TableFields.noOfWeek: element['NoOfWeek'],
        TableFields.displayWeek: element['DisplayWeek'],
        TableFields.totalDeliveryDay: planDays,
        TableFields.actualDeliveryDay: element['ActualDeliveryDay'],
        TableFields.expectedDeliveryDay: element['ExpectedDeliveryDay'],
        TableFields.deliveryTime: element['DeliveryTime'],
        TableFields.deliveryMeal: element['DeliveryMeal'],
        TableFields.driverId: element['DriverID'],
        TableFields.startDate: element['StartDate'],
        TableFields.endDate: element['EndDate'],
        TableFields.expectedDelDate: element['ExpectedDelDate'],
        TableFields.actualDelDate: element['ActualDelDate'],
        TableFields.nExtDeliveryDate: element['NExtDeliveryDate'],
        TableFields.returnReason: element['ReturnReason'],
        TableFields.reasonDate: element['ReasonDate'],
        TableFields.productionDate: element['ProductionDate'],
        TableFields.chiefId: element['chiefID'],
        TableFields.subscriptonDayNumber: element['SubscriptonDayNumber'],
        TableFields.calories: element['Calories'],
        TableFields.protein: element['Protein'],
        TableFields.fat: element['Fat'],
        TableFields.itemWeight: element['ItemWeight'],
        TableFields.carbs: element['Carbs'],
        TableFields.qty: element['Qty'],
        TableFields.itemCost: element['Item_cost'],
        TableFields.itemPrice: element['Item_price'],
        TableFields.totalprice: element['Totalprice'],
        TableFields.shortRemark: element['ShortRemark'],
        TableFields.active: element['ACTIVE'],
        TableFields.crupid: element['CRUPID'],
        TableFields.changesDate: element['ChangesDate'],
        TableFields.deliverySequence: element['DeliverySequence'],
        TableFields.switch1: element['Switch1'],
        TableFields.switch2: element['Switch2'],
        TableFields.switch3: element['Switch3'],
        TableFields.switch4: element['Switch4'],
        TableFields.switch5: element['Switch5'],
        TableFields.status: element['Status'],
        TableFields.uploadDate: element['UploadDate'],
        TableFields.uploadby: element['Uploadby'],
        TableFields.syncDate: element['SyncDate'],
        TableFields.syncby: element['Syncby'],
        TableFields.synId: element['SynID'],
        TableFields.syncStatus: element['syncStatus'],
        TableFields.localId: element['LocalID'],
        TableFields.offlineStatus: element['OfflineStatus'],
        TableFields.mealUom: element['MealUOM'],
        TableFields.basicCustom: 'Fixed',
        TableFields.fixFlexible: 'Fixed',
      };
      try {
        final id = dataBaseHelper.insertToPlanMealCustInvoice(newRow);
        print('Row inserted in plan meal customer invoice db:$id');
      } catch (e) {
        print(e);
      }
    });
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MealSelection(planId: widget.genratedContract['data']['PlanId'],
      transId: allData[0]['MYTRANSID'])));
  }

  _getPlanMealCustInvoice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mytransid = preferences.get('myTransId');
   // print('MytransId:$mytransid');
    http.Response response = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Food/GenerateCustomerContractDetails'),
        body: {
          'TenentID': TenentID.toString(),
          'MyTransID': '$mytransid'
        },
    );
   // print(response.body);
    var json = jsonDecode(response.body);
    if (json['status'] == 200) {
      var data = jsonDecode(response.body)['data'];
      _insertinPlanMealCustinvoiceDb(data);
    }
  }

  Future shardPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      return prefs;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return Material(
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async => false,
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Image(
                    image: AssetImage('assets/images/semi-circle.png'),
                  ),
                  Positioned(
                    top: medq.height / 20,
                    left: medq.width / 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text('package_available'.tr, style: BeHealthyTheme.kMainTextStyle.copyWith(color: Colors.white, fontSize: 15,
                            fontWeight: FontWeight.w600),),
                        Text('حزمة من التفاصيل', style: BeHealthyTheme.kMainTextStyle.copyWith(fontSize: 19, color: Colors.white),),
                        SizedBox(height: 10,),
                        Container(
                          width: medq.width * 0.6,
                          child: FutureBuilder(
                              future: shardPref(),
                              builder: (context, snapshot) {
                                var name = "";
                                if(snapshot.data != null){
                                   name = snapshot.data.get('planTitle');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    return Text(name.toString(),
                                      style: BeHealthyTheme.kMainTextStyle
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                    );
                                  } else {
                                    return Text('error'.tr);
                                  }
                                } else {
                                  return Text(' ');
                                }
                              },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Positioned(
              //     top: -medq.height * 0.35,
              //     left: medq.width * 0.65,
              //     child: Image(
              //         width: 71,
              //         height: 455,
              //         image: AssetImage('assets/images/login_lamp.png'))),
              // Positioned(
              //     top: medq.height / 30,
              //     left: medq.width * 0.85,
              //     child: Image(
              //         width: 40,
              //         height: 40,
              //         color: Colors.white,
              //         image: AssetImage('assets/images/bh_logo.png'))),
              // Positioned(
              //     bottom: 0,
              //     child:
              //         Image(image: AssetImage('assets/images/Untitled-1.png'))),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.86,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 3),
                                color: Colors.black12,
                                blurRadius: 12,
                              )
                            ],
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              // Text(
                              //   'Ramdan Basic Plan',
                              //   style: BeHealthyTheme.kMainTextStyle.copyWith(
                              //       fontSize: 22,
                              //       color: BeHealthyTheme.kMainOrange),
                              // ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/Dinner.png',
                                          width: 45,
                                          height: 45,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text('quantity'.tr, style: BeHealthyTheme.kProfileFont.copyWith(fontSize: 9, fontWeight: FontWeight.w600),),
                                        Text('$planDays', style: BeHealthyTheme.kMainTextStyle.copyWith(fontSize: 22,
                                            color: BeHealthyTheme.kMainOrange),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 60, child: VerticalDivider(color: Colors.black26, width: 20,)),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/send.png', width: 48, height: 49,),
                                      SizedBox(height: 0,),
                                      Text('amount'.tr, style: BeHealthyTheme.kProfileFont.copyWith(fontSize: 9, fontWeight: FontWeight.w600),),
                                      Text(    '$planAmount Kd', style: BeHealthyTheme.kMainTextStyle.copyWith(fontSize: 22,
                                          color: BeHealthyTheme.kMainOrange),//{widget.genratedContract['data']['PlanPrice']}
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 60, child: VerticalDivider(color: Colors.black26, width: 20,)),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/images/take-away (3).png', width: 45, height: 45,),
                                        SizedBox(height: 3,),
                                        Text('cust_id'.tr, style: BeHealthyTheme.kProfileFont.copyWith(fontSize: 9, fontWeight: FontWeight.w600),),
                                        Text('${widget.genratedContract['data']['planmealinvoiceHD']['TransID']}', style: BeHealthyTheme.kMainTextStyle.
                                            copyWith(fontSize: 22, color: BeHealthyTheme.kMainOrange)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 8, right: 15),
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: BeHealthyTheme.kMainOrange),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 1),
                                        color: Colors.black12,
                                        blurRadius: 5,
                                      )
                                    ],
                                  ),
                                  //color: Colors.green,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 5,),
                                      Image.asset('assets/images/check (2).png', height: 30, width: 30,),
                                      SizedBox(height: 5,),
                                      Text('${widget.genratedContract['data']['planmealinvoiceHD']['PaymentStatus']}', style:
                                      BeHealthyTheme.kProfileFont.copyWith(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center,)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  FlutterOpenWhatsapp.sendSingleMessage(
                                      '96592222991',
                                      'Hello, Behealthy \nI want support with...');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 23),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.green),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 1),
                                          color: Colors.black12,
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),
                                    //color: Colors.green,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 5,),
                                        Image.asset('assets/images/whatsapp.png', height: 30, width: 30,),
                                        SizedBox(height: 5,),
                                        Text('Whatsapp', style: BeHealthyTheme.kProfileFont.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 8, right: 15),
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: BeHealthyTheme.kMainOrange),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 1),
                                        color: Colors.black12,
                                        blurRadius: 5,
                                      )
                                    ],
                                  ),
                                  //color: Colors.green,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Image.asset(
                                        'assets/images/support (1).png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'support'.tr,
                                        style: BeHealthyTheme.kProfileFont
                                            .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 23),
                                child: GestureDetector(
                                  onTap: () {
                                    // initiatePayment() ;
                                    executeRegularPayment();
                                  },
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: BeHealthyTheme.kMainOrange),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 1),
                                          color: Colors.black12,
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),

                                    //color: Colors.green,

                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 5,),
                                        Image.asset('assets/images/card.png', height: 30, width: 30,),
                                        SizedBox(height: 5,),
                                        Text('pay_now'.tr, style: BeHealthyTheme.kProfileFont.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 45,),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration.zero, () async {
                                  //TODO get next TrancID here
                                  _getPlanMealCustInvoice();
                                  //dataBaseHelper.temp();

                                  // try {
                                  // } catch (e) {
                                  //   print(e);
                                  // }
                                });
                                return Center(
                                    child: CircularProgressIndicator());
                              });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 30),
                          width: MediaQuery.of(context).size.width - 100,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: BeHealthyTheme.kMainOrange,
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'continue'.tr,
                                style: BeHealthyTheme.kMainTextStyle.copyWith(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                      // MaterialButton(
                      //   onPressed: _delete,
                      //   child: Text('Delete Rows'),
                      // ),
                      // MaterialButton(
                      //   onPressed: _query,
                      //   child: Text('Query Rows'),
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
