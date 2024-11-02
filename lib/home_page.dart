import 'package:ctrl_alt_defeat/models/authentication_repository.dart';
import 'package:ctrl_alt_defeat/history_page.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_alt_defeat/goal_workout_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  int _selectedPage = 0;
  int _selectedWorkoutOrGoal = 0;
  String _username = 'USER NAME';

  Widget homeContentWindow = GoalWorkoutPage(title: "Goal/Workout Page");

  void _tappedPageSelect(int index) {
    setState(() {
      _selectedPage = index;

      switch (index){
        case 2:
          homeContentWindow = Text("SETTINGS PAGE");
        case 1:
          homeContentWindow = HistoryPage(title: "History Page");
        default:
          homeContentWindow = GoalWorkoutPage(title: "Goal/Workout Page");
      }

    });
  }

  void _pressedAccountButton() {
    throw UnimplementedError("Unimplemented _pressedAccountButton");
  }

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: TextButton(
          onPressed: _pressedAccountButton,
          child: Text(_username),
          isSemanticButton: true,),
        actions: [
          TextButton(onPressed: (){
            AuthenticationRepository.instance.logoutUser();
          }, child: Text("Log Out")),
        ],

      ),
      body: homeContentWindow,

      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'settings',
            ),
          ],
          currentIndex: _selectedPage,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _tappedPageSelect
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}