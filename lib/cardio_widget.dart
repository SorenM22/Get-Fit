import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class CardioWidget extends StatefulWidget {

  DocumentReference<Map<String, dynamic>> exerciseRef;

  CardioWidget(this.exerciseRef, {super.key});

  @override
  State<CardioWidget> createState() => _CardioWidget(exerciseRef);

}

class _CardioWidget extends State<CardioWidget> {

  //DocumentReference<Map<String, dynamic>> workoutRef;
  DocumentReference<Map<String, dynamic>> exerciseRef;

  _CardioWidget(this.exerciseRef) {
    populateMenu();
    // updateLocalData();
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

  String time = '0';
  String calories = '0';
  String newExercise = '';

  void populateMenu() {
    databaseReference.collection('Exercise_Types').doc('Cardio_Exercises').get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          List<String> list = List<String>.from(data['Cardio']);
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
      databaseReference.collection('Exercise_Types').doc('Cardio_Exercises').update({
        'Cardio': FieldValue.arrayUnion([value])
      });
      populateMenu();
      return true;
    }
  }

  void updateDatabase() async {
    exerciseRef.set({'Type' : titleText, 'Time' : time, 'Calories' : calories});
  }

  // Future<void> updateLocalData() async{
  //   QuerySnapshot snap = await exerciseRef.collection('Sets').get();
  //   final allData = snap.docs.map((doc) => doc.data());
  //
  //   for (final e in allData) {
  //     String setString = e.toString();
  //     reps = setString.substring( setString.indexOf(':') + 2,  setString.indexOf(","));
  //     setString = setString.substring( setString.indexOf(","));
  //     weight = setString.substring( setString.indexOf(':') + 2, setString.indexOf("}"));
  //     newSet();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Container(
          height: 50,
          width: boxWidth,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                                ),
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
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                                ),
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
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                                    Text('Workout Data', style: const TextStyle(fontWeight: FontWeight.bold)),

                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget> [
                                          TextField(
                                            onChanged: (text) {
                                              time = text;
                                              updateDatabase();
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              constraints: BoxConstraints.tight(Size(120,50)),
                                              border: OutlineInputBorder(),
                                              hintText: 'Time',

                                            ),
                                          ),

                                          TextField(
                                            onChanged: (text) {
                                              calories = text;
                                              updateDatabase();
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              constraints: BoxConstraints.tight(Size(120,50)),
                                              border: OutlineInputBorder(),
                                              hintText: 'Calories',
                                            ),
                                          ),
                                        ]
                                    )
                                  ]
                              ),

                            ]
                        ),
                      ]
                  ),
                ),
              ]
          ),
        ),


        Container(
          color: Theme.of(context).colorScheme.primary,
          width: boxWidth,
          height: 10,
        ),

      ],
    );
  }


}



class Testy extends StatefulWidget {
  @override
  State<Testy> createState() => _Testy();
}

class _Testy extends State<Testy> {

  final databaseReference = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> d = FirebaseFirestore.instance.collection('Exercise_Types').doc('Cardio_Exercises');

  CollectionReference<Map<String, dynamic>> c = FirebaseFirestore.instance.collection('Exercise_Types');

  String text = 'hi';

  void setText() async {

    String value = 'Something';

    databaseReference.collection('Exercise_Types').doc('Cardio_Exercises').update({
      'Cardio': FieldValue.arrayUnion([value])
    });

    // c.doc('Test').set({'Test': 'Test'});
    // DocumentSnapshot snap = await c.doc('test').get();
    // print(snap.data().toString());



    // await databaseReference.collection('Exercise_Types').doc('Cardio_Exercises').get().then(
    //         (DocumentSnapshot doc) {
    //       final data = doc.data() as Map<String, dynamic>;
    //       List<String> list = List<String>.from(data['t']);
    //       print('\n\nAAAAHHHHHHH$list\n\n');
    //       list.sort();
    //       Set<String> set = {...list};
    //       print (set);
    //
    //       setState(() {
    //         text = set.first;
    //         // optionList = { 'Select Option', ...set, 'New Exercise'};
    //       });
    //     }
    // );

  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Text(text),
          TextButton(onPressed: setText, child: Text('button'))
        ]



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


  final exerciseRef = FirebaseFirestore.instance
      .collection('User_Data')
      .doc('Alvo2aU5lfcDDVVnNoJ1yErGkqz1')
      .collection('Workout_Data')
      .doc('test')
      .collection('Exercises')
      .doc('Test_Exercise');

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
            CardioWidget(exerciseRef),
          ],
        ),
      ),
    );
  }
}
