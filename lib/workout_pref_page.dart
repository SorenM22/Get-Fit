import 'package:ctrl_alt_defeat/authentication_page.dart';
import 'package:ctrl_alt_defeat/workout_initial_page.dart';
import 'package:ctrl_alt_defeat/workout_input_page.dart';
import 'package:flutter/material.dart';

class WorkoutPrefPage extends StatelessWidget {
  const WorkoutPrefPage({super.key});

  void pressedCardio() {
    
  }

  void pressedWeights() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [

          Text("How do you like to track your workouts?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall),
          TextButton(
            onPressed: pressedCardio,
            child: Text("Time",style: Theme.of(context).textTheme.headlineMedium),
          ),
          TextButton(
              onPressed: pressedWeights,
              child: Text("Sets",style: Theme.of(context).textTheme.headlineMedium,)
          ),
        ],
      ),
    );
  }
}