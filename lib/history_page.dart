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

  // Future<void> retrieveData() async {
  //   QuerySnapshot data = await db.get();
  //   data.docs.asMap().forEach((key, value) {
  //     final nameData = value.get('Name');
  //     items.add(ListItem(name: nameData));
  //   });
  //   setState(() {
  //
  //   });
  // }

  Future<void> populateItems(QuerySnapshot data) async {
    // var dataMap = data.docs.asMap();
    // dataMap.forEach((i, value) {
    //   data.
    //   print(value.id);
      // var dataValue = value.get("sets");
      // items.add(ListItem(name: value.id, time: dataValue.toString()));
    // });
  }

  Future<void> retrieveData() async {
    String? userID = userRepo.getCurrentUserUID();
    final workouts = userData.doc(userID).collection("Workout_Data");

    print(workouts.doc());

    await workouts.get().then(populateItems);
    setState(() {

    });
  }

  @override void initState() {
    super.initState();
    retrieveData();
  }

  @override
  Widget build(BuildContext context) {
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
}

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.name, required this.time});
  final String name;
  final String time;

  String truncateString(String str) {
    return str.length < 10 ? str : "${str.substring(0, 10)}...";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Text("Workout: $name")
        ),
        Flexible(
            child: Center(
              child: Text(time),
            )
        )
      ]
    );
  }
}

