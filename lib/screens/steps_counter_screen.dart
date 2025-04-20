import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';


class StepsCounterScreen extends StatefulWidget {
  const StepsCounterScreen({super.key});

  @override
  State<StepsCounterScreen> createState() => _StepsCounterScreenState();
}

class _StepsCounterScreenState extends State<StepsCounterScreen> {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  int steps = 0;  // Start with 0 steps
  double distance = 0.0;
  double previousDistance = 0.0;

  @override
  void initState() {
    super.initState();
    getPreviousValue();
  }

  // Calculates the magnitude of the accelerometer data
  double getValue(double x, double y, double z) {
    double magnitude = sqrt(x * x + y * y + z * z);
    double modDistance = magnitude - previousDistance;
    setPreviousValue(magnitude);
    return modDistance;
  }



  void setPreviousValue(double distance) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble("preValue", distance);
    previousDistance = distance;
  }


  void getPreviousValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      previousDistance = pref.getDouble("preValue") ?? 0.0;
    });
  }


  Widget stepsBuilder(BuildContext context, AsyncSnapshot<AccelerometerEvent> snapshot) {
    if (snapshot.hasData) {
      x = snapshot.data!.x;
      y = snapshot.data!.y;
      z = snapshot.data!.z;
      distance = getValue(x, y, z);


      if (distance > 7) {
        steps++;
      }

      return Text(
        "$steps",
        style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: Colors.green),
      );
    }
    return const Text("No data");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Use accelerometerEventStream() instead of the deprecated accelerometerEvents
              StreamBuilder<AccelerometerEvent>(
                stream: SensorsPlatform.instance.accelerometerEventStream(),
                builder: stepsBuilder,
              ),
              const SizedBox(height: 30), // Add space before the Refresh button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    steps = 0;
                  });
                },
                child: const Text(
                  'Refresh',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
