import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("couldnt connect");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const HistoryPageImplementation(title: 'Workout History Page');
          }
          Widget loading = const MaterialApp();
          return loading;
    });
  }
}

class HistoryPageImplementation extends StatefulWidget {
  const HistoryPageImplementation({super.key, required this.title});
  final String title;

  @override
  State<HistoryPageImplementation> createState() => _HistoryPageState();
}
class _HistoryPageState extends State<HistoryPageImplementation> {
  final db = FirebaseFirestore.instance.collection('User_Data');

  List<Widget> items = [];

  Future<void> retrieveData() async {
    QuerySnapshot data = await db.get();
    data.docs.asMap().forEach((key, value) {
      final nameData = value.get('Name');
      items.add(ListItem(name: nameData));
    });
    setState(() {

    });
  }

  @override void initState() {
    super.initState();
    retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: items[index],
            );
          },
        )
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(name)),
        const Expanded(child: Text('This is another text input'))
      ]
    );
  }
}