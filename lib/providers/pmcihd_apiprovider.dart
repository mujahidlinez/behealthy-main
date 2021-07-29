import 'dart:convert';
import 'package:behealthy/models/planmealcustominvoiceHDSave.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'PlanmealDB.dart';

class PlanMealcihdAPIProvider {
  getPlanMealcihd() async {
    var url = Uri.parse(
        "https://foodapi.pos53.com/api/Food/GenerateCustomerContract");
    http.Response response = await http.post(url, body: {
      'PlanId': '1',
      'TenentID': TenentID.toString(),
      'CustomerId': '8918',
      'ContractDate': '05/14/2021',
      'BeginDate': '05/16/2021',
      'AllowWeekend': 'False'
    });
    var data = jsonDecode(response.body)['data']['planmealinvoiceHD'];
    List list = [data];
    return list.map((element) {
      PlanMealciHDdb.db.createData(PlanMealCIHDSModel.fromMap(element));
    }).toList();
  }
}
