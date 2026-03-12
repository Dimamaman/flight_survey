import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: CarAnimationScreen()));
}

class CarAnimationScreen extends StatefulWidget {
  const CarAnimationScreen({Key? key}) : super(key: key);

  @override
  _CarAnimationScreenState createState() => _CarAnimationScreenState();
}

class _CarAnimationScreenState extends State<CarAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 300,
    );

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("JJJJJJJ ${controller.value}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: controller.value),
              color: Colors.green,
              child: Text('🚗', style: TextStyle(fontSize: 100)),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.forward();
                  },
                  child: Text('Forward'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.stop();
                  },
                  child: Text('Stop'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.reverse();
                  },
                  child: Text('Reverse'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.repeat(reverse: true);
                  },
                  child: Text('Loop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
