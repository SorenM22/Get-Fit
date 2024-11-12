import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctrl_alt_defeat/authentication_page.dart';
import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:ctrl_alt_defeat/workout_initial_page.dart';
import 'package:ctrl_alt_defeat/workout_input_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkoutPrefPage extends StatelessWidget {
  WorkoutPrefPage({super.key});

  final userID = Get.put(UserRepository());
  final db = FirebaseFirestore.instance.collection('User_Data');
  
  void pressedCardio() {
    db.doc(userID.getCurrentUserUID()).set(
        {'WorkoutPref' : 'cardio'},
        SetOptions(merge: true)
    );
  }

  void pressedWeights() {
    db.doc(userID.getCurrentUserUID()).set(
        {'WorkoutPref' : 'weights'},
        SetOptions(merge: true)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [

          Text("How do you like to track your workouts?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall),
          TextButton(
            onPressed: pressedCardio,
            child: Text("Time",style: Theme.of(context).textTheme.headlineMedium),
          ),
          TextButton(
              onPressed: pressedWeights,
              child: Text("Sets",style: Theme.of(context).textTheme.headlineMedium,)
          ),
        ],
      ),
    );
  }
}