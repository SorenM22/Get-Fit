import 'package:flutter/material.dart';
import 'package:sparkline/sparkline.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Line Graph',
      home: LineChartSample(),
    );
  }
}

class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<double> data = [5.0, 20.0, 10.0, 25.0, 40.0, 60.0, 40.0, 80.0, 70.0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Line Graph Sample'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Sparkline(
            data: data,
            lineColor: Colors.blue,
            fillMode: FillMode.below,
            fillColor: Colors.blue.withOpacity(0.3),
            lineWidth: 3.0,
          ),
        ),
      ),
    );
  }
}
