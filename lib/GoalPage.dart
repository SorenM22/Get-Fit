import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final TextEditingController goalController = TextEditingController();

List<Widget> weightGoals = [];
List<Widget> cardioGoals = [];

class GoalPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return GoalState();
  }
}


class GoalState extends State<GoalPage>{
  final userRepo = Get.put(UserRepository());

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


class GoalWidget extends StatefulWidget {
  GoalWidget({super.key, required this.name});
  final String name;

  @override
  State<GoalWidget> createState() => _GoalWidgetState();
}

class _GoalWidgetState extends State<GoalWidget> {
  bool _isDeleted = false;
  final userRepo = Get.put(UserRepository());
  String needToFind = "";

  @override
  Widget build(BuildContext context) {
    if (_isDeleted) {
      return const SizedBox.shrink(); // Return an empty widget when deleted
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min, // Ensure Row takes up only as much space as needed
          mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
          children: [
            Text(widget.name), // Access 'name' using the 'widget' property
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              onPressed: () {
                setState(() {
                  // iterate over all the the items in the cardio and weight
                  // lists then see each element and check if that element has the same
                  // field as the name then delete that one out of the database
                  for(int i = 0; i < weightGoals.length; i++){
                    goalRemove("Cardio", widget.name);
                    goalRemove("Weight", widget.name);
                  }
                  _isDeleted = true;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  void goalRemove(String type, String DocDelete) async {
    String? userId = userRepo.getCurrentUserUID();
    final databaseReference = FirebaseFirestore.instance.collection("User_Data");
    databaseReference
        .doc(userId)
        .collection("Goal_Data")
        .doc(type)
        .collection(type)
    // need correct doc string to grab
        .doc(DocDelete)
        .delete();
  }
}