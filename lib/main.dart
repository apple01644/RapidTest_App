import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer_on_android/quizzer_on_android.dart';
import 'package:quizzer_on_android/test_typing.dart';

import 'package:flutter/services.dart';

void main() async {
  var fontLoader = FontLoader('NanumGothicCoding');
  await fontLoader.load();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapid Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '문제. 데모'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dbAnswer = '제 3차 국민생명 경험표';

  // String case01 = '동해물과 백두산이 마르고 닳도록';
  String case01 = '[동해]물과 [백두산]이 마르고 닳도록';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);

    return Scaffold(
      body: Column(children: <Widget>[
        Container(
          height: 24,
          color: Color(0xffff0000),
        ),
        TypingTest1(testCase: case01)
      ]),
    );
  }
}
