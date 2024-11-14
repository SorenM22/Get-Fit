import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class ExerciseWidget extends StatefulWidget {

  Color color;

  ExerciseWidget(this.color, {super.key});

  @override
  State<ExerciseWidget> createState() => _ExerciseWidget(color);

}

class _ExerciseWidget extends State<ExerciseWidget> {

  _ExerciseWidget(this.widgetColor) {
    populateMenu();
  }

  final databaseReference = FirebaseFirestore.instance;

  Color widgetColor;
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

  String reps = '0';
  String weight = '0';
  String newExercise = '';

  void newSet() {
    List<Widget> temp = sets;
    sets = [SetWidget(int.parse(reps), int.parse(weight), widgetColor)];
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

  bool addExercise(String value) {
    value = value.trim();
    value.toLowerCase();

    String tempValue = '';
    bool _spaceBefore = true;

    value.runes.forEach((int rune) {
      var character = new String.fromCharCode(rune);
      if(_spaceBefore) {
        if(character != ' ') {
          character = character.toUpperCase();
          tempValue = tempValue + character;
        }
      } else {
        tempValue = tempValue + character;
      }
      _spaceBefore = (character == ' ');
    });


    value = tempValue;
    print(value);


    if(optionList.contains(value)) {
      return false;
    } else {
      databaseReference.collection('Exercise_Types').doc('Lifting_Exercises').update({
        'Lifting': FieldValue.arrayUnion([value])
      });
      populateMenu();
      return true;
    }
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
              color: widgetColor,
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
                      color: widgetColor,
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
                        color: widgetColor,
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
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        constraints: BoxConstraints.tight(Size(150,50)),
                                        border: OutlineInputBorder(),
                                        hintText: 'Exercise Name',

                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          if(addExercise(newExercise)) {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text('Success!'),
                                                content: const Text('New exercise type successfully created.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, 'OK'),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text('Error: Duplicate'),
                                                content: const Text('This exercise type already exists.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, 'OK'),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
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
                      color: widgetColor,
                      height: 90,
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
                                        Text('New Set', style: const TextStyle(fontWeight: FontWeight.bold)),

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
                visible: (_open && sets.isNotEmpty),
                child: Container(
                  color: widgetColor,
                  width: boxWidth,
                  height: 25,
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Text('Sets:', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ]
                  ),
                ),
            ),
            Visibility(
              visible: _open,
              child: Flexible(
                child: Container(
                  color: widgetColor,
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
  Color color;

  SetWidget(this.reps, this.weight, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Flexible(
        child: Container(
          color: color,
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
            ExerciseWidget(Color(0xffD4D2D5)),
            //TextButton(onPressed: removeStudent, child: Text(removeText)),
          ],
        ),
      ),
    );
  }
}
