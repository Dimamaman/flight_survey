import 'dart:math';

import 'package:flutter/material.dart';

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

class FlutterCurvesExample extends StatefulWidget {
  const FlutterCurvesExample({Key? key}) : super(key: key);

  @override
  _FlutterCurvesExampleState createState() => _FlutterCurvesExampleState();
}

class _FlutterCurvesExampleState extends State<FlutterCurvesExample> {
  var _width = 40.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Animation Curves', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CurveDisplay(
              curveName: 'Linear',
              curve: Curves.linear,
              width: _width,
            ),
            CurveDisplay(
              curveName: 'Slow Middle',
              curve: Curves.slowMiddle,
              width: _width,
            ),
            CurveDisplay(
              curveName: 'Bounce In',
              curve: Curves.bounceIn,
              width: _width,
            ),
            CurveDisplay(
              curveName: 'Bounce out',
              curve: Curves.bounceOut,
              width: _width,
            ),
            CurveDisplay(
              curveName: 'Decelerate',
              curve: Curves.decelerate,
              width: _width,
            ),

            SizedBox(height: 20),
            CustomButton(
              label: ' Animate 🔥',
              onTap: () {
                setState(() {
                  _width = 300;
                });
              },
            ),
            SizedBox(height: 10),
            CustomButton(
              label: ' Re-set 🔁',
              onTap: () {
                setState(() {
                  _width = 80;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CurveDisplay extends StatelessWidget {
  const CurveDisplay({
    Key? key,
    required double width,
    required this.curveName,
    required this.curve,
  }) : _width = width,
       super(key: key);

  final double _width;
  final String curveName;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(curveName),
        AnimatedContainer(
          width: _width,
          height: 20,
          curve: curve,
          duration: Duration(milliseconds: 700),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

class FlutterMatrixFourExample extends StatefulWidget {
  const FlutterMatrixFourExample({Key? key}) : super(key: key);

  @override
  _FlutterMatrixFourExampleState createState() =>
      _FlutterMatrixFourExampleState();
}

class _FlutterMatrixFourExampleState extends State<FlutterMatrixFourExample> {
  double x = 0;
  double y = 0;
  double z = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('4D MATRIX', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Transform(
          transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0.002, 0, 0, 0, 1)
            ..rotateX(x)
            ..rotateY(y)
            ..rotateZ(z),
          alignment: FractionalOffset.center,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                y = y - details.delta.dx / 100;
                x = x + details.delta.dy / 100;
              });
            },
            child: Container(color: Colors.red, height: 200.0, width: 200.0),
          ),
        ),
      ),
    );
  }
}

class FlutterTransformExample extends StatefulWidget {
  const FlutterTransformExample({Key? key}) : super(key: key);

  @override
  _FlutterTransformExampleState createState() =>
      _FlutterTransformExampleState();
}

class _FlutterTransformExampleState extends State<FlutterTransformExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Transform Widget', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 70),

            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Align(
                child: Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImplicitAnimationsExample extends StatefulWidget {
  const ImplicitAnimationsExample({Key? key}) : super(key: key);

  @override
  _ImplicitAnimationsExampleState createState() =>
      _ImplicitAnimationsExampleState();
}

class _ImplicitAnimationsExampleState extends State<ImplicitAnimationsExample> {
  var _width = 120.0;
  var _height = 140.0;
  var _opacity = 0.0;
  var _angle = 0.0;
  var _animationDuration = Duration(milliseconds: 400);
  late Color _color;
  late double _borderRadius;
  late double _margin;

  @override
  void initState() {
    super.initState();
    _color = randomColor();
    _borderRadius = _randomValue();
    _margin = _randomValue();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  double _randomValue({int max = 80}) {
    return Random().nextDouble() * max;
  }

  Color randomColor() {
    return Color(0xFFFFFFFF & Random().nextInt(0xFFFFFFFF));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'implicit Animations',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(milliseconds: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  width: _width,
                  height: _height,
                  transform: Matrix4.identity()..rotateZ(_angle),
                  transformAlignment: Alignment.center,
                  alignment: Alignment.center,
                  duration: _animationDuration,
                  margin: EdgeInsets.all(_margin),
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          CustomButton(
            onTap: () {
              setState(() {
                _color = randomColor();
                _borderRadius = _randomValue();
                _margin = _randomValue();
              });
            },
            label: ' Change look 👀',
          ),

          SizedBox(height: 20),
          CustomButton(
            onTap: () {
              setState(() {
                _width = _randomValue(max: 200);
                _height = _randomValue(max: 300);
              });
            },
            label: ' Change Size 🤏🏻',
          ),
          SizedBox(height: 20),
          CustomButton(
            onTap: () {
              setState(() {
                _angle = _randomValue();
              });
            },
            label: ' Rotate 🔁',
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class TweenAnimationExample extends StatefulWidget {
  const TweenAnimationExample({Key? key}) : super(key: key);

  @override
  _TweenAnimationExampleState createState() => _TweenAnimationExampleState();
}

class _TweenAnimationExampleState extends State<TweenAnimationExample> {
  var _angle = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Transform Widget', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _angle),
              duration: Duration(seconds: 1),
              child: CustomText('🍑', size: 120),
              builder: (context, value, child) {
                return Transform.rotate(angle: value, child: child);
              },
            ),
            SizedBox(height: 20),
            Slider.adaptive(
              value: _angle,
              max: 180,
              min: 0,
              onChanged: (value) {
                setState(() {
                  _angle = value;
                });
              },
            ),
          ],
        ),
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
