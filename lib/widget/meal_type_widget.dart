import 'dart:convert';

import 'package:behealthy/database/dbhelper.dart';
import 'package:behealthy/models/meal_Model.dart';
import 'package:behealthy/providers/planmealcustinvoiceDb.dart';
import 'package:behealthy/utils/global_variables.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';

import '../constants.dart';
import '../meal_selection.dart';

class MealTypeWidget extends StatefulWidget {
  final int planId;
  int deliveryId;
  final int mealIndex;
  final int allowdMeals;
  final List mealsTypeList;
  final dynamic expectedDelDay;
  final dynamic transid;
  final dynamic switch5;
  final List deliveryIdList;
  final int selectedWeekNumber;
  final int dayIndex;
  List<Data> data = List();



  MealTypeWidget({this.deliveryId, this.planId, this.mealIndex, this.allowdMeals, this.mealsTypeList,
    this.expectedDelDay, this.switch5, this.deliveryIdList, this.transid,this.selectedWeekNumber,this.dayIndex,this.data});

  @override
  _MealTypeWidgetState createState() => _MealTypeWidgetState();
}

class _MealTypeWidgetState extends State<MealTypeWidget> {
  final databaseHelper = DatabaseHelper.instance;
  int _selected_meals = 0;
  List allowedMealsList = [];
  List selectedMeals = [];
  Map<String, String> foodNames = {'1401': 'BreakFast', '1402': 'Lunch', '1403': 'Dinner', '1404': 'Snack', '1405': 'Salad', '1406': 'Soup'};


  _querySelected(int rTenentId, int rMyTransId, int rExpectedDeliveryDay, int rPlanid, int rMealtype) async {

    final rows = await databaseHelper.querySelectedPlanMealCustInvoice(
        rTenentId, rMyTransId, rExpectedDeliveryDay, rPlanid, rMealtype);
    print('Switch5 query:');
    rows.forEach(print);
    return rows;
  }
  updateRow(Data snap) async {
    var id = await databaseHelper.updateUsingRawQuery(snap.mYPRODID, snap.uOM, snap.itemCost, snap.calories, snap.protein, snap.carbs,
      snap.fat, snap.itemWeight, snap.prodName1, 'Note by user', 'Note by user for short remark', 14, widget.transid, widget.expectedDelDay,
      widget.planId, snap.mealType,);
  }
  downgradeRow(Data snap,) async {
    var id = await databaseHelper.updateUsingRawQuery(null, null, null, null, null, null, null, null, '10009', 'Note by user', 'Note by user for short remark',
      14, widget.transid, widget.expectedDelDay, widget.planId, snap.mealType,);
    print('Number of rows changed:$id');
  }
  checkMealCount(var snap, bool value) async {
    if (value == true) {
      await updateRow(snap);
      Toast.show('Successfully Added', context);
    } else {
      await downgradeRow(snap);
      Toast.show('Successfully Removed', context);
    }
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size medq = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Center(
                child: RichText(
                  text: TextSpan(
                      text: foodNames[widget.mealsTypeList[widget.mealIndex].toString()],
                      style: BeHealthyTheme.kMainTextStyle.copyWith(
                          color: BeHealthyTheme.kMainOrange, fontSize: 24),
                      children: [
                        TextSpan(text: '  $_selected_meals/${widget.allowdMeals}',
                          style: BeHealthyTheme.kMainTextStyle.copyWith(color: Color(0xff707070), fontSize: 24),
                        )
                      ]),
                ),
              ),
            ),
            Divider(
              indent: 100,
              endIndent: 100,
              thickness: 1.5,
            ),
            Container(
              height: medq.height * 0.27,
              width: medq.width,
              child: ListView.builder(
                itemCount: wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CustomGridItem(index: index,
                    title: '${wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].prodName1}',
                    imageUrl: wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].prodName3,
                    isCompleted: wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].isSelected,
                    dataList: wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items,
                    onTap: () async {
                     if(!wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].isSelected) {
                        //widget.deliveryId = widget.deliveryIdList[index];
                        if (_selected_meals < widget.allowdMeals && !wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].isSelected) {
                          setState(() {
                            _selected_meals += 1;
                            wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].isSelected = true;
                            selectedMeals.add(wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].id);
                          });
                          checkMealCount(wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index], true);
                        } else if (_selected_meals == widget.allowdMeals &&
                            wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].isSelected) {
                          setState(() {
                            _selected_meals -= 1;
                            wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].isSelected = false;
                            selectedMeals.remove(wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].id);
                          });
                          checkMealCount(wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index], false);
                        } else if (selectedMeals.length > 0 && wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].
                        meals[widget.mealIndex].items[index].isSelected) {
                          setState(() {
                            _selected_meals -= 1;
                            wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].isSelected = false;
                            selectedMeals.remove(wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].id);
                          });
                          checkMealCount(wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index], false);
                        } else {
                          Toast.show('Allowed meal exceeded', context);
                        }
                      }else{
                       _selected_meals -= 1;
                       wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].isSelected = false;
                       selectedMeals.remove(wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index].id);
                       checkMealCount(wholePlan.weeks[widget.selectedWeekNumber].days[widget.dayIndex].meals[widget.mealIndex].items[index], false);
                     }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
