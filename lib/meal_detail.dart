import 'package:behealthy/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealDetailPage extends StatefulWidget {
  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Align(
      //   alignment: Alignment.bottomLeft,
      //   child: Padding(
      //     padding: const EdgeInsets.only(left: 50.0),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         Container(
      //           width: MediaQuery.of(context).size.width / 2,
      //           height: MediaQuery.of(context).size.height / 15,
      //           decoration: BoxDecoration(
      //             color: BeHealthyTheme.kMainOrange,
      //             borderRadius: BorderRadius.circular(20),
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Icon(Icons.shopping_cart, color: Colors.white),
      //               SizedBox(
      //                 width: 3,
      //               ),
      //               Text(
      //                 'Add to cart',
      //                 style: TextStyle(
      //                     fontSize: MediaQuery.of(context).size.height / 35,
      //                     fontWeight: FontWeight.bold,
      //                     color: Colors.white),
      //               )
      //             ],
      //           ),
      //         ),
      //         ClipRRect(
      //           borderRadius: BorderRadius.all(Radius.circular(30.0)),
      //           child: ElevatedButton(
      //             style: ButtonStyle(
      //               elevation: MaterialStateProperty.all(0),
      //               backgroundColor:
      //                   MaterialStateProperty.all(BeHealthyTheme.kLightOrange),
      //             ),
      //             onPressed: () {},
      //             child: Text(
      //               '${Get.arguments['Item_cost'].toString()} kd',
      //               style: TextStyle(
      //                   fontSize: MediaQuery.of(context).size.height * 0.028,
      //                   color: BeHealthyTheme.kMainOrange,
      //                   fontWeight: FontWeight.bold),
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(),
            ),
            Image.network(
              Get.arguments['ProdName3'],
              height: MediaQuery.of(context).size.height / 2.2,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 50, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  Get.arguments['ProdName1'],
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      color: BeHealthyTheme.kMainOrange,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${Get.arguments['ItemWeight'].toString()} g',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                      color: BeHealthyTheme.kMainOrange,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor: MaterialStateProperty.all(
                                    BeHealthyTheme.kLightOrange),
                              ),
                              onPressed: () {},
                              child: Text(
                                '${Get.arguments['Calories'].toString()} Cal',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    color: BeHealthyTheme.kMainOrange,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06),
                      buildColumn(
                          context,
                          'Fat',
                          '${Get.arguments['Fat'].toString()} g',
                          Get.arguments['Fat'] / Get.arguments['ItemWeight']),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      buildColumn(
                          context,
                          'Carbs',
                          '${Get.arguments['Carbs'].toString()} g',
                          Get.arguments['Carbs'] / Get.arguments['ItemWeight']),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      buildColumn(
                          context,
                          'Protein',
                          '${Get.arguments['Protein'].toString()} g',
                          Get.arguments['Protein'] /
                              Get.arguments['ItemWeight']),
                      // SizedBox(
                      //     height: MediaQuery.of(context).size.height * 0.03),
                      // buildColumn(context, 'Vitamin A', '5%', 5 / 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildColumn(
      BuildContext context, String nutrition, weight, double value) {
    return Padding(
      padding: const EdgeInsets.only(right: 80.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nutrition,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
              Text(
                weight,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.018,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: LinearProgressIndicator(
              minHeight: MediaQuery.of(context).size.height * 0.01,
              value: value,
              valueColor:
                  AlwaysStoppedAnimation<Color>(BeHealthyTheme.kMainOrange),
              // color: BeHealthyTheme.kMainOrange,
              backgroundColor: BeHealthyTheme.kLightOrange,
            ),
          ),
        ],
      ),
    );
  }
}
