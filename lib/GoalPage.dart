import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class GoalPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return GoalState();
  }
}


class GoalState extends State<GoalPage>{
  final userRepo = Get.put(UserRepository());
  List<Widget> weightGoals = [];
  List<Widget> cardioGoals = [];

  void _showOptionsForAdd() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add'),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _pressedAddButton('Weight');
                  },
                  child: Text('Weight'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _pressedAddButton('Cardio');
                  },
                  child: Text('Cardio'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void _pressedAddButton(String type) {
    setState(() {
      final Map<String, List<Widget>> itemMap = {
        'Cardio': cardioGoals,
        'Weight': weightGoals,
      };

      final list = itemMap[type];
      if (list != null) {
        list.add(GoalWidget(name: '$type ${list.length + 1}'));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return
      Column(
          children: <Widget> [
            Center(child: Text("Cardio Goals", style: TextStyle(fontSize: 24))),
            Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cardioGoals.length,
                  itemBuilder: (context, index) => cardioGoals[index],
                )
            ),
            Center(child: Text("Weight Goals", style: TextStyle(fontSize: 24))),
            Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: weightGoals.length,
                  itemBuilder: (context, index) => weightGoals[index],
                )
            ),
            ElevatedButton(
                onPressed: _showOptionsForAdd,
                child: Text("Add Goal")
            ),
          ]
      );
  }


  void goalSubmit() async {
    String? userId = userRepo.getCurrentUserUID();
    final databaseReference = FirebaseFirestore.instance.collection("User_Data");
    databaseReference.doc(userId).collection("Goal_Data").doc("Test").set({"Test": 1});
  }
}


class GoalWidget extends StatelessWidget {
  const GoalWidget({super.key,required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [Text(name)]);
  }
}
