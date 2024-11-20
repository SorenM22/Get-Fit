import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const HistoryPageImplementation(title: 'Workout History Page');
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
  final userRepo = Get.put(UserRepository());
  final userData = FirebaseFirestore.instance.collection('User_Data');

  List<Widget> items = [];

  Future<void> retrieveData() async {
    String? userID = userRepo.getCurrentUserUID();
    final workouts = userData.doc(userID).collection("Workout_Data");

    print(userID);

    await workouts.get().then(
        (exerciseQuerySnapshot) {
          print("completed");
          for(var exerciseDocSnapshot in exerciseQuerySnapshot.docs) {
            var sets = [];
            exerciseDocSnapshot.reference.collection('Exercise_Name').get().then(
              (setQuerySnapshot) {
                print("second completed");
                for (var setDocSnapshot in setQuerySnapshot.docs) {
                  sets.add(setDocSnapshot.data().values.first);
                }
              }
            );
            print(sets);
            items.add(ListItem(id: exerciseDocSnapshot.id,sets: sets));
          }
        }
    );
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
                    return ListTile(
                      title: items[index],
                    );
                  },
                )
            );
          }
          return const Text("Loading");
        }
    );
  }
}

class ListItem extends StatefulWidget {
  ListItem({super.key, required this.id, required this.sets});
  final String id;
  final sets;

  String getId() {
    return id;
  }

  String truncateString(String str) {
    return str.length < 10 ? str : "${str.substring(0, 10)}...";
  }

  @override
  State<ListItem> createState() {
    return _ListItemState();
  }
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Flexible(
              child: Text("Workout: ${widget.truncateString(widget.getId())}")
          ),
          Flexible(
              child: Center(
                child: widget.sets.isEmpty ? Text("No Data") : Text(widget.sets[0]),
              )
          )
        ]
    );
  }
}