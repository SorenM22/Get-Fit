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
    final CollectionReference workouts = userData.doc(userID).collection("Workout_Data");
    QuerySnapshot data = await workouts.get();
    print(await userData.doc(userID).get());

    print(workouts);
    print(data);
    print(userID);
    print(data.docs);
    data.docs.asMap().forEach((key, value) {
      print(value);
    });
    // items.add(ListItem)
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
        Expanded(child: Text(truncateString(name))),
        const Expanded(
            child: Text('This is another text input')
        )
      ]
    );
  }
}

