import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> emojis = [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetEmoji(emg: "😎", key: UniqueKey()),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetEmoji(emg: "🤠", key: UniqueKey()),
    ),
  ];

  swapEmoji() {
    setState(() {
      emojis.insert(1, emojis.removeAt(0));
    });
    toStringDeep();
  }

  void toStringDeep() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Element root = context as Element;

      void visit(Element element) {
        if (element.widget is GetEmoji && element is StatefulElement) {
          final state = element.state;
          if (state is _GetEmojiState) {
            log("RRRRRRRRRRRRR ${element.toStringDeep()}");
          }
        }
        element.visitChildElements(visit);
      }

      root.visitChildElements(visit);
    });
  }

  @override
  Widget build(BuildContext context) {
    final x = WidgetsBinding.instance.firstFrameRasterized;
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: emojis,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: swapEmoji, child: Text("Swap")),
          ],
        ),
      ),
    );
  }
}

class GetEmoji extends StatefulWidget {
  final String emg;

  GetEmoji({Key? key, required this.emg}) : super(key: key);

  @override
  State<GetEmoji> createState() => _GetEmojiState();
}

class _GetEmojiState extends State<GetEmoji> {
  late String emoji;

  @override
  void initState() {
    emoji = widget.emg;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(emoji, style: TextStyle(fontSize: 100));
  }
}
