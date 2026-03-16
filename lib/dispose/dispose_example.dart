import 'dart:developer';

import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: ParentScreen()));
}

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  bool _showItem = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() => _showItem = false);
                },
                child: const Text('Itemni dispose qil'),
              ),
              if (_showItem) const MyStatefulItem(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyStatefulItem extends StatefulWidget {
  const MyStatefulItem({super.key});

  @override
  State<MyStatefulItem> createState() => _MyStatefulItemState();
}

class _MyStatefulItemState extends State<MyStatefulItem> {
  @override
  void dispose() {
    debugPrint('MyStatefulItem dispose bo\'ldi');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parentWidget = context.findAncestorWidgetOfExactType<ParentScreen>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final path = <Widget>[];
      context.visitChildElements((element) {
        path.add(element.widget);
      });
      log("JJJJ $path");
    });
    // path da context dan root gacha barcha ancestor widget lar

    return Text('Bu item — tugmani bosganda dispose bo\'ladi ');
  }

  @override
  void didUpdateWidget(covariant MyStatefulItem oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}
