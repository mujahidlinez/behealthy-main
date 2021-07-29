import 'package:behealthy/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/location.png'),
                      height: 25,
                      width: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'd_to'.tr,
                          style: BeHealthyTheme.kDeliverToStyle,
                        ),
                        Text(
                          'zyc_kuwait'.tr,
                          style: BeHealthyTheme.kAddressStyle
                              .copyWith(fontWeight: FontWeight.w100),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                height: 50,
                child: TextFormField(
                  cursorColor: BeHealthyTheme.kMainOrange,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      focusColor: BeHealthyTheme.kMainOrange,
                      suffixIcon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                            width: 1, color: BeHealthyTheme.kMainOrange),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                            width: 2, color: BeHealthyTheme.kMainOrange),
                      ),
                      labelText: "search".tr,
                      labelStyle: BeHealthyTheme.kInputFieldTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
