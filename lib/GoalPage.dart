import 'package:flutter/cupertino.dart';

class GoalPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return GoalState();
  }

}

class GoalState extends State<GoalPage>{
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget> [
          Text("Goal Page", style: TextStyle(fontSize: 24)),
          Text("Running Page", style: TextStyle(fontSize: 20)),
          Text("Miles Ran: ", style: TextStyle(fontSize: 18)),
          Text("Lifting Page", style: TextStyle(fontSize: 20)),
          Text("Max lift on Bench: ", style: TextStyle(fontSize: 18))
        ]
    );
  }
}