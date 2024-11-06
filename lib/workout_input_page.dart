import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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

  List<ExerciseWidget> exercises = [];

  @override
  void initState() {
    super.initState();
  }

  void addExercise() {
    exercises.add(const ExerciseWidget());
    setState(() {});
  }

  void submitExercise() async {
    //IMPLEMENT ME
    String? userID = userRepo.getCurrentUserUID();

    DateTime currentTime = DateTime.now();

    for (final exercise in exercises) {
      await db.doc(userID.toString()).collection("Workout_Data").doc(currentTime.toString()).set({
        exercise.getText(): {

        }
      });
    }

    print(userID);
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
            OutlinedButton(
                onPressed: submitExercise, child: const Text("Submit"))
          ])),
      const Spacer(
        flex: 1,
      )
    ]);
  }
}

class ExerciseWidget extends StatelessWidget {
  const ExerciseWidget({super.key});

  static const String text = 'New Exercise';

  String getText() {
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return const Wrap(children: [Text(text)]);
  }
}
