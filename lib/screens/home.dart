import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final amountController = TextEditingController(text: "Hello");

  void saveWater(String amount) async {
    final url = Uri.https('water-intaker-app-default-rtdb.europe-west1.firebasedatabase.app', 'water.json');
      var res = await http.post(url, headers:{
        'Content-Type':'application/json'
      }, body: json.encode({
        'amount':double.parse(amount),
        'unit':'ml',
        'dateTime':DateTime.now().toString()
        }
      ));

    if (res.statusCode == 200){
      print('Data saved');
    }
    else{
      print("Not saved");
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
          TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
          TextButton(onPressed: () {
            saveWater(amountController.text);
          }, child: Text('Save')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        title: Text("Water Intake"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.map))],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addWater,
      ),
    );
  }
}
