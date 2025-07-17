import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/models/water_model.dart';
import 'package:water_intake/providers/water_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final amountController = TextEditingController();

  @override
  void initState() {
    Provider.of<WaterProvider>(context, listen: false).getWater();
    super.initState();
  }
  void saveWater() async {
    Provider.of<WaterProvider>(context, listen: false).addWaterToDatabase(
      WaterModel(
        amount: double.parse(amountController.text),
        dateTime: DateTime.now(),
        unit: 'ml',
      ),
    );
    if(!context.mounted){
      return;
    }
  }

  void addWater() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Water"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add water to your daily intake"),
            SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              saveWater();
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterProvider>(
      builder: (BuildContext context, WaterProvider value, Widget? child) =>
          Scaffold(
            appBar: AppBar(
              elevation: 4,
              centerTitle: true,
              title: Text("Water Intake"),
              actions: [IconButton(onPressed: () {}, icon: Icon(Icons.map))],
            ),
            body: ListView.builder(
              itemCount: value.waterDataList.length,
              itemBuilder: (context, index){
                final waterModel = value.waterDataList[index];
                return ListTile(title:Text(waterModel.amount.toString()));
            }),
            backgroundColor: Theme.of(context).colorScheme.background,
            floatingActionButton: FloatingActionButton(
              onPressed: addWater,
              child: Icon(Icons.add),
            ),
          ),
    );
  }
}
