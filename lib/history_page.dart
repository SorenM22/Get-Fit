import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_alt_defeat/presenter/history_presenter.dart';

var historyPresenter = HistoryPresenter();

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const HistoryPageImplementation(
                title: 'Workout History Page');
          }
          Widget loading = const MaterialApp();
          return loading;
        });
  }
}

class HistoryPageImplementation extends StatefulWidget {
  const HistoryPageImplementation({super.key, required this.title});
  final String title;

  @override
  State<HistoryPageImplementation> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPageImplementation> {
  List<Widget> items = [];

  Future<void> retrieveData() async {
    for (var workout in await historyPresenter.getWorkoutIds()) {
      items.add(WorkoutItem(id: workout));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: retrieveData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(widget.title),
                ),
                body: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Container(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        child: ListTile(
                          title: items[index],
                        ));
                  },
                ));
          }
          return const Text("Loading");
        });
  }
}

class WorkoutItem extends StatefulWidget {
  const WorkoutItem({super.key, required this.id});
  final String id;

  @override
  State<WorkoutItem> createState() {
    return _WorkoutItemState();
  }
}

class _WorkoutItemState extends State<WorkoutItem> {
  String getId() {
    return widget.id;
  }

  String truncateString(String str) {
    return str.length < 10 ? str : str.substring(0, 16);
  }

  var exerciseList = [];

  Future<void> retrieveData() async {
    exerciseList = await historyPresenter.getExercises(getId());
  }

  void pressedEditWorkout() {
    historyPresenter.editWorkout(widget.id);
  }

  void deleteExercise() {
    historyPresenter.deleteExercise(getId());
    retrieveData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: retrieveData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Flexible(
                child: Column(
                    children: [
              Row(children: [
                IconButton(
                    onPressed: pressedEditWorkout,
                    icon: Icon(
                        color: Theme.of(context).colorScheme.onSecondary,
                        CupertinoIcons.pencil_ellipsis_rectangle, size: 30)),
                Expanded(child: Text(
                    textAlign: TextAlign.center, "Workout: ${truncateString(getId())}")),
                IconButton(
                    onPressed: deleteExercise,
                    icon: Icon(
                        color: Theme.of(context).colorScheme.onSecondary,
                        CupertinoIcons.trash_circle, size: 30)),
              ]),
              ListView.builder(
                shrinkWrap: true,
                itemCount: exerciseList.length,
                itemBuilder: (context, index) {
                  return ExerciseItem(
                      id: getId(), exercise: exerciseList[index]);
                },
              )
            ]));
          }
          return const Text("Loading");
        });
  }
}

class ExerciseItem extends StatefulWidget {
  const ExerciseItem({super.key, required this.id, required this.exercise});
  final String id;
  final String exercise;

  @override
  State<ExerciseItem> createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  List<List<int>> setList = [];

  String displayExercise = "";

  Future<void> retrieveData() async {
    setList = await historyPresenter.getSets(widget.id, widget.exercise);
    displayExercise = await historyPresenter.getExerciseName(widget.id, widget.exercise);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: retrieveData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Row(children: [
              Text(widget.exercise),
              Flexible(
                  child: Column(children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: setList.length,
                  itemBuilder: (context, index) {
                    return Text(
                        textAlign: TextAlign.center,
                        "Reps:${setList[index][0]} Weight:${setList[index][1]}");
                  },
                )
              ]))
            ]);
          }
          return const Text("Loading");
        });
  }
}
