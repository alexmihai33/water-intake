import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/models/water_model.dart';
import 'package:water_intake/providers/water_provider.dart';

class WaterTile extends StatelessWidget {
  const WaterTile({super.key, required this.waterModel});

  final WaterModel waterModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
          child: ListTile(
            title: Row(
              children: [
                Icon(size: 20, color: Colors.blue, Icons.water_drop),
                Text('${waterModel.amount.toStringAsFixed(0)} ml',
                style:Theme.of(context).textTheme.titleMedium,),
              ],
            ),
            subtitle: Text('${waterModel.dateTime.day}/${waterModel.dateTime.month}/${waterModel.dateTime.year}'),
            trailing: IconButton(onPressed: (){
              Provider.of<WaterProvider>(context, listen:false).delete(waterModel);
            }, icon: Icon(Icons.delete)),
            ),
    );
  }
}
