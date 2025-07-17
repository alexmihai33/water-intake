import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/bars/bar_graph.dart';
import 'package:water_intake/providers/water_provider.dart';
import 'package:water_intake/utils/date_helper.dart';

class WaterSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const WaterSummary({super.key, required this.startOfWeek});

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
            maxY: 2000,
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
