import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class ExerciseWidget extends StatefulWidget {

  const ExerciseWidget({super.key});

  @override
  State<ExerciseWidget> createState() => _ExerciseWidget();

}

class _ExerciseWidget extends State<ExerciseWidget> {

  _ExerciseWidget() {
    populateMenu();
  }

  final databaseReference = FirebaseFirestore.instance;

  String titleText = 'Exercise';
  bool _open = true;
  bool _newExercise = false;
  Icon openIcon = new Icon(CupertinoIcons.minus_circle, size: 40);

  Set<String> optionList = <String>{ 'Select Option' };
  String selectedValue = 'Select Option';

  double boxWidth = 500;

  Size boxSize = Size(250,400);
  List<Widget> sets = [];

  void toggleOpen() {
    setState(() {
      _open = !_open;
      if (_open) {
        boxSize = Size(250,400);
        openIcon = new Icon(CupertinoIcons.minus_circle, size: 40);
      } else {
        boxSize = Size(250,50);
        openIcon = new Icon (CupertinoIcons.plus_circle, size: 40);
      }
    });
  }

  String reps = '';
  String weight = '';
  String newExercise = '';

  void newSet() {
    List<Widget> temp = sets;
    sets = [SetWidget(int.parse(reps), int.parse(weight))];
    sets.addAll(temp);
    setState(() {});
  }

  void populateMenu() {
    List<String>;
    databaseReference.collection('Exercise_Types').doc('Lifting_Exercises').get().then(
            (DocumentSnapshot doc) {
              final data = doc.data() as Map<String, dynamic>;
              List<String> list = List<String>.from(data['Lifting']);
              list.sort();
              Set<String> set = {...list};
              print (set);
              setState(() {
                optionList = { 'Select Option', ...set, 'New Exercise'};
              });
            }
    );
  }

  void dropdownHelper(String value) {
    if(value == 'New Exercise') {
      _newExercise = true;
      titleText = 'Exercise';
    } else {
      _newExercise = false;
      if(value == 'Select Option') {
        titleText = 'Exercise';
      } else {
        titleText = value;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Container(
              height: 50,
              width: boxWidth,
              color: const Color(0xffD4D2D5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Text(titleText,textScaler: TextScaler.linear(2)),
                    IconButton(
                      //alignment: Alignment(-1.0, 1.0),
                        onPressed: toggleOpen,
                        icon: openIcon
                    ),
                  ]
              ),
            ),
            Visibility(
              visible: _open,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Container(
                      color: Color(0xffD4D2D5),
                      height: 50,
                      width: boxWidth,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            DropdownButton<String>(

                              value: selectedValue,
                              onTap: populateMenu,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                  dropdownHelper(newValue);
                                });
                              },
                              items: optionList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ]
                      ),
                    ),
                    Visibility(
                      visible: _newExercise,
                      child: Container(
                        color: Color(0xffD4D2D5),
                        height: 75,
                        width: boxWidth,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget> [
                                    TextField(
                                      onChanged: (text) {
                                        newExercise = text;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        constraints: BoxConstraints.tight(Size(150,50)),
                                        border: OutlineInputBorder(),
                                        hintText: 'Exercise Name',

                                      ),
                                    ),
                                    IconButton(
                                        onPressed: newSet,
                                        icon: const Icon(
                                            CupertinoIcons.plus_circle,
                                            size: 40)
                                    ),
                                  ]
                              ),
                            ]
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xffD4D2D5),
                      height: 100,
                      width: boxWidth,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget> [
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget> [
                                        Text('New Set'),

                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget> [
                                              TextField(
                                                onChanged: (text) {
                                                  reps = text;
                                                },
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  constraints: BoxConstraints.tight(Size(80,50)),
                                                  border: OutlineInputBorder(),
                                                  hintText: 'Reps',

                                                ),
                                              ),

                                              TextField(
                                                onChanged: (text) {
                                                  weight = text;
                                                },
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  constraints: BoxConstraints.tight(Size(80,50)),
                                                  border: OutlineInputBorder(),
                                                  hintText: 'Weight',
                                                ),
                                              ),
                                            ]
                                        )
                                      ]
                                  ),

                                  IconButton(
                                      onPressed: newSet,
                                      icon: const Icon(
                                          CupertinoIcons.plus_circle,
                                          size: 40)
                                  ),
                                ]
                            ),
                          ]
                      ),
                    ),
                  ]
              ),
            ),

            Visibility(
              visible: _open,
              child: Flexible(
                child: Container(
                  color: Color(0xffD4D2D5),
                  width: boxWidth,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: sets.length,
                      itemBuilder: (context, index) => sets[index]
                  ),
                ),
              ),
            ),
          ],
        );
  }


}

class SetWidget extends StatelessWidget {
  int reps = 0;
  int weight = 0;

  SetWidget(this.reps, this.weight, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Flexible(
        child: Container(
          color: Color(0xffD4D2D5),
          height: 25,
          child: Text('$reps reps of $weight lbs'),
        ),
      ),
    );
  }
}

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("couldn't connect");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(

                primarySwatch: Colors.cyan,
              ),
              home: const MyHomePage(title: 'Exercise Widget'),
            );
          }
          Widget loading = MaterialApp();
          return loading;
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            ExerciseWidget(),
            //TextButton(onPressed: removeStudent, child: Text(removeText)),
          ],
        ),
      ),
    );
  }
}
