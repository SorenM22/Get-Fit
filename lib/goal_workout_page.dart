import 'package:flutter/material.dart';

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
                NavigationDestination(icon: Text("Goal"), label: ""),
                NavigationDestination(icon: Text("Workout"), label: ""),
              ],
              backgroundColor: Colors.white,
              selectedIndex: _selectedWorkoutOrGoal,
              onDestinationSelected: _pressedWorkoutOrGoal,
            ),

            // switch between Goal page and Workout Page
            _selectedWorkoutOrGoal == 0
            // Goal Page
                ? Column(
                children: <Widget> [
                  Text("Goal Page", style: TextStyle(fontSize: 24)),
                  Text("Running Page", style: TextStyle(fontSize: 20)),
                  Text("Miles Ran: ", style: TextStyle(fontSize: 18)),
                  Text("Lifting Page", style: TextStyle(fontSize: 20)),
                  Text("Max lift on Bench: ", style: TextStyle(fontSize: 18))
                ]
            )
            // Workout Page
                : Column(
                children: <Widget> [
                  Text("Workout Page", style: TextStyle(fontSize: 24)),
                  Text("Workout Page", style: TextStyle(fontSize: 24))
                ]
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _pressedAddButton,
        tooltip: 'Add Stuff',
        child: const Icon(Icons.add),
      ),
    );
  }
}