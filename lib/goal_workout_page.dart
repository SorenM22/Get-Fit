import 'package:ctrl_alt_defeat/workout_page.dart';
import 'package:ctrl_alt_defeat/GoalPage.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_alt_defeat/workout_input_page.dart';

class GoalWorkoutPage extends StatefulWidget {
  const GoalWorkoutPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<GoalWorkoutPage> createState() => _GoalWorkoutState();
}

class _GoalWorkoutState extends State<GoalWorkoutPage> {
  int _selectedWorkoutOrGoal = 0;

  void _pressedAddButton() {
    throw UnimplementedError("Unimplemented _pressedAccountButton");
  }

  void _pressedWorkoutOrGoal(int index) {
    setState(() {
      _selectedWorkoutOrGoal = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            NavigationBar(
              destinations: [
                NavigationDestination(icon: Text("Workout", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)), label: ""),
                NavigationDestination(icon: Text("Goal", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)), label: ""),
              ],
              backgroundColor: Theme.of(context).colorScheme.secondary,
              selectedIndex: _selectedWorkoutOrGoal,
              onDestinationSelected: _pressedWorkoutOrGoal,
            ),

            // switch between Goal page and Workout Page
            _selectedWorkoutOrGoal == 0
                //Workout Page
                ? const Expanded(child: WorkoutPage())
                //Goals Page
                : Expanded(child: GoalPage())
          ],
        ),
      ),
    );
  }
}