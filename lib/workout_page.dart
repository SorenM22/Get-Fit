import 'package:ctrl_alt_defeat/workout_initial_page.dart';
import 'package:ctrl_alt_defeat/workout_input_page.dart';
import 'package:flutter/material.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPage();
}

class _WorkoutPage extends State<WorkoutPage>{
  int pageType = 0;

  void navigateToInput() {
    setState(() {
      pageType = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageType == 0 ? const WorkoutInitialPage() : const WorkoutInputPage(),

      floatingActionButton: FloatingActionButton(
        onPressed: navigateToInput,
        tooltip: 'Add Stuff',
        child: const Icon(Icons.add),
      )
    );
  }
}