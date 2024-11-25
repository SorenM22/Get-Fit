import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'exercise_widget.dart';

class WorkoutInputPage extends StatelessWidget {
  const WorkoutInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const WorkoutInputPageImplementation(title: 'Workout Page');
          }
          Widget loading = const MaterialApp();
          return loading;
        });
  }
}

class WorkoutInputPageImplementation extends StatefulWidget {
  const WorkoutInputPageImplementation({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => _WorkoutInputPageState();
}

class _WorkoutInputPageState extends State<WorkoutInputPageImplementation> {
  final db = FirebaseFirestore.instance.collection('User_Data');
  final userRepo = Get.put(UserRepository());

  late CollectionReference<Map<String, dynamic>> workoutRef;

  

  _WorkoutInputPageState() {
    String? UID = userRepo.getCurrentUserUID();

    String workoutID = DateTime.now().toString();


    Map<String, int> data = {};
    db.doc(UID).collection('Workout_Data').doc(workoutID).set(data);

    workoutRef = db.doc(UID).collection('Workout_Data').doc(workoutID).collection('Exercises');

    updateLocalData();
  }

  //_WorkoutInputPageState(this.workoutRef, {super.key});

  List<LiftingWidget> exercises = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> updateLocalData() async {

    //String data = await workoutRef.get().data().toString();
    //print(data);




  }


  void addExercise() {

    Map<String, int> data = {};
    workoutRef.doc(exercises.length.toString()).set(data);

    DocumentReference<Map<String, dynamic>> exerciseRef =
    workoutRef.doc(exercises.length.toString());

    exercises.add(LiftingWidget(exerciseRef));

    setState(() {});
  }

  void submitExercise() async {
    String? userID = userRepo.getCurrentUserUID();

    String currentTime = DateTime.now().toString();

    //REPLACE ME
    for (var i = 0; i < exercises.length; i++) {
      final currentTimeDoc = await db.doc(userID).collection("Workout_Data").doc(currentTime);
      currentTimeDoc.set(<String, String>{
        "type": "cardio"
      });
      currentTimeDoc.collection("Exercise_Name").doc("set$i").set(<String, String>{
        "rep": "5"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Spacer(flex: 1),
      Expanded(
          flex: 20,
          child: Column(children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                      child: Text("Add Exercise:",
                          style: TextStyle(fontSize: 30))),
                  Flexible(
                      child: IconButton(
                          onPressed: addExercise,
                          icon: const Icon(
                              CupertinoIcons.plus_circle,
                              size: 40))),
                ],
              ),
            ),
            Expanded(
                flex: 8,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: exercises.length,
                    itemBuilder: (context, index) => exercises[index])),

          ])),
      const Spacer(
        flex: 1,
      )
    ]);
  }
}