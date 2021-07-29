import 'dart:async';
import 'dart:convert';
import 'package:behealthy/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:geolocator/geolocator.dart';

class AddressPage extends StatefulWidget {
  final bool whereToSend;
  double latitude;
  double longitude;

  AddressPage({this.whereToSend = false, this.latitude, this.longitude});

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  void initState() {
    getStateList();
    getCurrentLocation();
    super.initState();
  }

  var addressName = TextEditingController();
  var city = TextEditingController();
  var country = TextEditingController();
  var address1 = TextEditingController();
  var block = TextEditingController();
  var building = TextEditingController();
  var street = TextEditingController();
  var flat = TextEditingController();
  var paciNumber = TextEditingController();

  // double latitude;
  // double longitude;
  var custID;
  bool _isLoading = false;

  List<StateData> stateList = [];
  List<DropdownMenuItem> menuItems = [];
  int _value = 0;

  List cityList = [];
  List<DropdownMenuItem> cityListItems = [];
  int _cityValue = 0;

  Completer<GoogleMapController> _controller = Completer();
  double lat = 0;
  double long = 0;
  final Set<Marker> _markers = {};

  Future getStateList() async {
    var response = await http
        .post(Uri.parse('https://foodapi.pos53.com/api/Food/DeliveryStateGet'));

    List<StateData> statesToAdd = [];
    List<DropdownMenuItem> itemList = [];

    if (response.statusCode <= 299) {
      var body = jsonDecode(response.body)['data'];
      int index = 0;
      for (var state in body) {
        var newState =
            StateData(state['StateName'] as String, state['StateID']);
        statesToAdd.add(newState);
        itemList.add(DropdownMenuItem(
          child: Text(
            state['StateName'] as String,
            style: TextStyle(color: BeHealthyTheme.kMainOrange),
          ),
          value: index,
        ));
        index++;
      }
    }

    setState(() {
      if (statesToAdd.isNotEmpty) {
        stateList.addAll(statesToAdd);
        menuItems.addAll(itemList);
      }
    });
    getCityList();
  }

  Future<void> getCityList() async {
    var stateId = stateList[_value].stateId;
    var cities = [];
    List<DropdownMenuItem> cityItems = [];
    var response = await http.post(
        Uri.parse('https://foodapi.pos53.com/api/Food/DeliveryCityGet'),
        body: {'StateID': stateId.toString()});
    print(response.statusCode);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body['data']);
      int i = 0;
      for (var city in body['data']) {
        cities.add(city['CityEnglish']);
        cityItems.add(DropdownMenuItem(
          child: Text(
            city['CityEnglish'],
            style: TextStyle(color: BeHealthyTheme.kMainOrange),
          ),
          value: i,
        ));
        i++;
        print(city);
      }
    }

    setState(() {
      if (cities.isNotEmpty) {
        if (cityList.isNotEmpty) {
          cityList.clear();
          cityListItems.clear();
        }
        cityList.addAll(cities);
        cityListItems.addAll(cityItems);
      }
    });
    print(cityList);
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        widget.latitude = position.latitude;
        widget.longitude = position.longitude;
      });
      print('latitude: ${widget.latitude} and longitude: ${widget.longitude}');
    } catch (e) {
      print(e);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      custID = prefs.get('custID');
    });
    print('custID: $custID');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('enter_address'.tr,
                        style: BeHealthyTheme.kMainTextStyle
                            .copyWith(fontSize: 25)),
                  ),
                  textFields(label: 'address_name'.tr, controller: addressName),
                  SizedBox(
                    height: 20,
                  ),
                  textFields(label: 'Country'.tr, controller: country),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 15,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: BeHealthyTheme.kLightOrange),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        focusColor: BeHealthyTheme.kMainOrange,
                        hint: Text('your_state'.tr),
                        value: _value,
                        items: (stateList.isEmpty) ? [] : menuItems,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                            _cityValue = 0;
                          });
                          getCityList();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 15,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: BeHealthyTheme.kLightOrange),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        focusColor: BeHealthyTheme.kMainOrange,
                        hint: Text('your_city'.tr),
                        value: _cityValue,
                        items: (cityListItems.isEmpty) ? [] : cityListItems,
                        onChanged: (value) {
                          setState(() {
                            _cityValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  textFields(label: 'address_one'.tr, controller: address1),
                  SizedBox(
                    height: 25,
                  ),
                  textFields(label: 'paci_number'.tr, controller: paciNumber),
                  SizedBox(
                    height: 25,
                  ),
                  textFields(label: 'block'.tr, controller: block),
                  SizedBox(
                    height: 25,
                  ),
                  textFields(label: 'building'.tr, controller: building),
                  SizedBox(
                    height: 25,
                  ),
                  textFields(label: 'street'.tr, controller: street),
                  SizedBox(
                    height: 25,
                  ),
                  textFields(label: 'flat'.tr, controller: flat),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _getLocation(),
                      GestureDetector(
                        onTap: () {
                          Get.dialog(
                            Scaffold(
                              body: Container(
                                child: GoogleMap(
                                  markers: _markers,
                                  onTap: (latlong) {
                                    print(latlong.latitude);
                                    print(latlong.longitude);
                                    setState(() {
                                      lat = latlong.latitude;
                                      long = latlong.longitude;
                                    });

                                    Get.defaultDialog(
                                        title: 'recorded'.tr,
                                        middleText:
                                            'Your LatLang is: ${lat.toStringAsFixed(2)} and ${long.toStringAsFixed(2)} ',
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                // Get.back(AddressPage());
                                                setState(() {
                                                  widget.latitude = lat;
                                                  widget.longitude = long;
                                                });
                                                Get.close(2);
                                              },
                                              child: Text("confirm".tr))
                                        ]);
                                  },
                                  mapType: MapType.normal,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(29.3117, 47.4818),
                                      zoom: 10),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 18,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              color: BeHealthyTheme.kMainOrange,
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            (widget.longitude == null ||
                                    widget.latitude == null)
                                ? Icons.map
                                : Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    onPressed: () {
                      apiPostRequest(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('add_address_now'.tr,
                        style: BeHealthyTheme.kMainTextStyle
                            .copyWith(fontSize: 20, color: Colors.white)),
                    color: BeHealthyTheme.kMainOrange,
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void apiPostRequest(BuildContext context) async {
    if (addressName.text.isEmpty ||
        country.text.isEmpty ||
        cityList.isEmpty ||
        address1.text.isEmpty ||
        block.text.isEmpty ||
        building.text.isEmpty ||
        street.text.isEmpty ||
        flat.text.isEmpty ||
        paciNumber.text.isEmpty ||
        widget.latitude == null ||
        widget.longitude == null ||
        custID == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'error'.tr,
              style: TextStyle(fontSize: 30, color: BeHealthyTheme.kMainOrange),
            )),
            content: Text(
              'fill_all'.tr,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            actions: [
              TextButton(
                child: Text(
                  'ok'.tr,
                  style: TextStyle(
                      fontSize: 20, color: BeHealthyTheme.kMainOrange),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> body = {
        'TenentID': TenentID.toString(),
        'GoogleName': addressName.text,
        'CITY': cityList[_cityValue],
        'STATE': stateList[_value].stateName,
        'COUNTRYID': 114.toString(),
        'Action': 'ADD',
        'CUSERID': custID.toString(),
        'AdressName1': address1.text,
        'PACKNumber': paciNumber.text,
        'Block': block.text,
        'Building': building.text,
        'Street': street.text,
        'ForFlat': flat.text,
        'Longitute': widget.longitude.toString(),
        'Latitute': widget.latitude.toString()
      };

      var response = await http.post(
          Uri.parse('https://foodapi.pos53.com/api/Food/DeliveryAddressSave'),
          body: body);
      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                'error'.tr,
                style:
                    TextStyle(fontSize: 30, color: BeHealthyTheme.kMainOrange),
              )),
              content: Text(
                'problem_occured'.tr,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'ok'.tr,
                    style: TextStyle(
                        fontSize: 20, color: BeHealthyTheme.kMainOrange),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget textFields({String label, TextEditingController controller}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: MediaQuery.of(context).size.height / 15,
      child: TextFormField(
        controller: controller,
        cursorColor: BeHealthyTheme.kMainOrange,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide:
                  BorderSide(width: 1, color: BeHealthyTheme.kMainOrange),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide:
                  BorderSide(width: 2, color: BeHealthyTheme.kMainOrange),
            ),
            labelText: label,
            labelStyle: BeHealthyTheme.kInputFieldTextStyle),
      ),
    );
  }

  Widget _getLocation() {
    return GestureDetector(
      onTap: getCurrentLocation,
      child: Container(
        height: MediaQuery.of(context).size.height / 18,
        width: MediaQuery.of(context).size.width / 4,
        decoration: BoxDecoration(
            color: BeHealthyTheme.kMainOrange,
            borderRadius: BorderRadius.circular(20)),
        child: Icon(
          (widget.longitude == null || widget.latitude == null)
              ? Icons.location_on
              : Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}

class StateData {
  String stateName;
  int stateId;

  StateData(this.stateName, this.stateId);

  @override
  String toString() {
    return 'stateName: $stateName, stateId: $stateId';
  }
}
