import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestControl extends StatefulWidget {
  final Function onAnswered;

  TestControl({Key key, this.onAnswered}) : super(key: key);

  @override
  TestControlState createState() => TestControlState();
}

class TestControlState extends State<TestControl> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Pass'),
      onPressed: () => widget.onAnswered(),
    );
  }
}
