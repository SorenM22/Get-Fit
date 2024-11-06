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
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget> [

          Text("Goal Page", style: TextStyle(fontSize: 24)),
          Text("Running Page", style: TextStyle(fontSize: 20)),
          Text("Miles Ran: ", style: TextStyle(fontSize: 18)),
          Text("Lifting Page", style: TextStyle(fontSize: 20)),
          Text("Max lift on Bench: ", style: TextStyle(fontSize: 18)),
          ElevatedButton(
              onPressed: () {
                goalSubmit();
          }, 
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