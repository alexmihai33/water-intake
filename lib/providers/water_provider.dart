import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:water_intake/models/water_model.dart';

class WaterProvider extends ChangeNotifier {
  List<WaterModel> waterDataList = [];

  void addWater(WaterModel water) async {
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
    notifyListeners();
  }

  Future<List<WaterModel>> getWater() async {

    final url = Uri.https(
      'water-intaker-app-default-rtdb.europe-west1.firebasedatabase.app',
      'water.json',
    );

    final res = await http.get(url);
    if (res.statusCode == 200 && res.body != 'null') {
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      for (var element in extractedData.entries) {
        waterDataList.add(
          WaterModel(
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
  
}
