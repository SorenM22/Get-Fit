import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final TextEditingController goalController = TextEditingController();

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
                    _showGoalDialog('Weight');
                  },
                  child: Text('Weight'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showGoalDialog('Cardio');
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

  void _showGoalDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter your goal"),
          content: TextField(
            controller: goalController,
            decoration: InputDecoration(hintText: "Enter goal for $type"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                goalSubmit(type, goalController.text);
                goalController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void goalSubmit(String type, String goal) async {
    String? userId = userRepo.getCurrentUserUID();
    final databaseReference = FirebaseFirestore.instance.collection("User_Data");
    databaseReference
        .doc(userId)
        .collection("Goal_Data")
        .doc(type)
        .collection(type)
        .add({"Goal": goal});

    /*setState(() {
      final Map<String, List<Widget>> itemMap = {
        'Cardio': cardioGoals,
        'Weight': weightGoals,
      };

      final list = itemMap[type];
      if (list != null) {
        list.add(GoalWidget(name: '$type $goal'));
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Center(child: Text("Cardio Goals", style: TextStyle(fontSize: 24))),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User_Data")
                  .doc(userRepo.getCurrentUserUID())
                  .collection("Goal_Data")
                  .doc("Cardio")
                  .collection("Cardio")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final goals = snapshot.data!.docs.map((doc) {
                  return GoalWidget(name: doc["Goal"]);
                }).toList();
                return ListView(children: goals);
              },
            ),
          ),
          Center(child: Text("Weight Goals", style: TextStyle(fontSize: 24))),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User_Data")
                  .doc(userRepo.getCurrentUserUID())
                  .collection("Goal_Data")
                  .doc("Weight")
                  .collection("Weight")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final goals = snapshot.data!.docs.map((doc) {
                  return GoalWidget(name: doc["Goal"]);
                }).toList();
                return ListView(children: goals);
              },
            ),
          ),
            ElevatedButton(
                onPressed: _showOptionsForAdd,
                child: Text("Add Goal")
            ),
          ]
      );
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
