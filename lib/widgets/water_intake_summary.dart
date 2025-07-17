import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/bars/bar_graph.dart';
import 'package:water_intake/providers/water_provider.dart';
import 'package:water_intake/utils/date_helper.dart';

class WaterSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const WaterSummary({super.key, required this.startOfWeek});

  double calculateMaxAmount(
    WaterProvider waterProvider,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ){
    double? maxAmount = 100;
    List<double> values = [
      waterProvider.calculateDailyWaterIntake()[sunday] ?? 0,
      waterProvider.calculateDailyWaterIntake()[sunday] ?? 0,
      waterProvider.calculateDailyWaterIntake()[monday] ?? 0,
      waterProvider.calculateDailyWaterIntake()[tuesday] ?? 0,
      waterProvider.calculateDailyWaterIntake()[wednesday] ?? 0,
      waterProvider.calculateDailyWaterIntake()[thursday] ?? 0,
      waterProvider.calculateDailyWaterIntake()[friday] ?? 0,
      waterProvider.calculateDailyWaterIntake()[saturday] ?? 0,
    ];

    values.sort();

    maxAmount = values.last*1.3;

    return maxAmount == 0 ? 100 : maxAmount;
  }

  @override
  Widget build(BuildContext context) {
    String sunday = convertDateTimeToString(startOfWeek.add(Duration(days: 0)));
    String monday = convertDateTimeToString(startOfWeek.add(Duration(days: 1)));
    String tuesday = convertDateTimeToString(
      startOfWeek.add(Duration(days: 2)),
    );
    String wednesday = convertDateTimeToString(
      startOfWeek.add(Duration(days: 3)),
    );
    String thursday = convertDateTimeToString(
      startOfWeek.add(Duration(days: 4)),
    );
    String friday = convertDateTimeToString(startOfWeek.add(Duration(days: 5)));
    String saturday = convertDateTimeToString(
      startOfWeek.add(Duration(days: 6)),
    );
    return Consumer<WaterProvider>(
      builder: (BuildContext context, WaterProvider value, Widget? child) {
        return SizedBox(
          height: 200,
          child: BarGraph(
            maxY: calculateMaxAmount(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday),
            sunWaterAmt: value.calculateDailyWaterIntake()[sunday] ?? 0,
            monWaterAmt: value.calculateDailyWaterIntake()[monday] ?? 0,
            tueWaterAmt: value.calculateDailyWaterIntake()[tuesday] ?? 0,
            wedWaterAmt: value.calculateDailyWaterIntake()[wednesday] ?? 0,
            thuWaterAmt: value.calculateDailyWaterIntake()[thursday] ?? 0,
            friWaterAmt: value.calculateDailyWaterIntake()[friday] ?? 0,
            satWaterAmt: value.calculateDailyWaterIntake()[saturday] ?? 0,
          ),
        );
      },
    );
  }
}
