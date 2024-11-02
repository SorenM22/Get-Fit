import 'package:flutter/cupertino.dart';

class WorkoutInitialPage extends StatelessWidget {
  const WorkoutInitialPage({super.key});

  final TextStyle text = const TextStyle(
      color: CupertinoColors.black,
      fontSize: 30
  );

  @override
  Widget build(BuildContext context) {
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