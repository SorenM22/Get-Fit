import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_alt_defeat/presenter/history_presenter.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
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

  List<Widget> items = [];

  Future<void> retrieveData() async {
    var historyPresenter = HistoryPresenter();

    for(var workout in await historyPresenter.getWorkoutIds()) {
      for(var exercise in await historyPresenter.getExercises(workout)) {
        for (var sets in await historyPresenter.getSets(workout, exercise)) {
          items.add(ListItem(id: workout, sets: sets));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: retrieveData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
          return const Text("Loading");
        }
    );
  }
}

class ListItem extends StatefulWidget {
  ListItem({super.key, required this.id, required this.sets});
  final String id;
  final sets;

  String getId() {
    return id;
  }

  String truncateString(String str) {
    return str.length < 10 ? str : str.substring(0, 16);
  }

  @override
  State<ListItem> createState() {
    return _ListItemState();
  }
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Flexible(
              child: Text("Workout: ${widget.truncateString(widget.getId())}")
          ),
          Flexible(
              child: Center(
                child: widget.sets.isEmpty ? Text("No Data") : Text(widget.sets[0].toString()),
              )
          )
        ]
    );
  }
}