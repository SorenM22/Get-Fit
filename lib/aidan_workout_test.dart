import 'package:flutter/material.dart';

class GoalWorkoutPage extends StatefulWidget {
  const GoalWorkoutPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<GoalWorkoutPage> createState() => _GoalWorkoutState();
}

class _GoalWorkoutState extends State<GoalWorkoutPage> {
  int _selectedWorkoutOrGoal = 0;
  List<String> workouts = [];
  List<String> goals = [];

  void _showOptionsForAdd() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add'),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _pressedAddButton('Goal');
                  },
                  child: Text('Goal'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _pressedAddButton('Weight');
                  },
                  child: Text('Weight'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _pressedAddButton('Cardio');
                  },
                  child: Text('Cardio'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pressedAddButton(String type) {
    setState(() {
      final Map<String, List<String>> itemMap = {
        'Goal': goals,
        'Weight': workouts,
        'Cardio': workouts,
      };

      final list = itemMap[type];
      if (list != null) {
        list.add('$type ${list.length + 1}');
      }
    });
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

            // Goal Page
            Expanded(
                child: _selectedWorkoutOrGoal == 0
                    ? ListView(
                    children: <Widget> [
                      Center(child: Text("Goals Page", style: TextStyle(fontSize: 24))),
                      ...goals.map((goal) => Center(child: Text(goal, style: TextStyle(fontSize: 20)))),
                    ]
                )
                // Workout Page
                    : ListView(
                    children: <Widget> [
                      Center(child: Text("Workout Page", style: TextStyle(fontSize: 24))),
                      ...workouts.map((workout) => Center(child: Text(workout, style: TextStyle(fontSize: 20)))),
                    ]
                )
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showOptionsForAdd,
        tooltip: 'Add Stuff',
        child: const Icon(Icons.add),
      ),
    );
  }
}