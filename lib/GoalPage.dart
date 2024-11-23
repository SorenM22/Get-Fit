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
          title: Text('Add', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showGoalDialog('Weight');
                  },
                  child: Text('Weight', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showGoalDialog('Cardio');
                  },
                  child: Text('Cardio', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
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
          title: Text("Enter your goal", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          content: TextField(
            controller: goalController,
            decoration: InputDecoration(hintText: "Enter goal for $type"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
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
          Center(child: Text("Cardio Goals", style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.onPrimary))),
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
          Center(child: Text("Weight Goals", style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.onPrimary))),
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
                child: Text("Add Goal", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),)
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
            Text(widget.name, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)), // Access 'name' using the 'widget' property
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              onPressed: () async {
                // Delete the goal from both "Cardio" and "Weight" collections
                await removeGoal("Cardio", widget.name);
                await removeGoal("Weight", widget.name);
                setState(() {
                  _isDeleted = true; // Mark widget as deleted
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> removeGoal(String type, String goalName) async {
    String? userId = userRepo.getCurrentUserUID();
    final databaseReference = FirebaseFirestore.instance.collection("User_Data");

    // Query to find the document ID where the "Goal" matches
    final querySnapshot = await databaseReference
        .doc(userId)
        .collection("Goal_Data")
        .doc(type)
        .collection(type)
        .where("Goal", isEqualTo: goalName)
        .get();

    // Delete the matching document(s)
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}