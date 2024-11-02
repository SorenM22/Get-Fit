import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const WorkoutPageImplementation(title: 'Workout Page');
        }
        Widget loading = const MaterialApp();
        return loading;
      });
  }
}

class WorkoutPageImplementation extends StatefulWidget {
  const WorkoutPageImplementation({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPageImplementation> {
  final db = FirebaseFirestore.instance.collection('User_Data');

  @override void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Text("placeholder")
    );
  }
}