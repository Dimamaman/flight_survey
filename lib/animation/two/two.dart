import 'package:flight_survey/animation/two/widgets/curve_example.dart';
import 'package:flight_survey/animation/two/widgets/matrix_example.dart';
import 'package:flight_survey/animation/two/widgets/transform_example.dart';
import 'package:flight_survey/animation/two/widgets/tween.dart';
import 'package:flutter/material.dart';

import 'widgets/implicit_animations_example.dart';

void main() {
  runApp(const MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Flutter App Design',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CustomText('👉', size: 30),
            title: CustomText('Implicit Animated', size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ImplicitAnimationsExample()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: CustomText('👉', size: 30),
            title: CustomText('Flutter transform', size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FlutterTransformExample()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: CustomText('👉', size: 30),
            title: CustomText('Flutter Matrix4', size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FlutterMatrixFourExample()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: CustomText('👉', size: 30),
            title: CustomText('Flutter Animation curves', size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FlutterCurvesExample()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: CustomText('👉', size: 30),
            title: CustomText('Flutter Tween Animations', size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TweenAnimationExample()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.label, required this.onTap})
    : super(key: key);
  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        width: 300,
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: CustomText(
          label,
          size: 22,
          color: Colors.white,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText(this.text, {Key? key, this.color, this.size, this.weight})
    : super(key: key);
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: size ?? 16,
        fontWeight: weight ?? FontWeight.normal,
      ),
    );
  }
}
