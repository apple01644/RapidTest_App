import 'dart:async' show Future;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:quizzer_on_android/quizzer_on_android.dart';
import 'package:quizzer_on_android/testView.dart';

Future<String> loadAsset(String filename) async {
  return await rootBundle.loadString('assets/text/' + filename + '.txt');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var fontLoader = FontLoader('NanumGothicCoding');
  await fontLoader.load();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);

  const files = [
    '0523-금융사고예방지침',
    '0524-금융실명제',
    '0525-자금세탁방지법',
    '0526-여신 기본용어 프로세스',
    '0527-가계자금대출 취급기준의 이해',
    '0529-주택담보대출의 이해',
    '0531-주택청약상품',
    '0531-예금신규',
    '0602-수신총칙',
    '0604-당좌,어음',
    '0605-신탁',
    '0605-퇴직연금 업무',
    '0606-펀드',
    '0607-방카슈랑스',
    '0609-외환 업무',
    '0612-신용카드',
    '0613-대행',
    '0613-자동이체',
    '0613-전자금융'
  ];
  var dataset = Map<String, String>.identity();

  for (var filename in files) {
    dataset[filename] = await loadAsset(filename);
  }

  runApp(MyApp(dataset: dataset));
}

class MyApp extends StatelessWidget {
  final Map<String, String> dataset;

  MyApp({this.dataset});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapid Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '문제. 데모', dataset: dataset),
    );
  }
}

class IndexControl extends StatelessWidget {
  final int dataCount;
  final int value;
  final Function onChange;

  IndexControl({this.dataCount, this.value, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      TextButton(
          child: Text('◀'),
          onPressed: () => onChange((value - 1 + dataCount) % dataCount)),
      Text(value.toString()),
      TextButton(
        child: Text('▶'),
        onPressed: () => onChange((value + 1) % dataCount),
      )
    ]);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.dataset}) : super(key: key);
  final String title;
  final Map<String, String> dataset;

  final Object data = '';
  int dataIndex = 0;
  String mode = '0523-금융사고예방지침'; // '0523-금융사고예방지침';
  String content = '';
  List testData;
  int testSequence = 0;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static Random rand = new Random();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskBar = Container(
      height: 24,
      color: Color(0xffff0000),
    );

    print(MediaQuery.of(context).size);

    final dropdownItems = widget.dataset.keys
        .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
              child: Text(e),
              value: e,
            ))
        .toList();

    if (widget.testData == null) {
      setState(() {
        widget.testData = exportTestData(widget.dataset[widget.mode]);
      });
    }
    if (widget.testSequence == 0) {
      setState(() {
        widget.testSequence = widget.testSequence + 1;
      });
    }
    return Scaffold(
        body: Column(children: [
      taskBar,
      Expanded(
          child: Test(testData: widget.testData, seq: widget.testSequence)),
      Container(
        child: Row(children: [
          IndexControl(
              value: widget.dataIndex,
              dataCount: widget.dataset.length,
              onChange: (int data) => setState(() {
                    widget.dataIndex = data;
                    String newMode =
                        widget.dataset.keys.elementAt(widget.dataIndex);
                    widget.mode = newMode;
                    widget.testData = exportTestData(widget.dataset[newMode]);
                    widget.testSequence = widget.testSequence + 1;
                  })),
          DropdownButton<String>(
              items: dropdownItems,
              value: widget.mode,
              onChanged: (String newMode) => setState(() {
                    widget.dataIndex =
                        widget.dataset.keys.toList().indexOf(newMode);
                    widget.mode = newMode;
                    widget.testData = exportTestData(widget.dataset[newMode]);
                    widget.testSequence = widget.testSequence + 1;
                  })),
          Expanded(
              child: Container(
            child: TextButton(
              onPressed: () {
                setState(() {
                  widget.dataIndex = rand.nextInt(widget.dataset.length);
                  widget.mode = widget.dataset.keys.elementAt(widget.dataIndex);
                  widget.testData = exportTestData(widget.dataset[widget.mode]);
                  widget.testSequence = widget.testSequence + 1;
                });
              },
              child: Text('Random'),
            ),
            alignment: Alignment.centerRight,
          ))
          //TypingTest1(testCase: dataset[0]),
        ]),
        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1))),
      )
    ]));
  }
}
