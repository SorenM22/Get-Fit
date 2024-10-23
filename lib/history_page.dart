import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.title});
  final String title;

  static const List<String> items = ['0', '1', '2', '3', '4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: ListItem(name: items[index]),
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