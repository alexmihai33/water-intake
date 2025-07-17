import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/bars/bar_graph.dart';
import 'package:water_intake/providers/water_provider.dart';

class WaterSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const WaterSummary({super.key, required this.startOfWeek});

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterProvider>(
      builder: (BuildContext context, WaterProvider value, Widget? child) {
        return SizedBox(
          height: 200,
          child: BarGraph(
            maxY: 2000,
            sunWaterAmt: 24,
            monWaterAmt: 150,
            tueWaterAmt: 300,
            wedWaterAmt: 450,
            thuWaterAmt: 250,
            friWaterAmt: 1050,
            satWaterAmt: 1300,
          ),
        );
      },
    );
  }
}
