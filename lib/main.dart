import 'package:ctrl_alt_defeat/goal_workout_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetFit',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),

    );
  }
}

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

  void _tappedPageSelect(int index) {
    setState(() {
      _selectedPage = index;
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
      ),
      body: GoalWorkoutPage(title: "Goal/Workout"),

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
