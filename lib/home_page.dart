import 'package:ctrl_alt_defeat/history_page.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_alt_defeat/goal_workout_page.dart';
import 'profile_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  int _selectedPage = 0;
  int _selectedWorkoutOrGoal = 0;

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
  void _onProfileSelected() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void _onLogoutSelected() {
    throw('Logout');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'profile') {
              _onProfileSelected();
            } else if (value == 'logout') {
              _onLogoutSelected();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'profile',
              child: Text('Your Profile'),
            ),
            const PopupMenuItem<String>(
              value: 'logout',
              child: Text('Log Out'),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:  CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue, // Circle color
              child: const Text('P',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
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
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedPage,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _tappedPageSelect,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

