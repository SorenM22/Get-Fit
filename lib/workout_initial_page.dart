import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutInitialPage extends StatelessWidget {
  const WorkoutInitialPage({super.key});



  @override
  Widget build(BuildContext context) {
    TextStyle text = TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: 30
    );

    return Column(
      children: [
        Text(
          "To add a new workout:",
          style: text
        ),
        RichText(
          textAlign: TextAlign.center,
            text: TextSpan(
                children: [
                  TextSpan(
                    text: "Press the big ",
                    style: text
                  ),
                  const WidgetSpan(
                      child: Icon(
                        CupertinoIcons.plus_circle,
                        size: 30
                      ),
                  ),
                  TextSpan(
                      text: " button on the bottom of the screen.",
                      style: text
                  )
                ]
            )
        )
      ],
    );
  }
}