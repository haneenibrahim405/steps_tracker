import 'package:flutter/material.dart';
import 'screens/steps_counter_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steps Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StepsCounterScreen(),
      debugShowCheckedModeBanner: false, // Removed the debug banner
    );
  }
}
