import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctrl_alt_defeat/history_page.dart';
import 'package:ctrl_alt_defeat/models/authentication_repository.dart';
import 'package:ctrl_alt_defeat/presenter/profile_avatar_icon_presenter.dart';
import 'package:ctrl_alt_defeat/views/profile_avatar_widget.dart';
import 'package:ctrl_alt_defeat/workout_pref_page.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_alt_defeat/goal_workout_page.dart';
import 'package:get/get.dart';
import 'models/user_repository.dart';
import 'profile_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _selectedPage = 0;
  String _username = 'USER NAME';
  final user = Get.put(UserRepository());
  final db = FirebaseFirestore.instance.collection("User_Data");
  final profileController = Get.put(ProfileController());

  String profileColor = Colors.blue.hex;
  String profileInitial = 'P';

  @override
  void initState() {
    profileController.fetchProfileData();
    //  db.doc(user.getCurrentUserUID()).get().then((grabColor){
    //       if(grabColor.get("Profile Color")){
    //         profileColor = grabColor.get("Profile Color");
    //       } else {
    //         db.doc(user.getCurrentUserUID()).set(
    //           {'Profile Color': Colors.blue.hex},
    //           SetOptions(merge: true),
    //         );
    //       }
    //
    //     });

    //  db.doc(user.getCurrentUserUID()).get().then((grabName){
    //   profileInitial = grabName.get("Name")[0];
    // });

    super.initState();
  }

  Widget homeContentWindow = GoalWorkoutPage(title: "Goal/Workout Page");

  void _tappedBottomNavBar(int index) {
    setState(() {
      _selectedPage = index;
      switch (index){
        case 2:
          homeContentWindow = WorkoutPrefPage();
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

  void _onLogoutSelected() {
    throw('Logout');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
        leading: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'profile') {
              _tappedProfileButton();
            } else if (value == 'logout') {
              AuthenticationRepository.instance.signout();
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
            child: ProfileAvatar(),
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

        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).colorScheme.onSecondary,

        onTap: _tappedBottomNavBar,
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _tappedProfileButton() async {
    final Color? updatedColor = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(title: 'Profile Page'),
      ),
    );
    if(updatedColor!=null) {
      setState(() {
        profileColor = updatedColor.hex;
      });
    }
  }
}