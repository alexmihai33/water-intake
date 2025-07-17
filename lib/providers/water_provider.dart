import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:water_intake/models/water_model.dart';
import 'package:water_intake/utils/date_helper.dart';

class WaterProvider extends ChangeNotifier {
  List<WaterModel> waterDataList = [];

  void addWaterToDatabase(WaterModel water) async {
    final url = Uri.https(
      'water-intaker-app-default-rtdb.europe-west1.firebasedatabase.app',
      'water.json',
    );
    var res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amount': double.parse(water.amount.toString()),
        'unit': 'ml',
        'dateTime': DateTime.now().toString(),
      }),
    );

    if (res.statusCode == 200) {
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      waterDataList.add(
        WaterModel(
          id: extractedData['name'],
          amount: water.amount,
          dateTime: water.dateTime,
          unit: 'ml',
        ),
      );
    } else {
      print('Error: ${res.statusCode}');
    }
    notifyListeners();
  }

  Future<List<WaterModel>> getWater() async {
    final url = Uri.https(
      'water-intaker-app-default-rtdb.europe-west1.firebasedatabase.app',
      'water.json',
    );

    final res = await http.get(url);
    if (res.statusCode == 200 && res.body != 'null') {
      waterDataList.clear();
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      for (var element in extractedData.entries) {
        waterDataList.add(
          WaterModel(
            id: element.key,
            amount: element.value['amount'],
            dateTime: DateTime.parse(element.value['dateTime']),
            unit: element.value['unit'],
          ),
        );
      }
    }
    notifyListeners();
    return waterDataList;
  }

  String getWeekday(DateTime dateTime){
    switch(dateTime.weekday){
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';    
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
      }
  }

  DateTime getStartOfWeek(){
    DateTime? startOfWeek;

    DateTime dateTime = DateTime.now();

    for (int i = 0; i < 7; i++){
      if(getWeekday(dateTime.subtract(Duration(days: i))) == 'Sun'){
        startOfWeek = dateTime.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  void delete(WaterModel waterModel) async {
    final url = Uri.https(
      'water-intaker-app-default-rtdb.europe-west1.firebasedatabase.app',
      'water/${waterModel.id}.json',
    );
    await http.delete(url);

    waterDataList.removeWhere((element) => element.id == waterModel.id);

    notifyListeners();
  }

  String calculateWeeklyWaterIntake (WaterProvider value){
    double weeklyWaterIntake = 0;

    for (var water in value.waterDataList){
      weeklyWaterIntake+=double.parse(water.amount.toString());

    }
    return weeklyWaterIntake.toStringAsFixed(0);
  }

  Map<String, double> calculateDailyWaterIntake(){
    Map<String, double> dailyWaterIntake = {};

    for (var value in waterDataList){
      double amount = double.parse(value.amount.toString());
      String date = convertDateTimeToString(value.dateTime);
      if(dailyWaterIntake.containsKey(date)){
        double currentAmount = dailyWaterIntake[date]!;
        currentAmount += amount;
        dailyWaterIntake[date] = currentAmount;
      }
      else{
        dailyWaterIntake.addAll({date:amount});
      }
    }
    return dailyWaterIntake;
  }
}
