import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:date_field/date_field.dart';

import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
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

                primarySwatch: Colors.blue,
              ),
              home: const MyHomePage(title: 'Form Builder'),
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
  int _counter = 0;

  final databaseReference = FirebaseFirestore.instance.collection('User_Data');
  final String getText = "Create Workout";
  String outText = "";
  String userName = "";
  String completedTime = "";
  String inputHint = "";


  final TextEditingController colorController = TextEditingController();

  //var entryOptions = <String>{};


  Future<void> getEntries() async {


    DocumentSnapshot nameData = await retrieveName();
    String newName = nameData.data().toString();
    newName = newName.substring(newName.indexOf(":")+1, newName.indexOf("}")).trim();
    setState(() {
      userName = "$newName's Workout";
    });

    Map<String, dynamic> entries = new Map();

    DocumentSnapshot data = await retrieveData();

    String s = data.data().toString();

    s = s.substring(1,s.length);

    while(s.indexOf("}") != 0) {
      int i = s.indexOf(":");
      String k = s.substring(0,i);
      setState(() {
        optionList.add(k);
      });
      s = s.substring(i+1, s.length).trim();
      if(s.startsWith("[")) {
        i = s.indexOf("]")+1;
        String v = s.substring(0,i);
        s = s.substring(i+1, s.length).trim();
        entries[k] = v;
      } else if(s.contains(",")) {
        i = s.indexOf(",");
        String v = s.substring(0,i);
        s = s.substring(i+1, s.length).trim();
        entries[k] = v;
      } else {
        i = s.indexOf("}");
        String v = s.substring(0,i);
        s = s.substring(i+1, s.length).trim();
        entries[k] = v;
        break;
      }
    }
    print(entries.toString());

    /*
    setState(() {
      outText = data.data().toString();
    });
     */
  }



  Future<DocumentSnapshot> retrieveData() async {
    return databaseReference.doc("TestUser2").collection("Workout_Data").doc("PpZ3IP4XV3ydVSiMo1lb").get();
  }

  Future<DocumentSnapshot> retrieveName() async {
    return databaseReference.doc("TestUser2").get();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }


  Set<String> optionList = <String>{ 'Select Option' };

  String selectedValue = 'Select Option';

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
            TextButton(onPressed: getEntries, child: Text(getText)),
            Text(userName),


            DateTimeFormField(
              decoration: const InputDecoration(
                labelText: 'Enter Date',
              ),
              firstDate: DateTime.now().add(const Duration(days: 10)),
              lastDate: DateTime.now().add(const Duration(days: 40)),
              initialPickerDateTime: DateTime.now().add(const Duration(days: 20)),
              onChanged: (DateTime? value) {
                //selectedDate = value;
              },
            ),


            DropdownButton<String>(
              value: selectedValue,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                  inputHint = "Enter $selectedValue Data";
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

            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: inputHint,
              ),
            ),


            Text(outText),
            //TextButton(onPressed: removeStudent, child: Text(removeText)),
          ],
        ),
      ),
    );
  }
}

/*
class InvalidDuration implements Exception {}
class InvalidCalories implements Exception {}
class InvalidDifficulty implements Exception {}
class InvalidEntry implements Exception {}
 */
