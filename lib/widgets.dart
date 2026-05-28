import 'package:flutter/material.dart';

class BlankScreen extends StatelessWidget {
  const BlankScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: const Text(
        "Tap On Video to Start Watching",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class Loadingwidget extends StatelessWidget {
  const Loadingwidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        children: [
          SizedBox.square(dimension: 15, child: CircularProgressIndicator()),
          SizedBox(width: 20),
          Text('Loading. . . . .', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
