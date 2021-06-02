import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzer_on_android/quizzer_on_android.dart';

Widget buildNumberButton(String content, Function onPressed, double delta) {
  return Container(
    child: ElevatedButton(
        onPressed: () {
          onPressed(delta);
        },
        child: Text(
          content,
          style: paper_text_style_number_button,
          textAlign: TextAlign.center,
        ),
        style: OutlinedButton.styleFrom(
            alignment: Alignment.center,
            backgroundColor: Color(0xFFFFFFFF),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2))),
            padding: EdgeInsets.all(0))),
    width: 56,
    height: 19.6,
    margin: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
  );
}

Widget buildFunctionButton(String content, Function onPressed) {
  return Container(
    child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          content,
          style: paper_text_style_choose_button,
          textAlign: TextAlign.center,
        ),
        style: OutlinedButton.styleFrom(
            alignment: Alignment.center,
            backgroundColor: Color(0xFFFFFFFF),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2))),
            padding: EdgeInsets.all(0))),
    width: 56,
    height: 18,
    margin: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
  );
}

class TestNumberControl extends StatefulWidget {
  final Function onAnswered;
  final TestNumber testData;
  final int testSeq;

  TestNumberControl({Key key, this.onAnswered, this.testData, this.testSeq})
      : super(key: key);
  double answerNumber = 0;
  String errorText = '확인';

  @override
  TestNumberControlState createState() => TestNumberControlState();
}

class TestNumberControlState extends State<TestNumberControl> {
  static const Map<String, double> numberList = {
    '.01': 0.01,
    '.05': 0.05,
    '.1': 0.1,
    '.5': 0.5,
    '1': 1,
    '5': 5,
    '10': 10,
    '50': 50,
    '100': 100,
    '500': 500,
    '1000': 1000,
    '5000': 5000,
    '1만': 10000,
    '5만': 50000,
    '10만': 10 * 10000.0,
    '50만': 50 * 10000.0,
    '1백만': 100 * 10000.0,
    '5백만': 500 * 10000.0,
    '1천만': 1000 * 10000.0,
    '5천만': 5000 * 10000.0,
    '1억': 1 * 10000.0 * 10000.0,
    '5억': 5 * 10000.0 * 10000.0,
  };

  @override
  Widget build(BuildContext context) {
    List<Widget> itemList = [];

    numberList.entries.forEach((element) {
      itemList.add(Row(children: [
        buildNumberButton('-' + element.key, (delta) {
          setState(() {
            widget.answerNumber += delta;
            widget.answerNumber =
                (widget.answerNumber * 100).roundToDouble() / 100.0;
          });
        }, -element.value),
        buildNumberButton('+' + element.key, (delta) {
          setState(() {
            widget.answerNumber += delta;
            widget.answerNumber =
                (widget.answerNumber * 100).roundToDouble() / 100.0;
          });
        }, element.value),
      ]));
    });

    return Column(children: [
      Row(children: [
        Column(children: itemList.sublist(0, 11)),
        Column(children: itemList.sublist(11, 22))
      ]),
      Row(children: [
        Column(children: [
          buildFunctionButton(
            'CLS',
            () {
              setState(() {
                widget.answerNumber = 0;
              });
            },
          ),
          buildFunctionButton(widget.errorText, () {
            setState(() {
              if (widget.answerNumber > widget.testData.answer * 3)
                setState(() {
                  widget.errorText = '↓↓↓';
                });
              else if (widget.answerNumber * 3 < widget.testData.answer)
                setState(() {
                  widget.errorText = '↑↑↑';
                });
              else if (widget.answerNumber > widget.testData.answer * 2)
                setState(() {
                  widget.errorText = '↓↓';
                });
              else if (widget.answerNumber * 2 < widget.testData.answer)
                setState(() {
                  widget.errorText = '↑↑';
                });
              else if (widget.answerNumber > widget.testData.answer)
                setState(() {
                  widget.errorText = '↓';
                });
              else if (widget.answerNumber < widget.testData.answer)
                setState(() {
                  widget.errorText = '↑';
                });
              else
                widget.onAnswered();
            });
          })
        ]),
        Column(children: [
          Text(
              //widget.answerNumber.toString().replaceFirst(RegExp(r'\.0+$'), '')
              NumberFormat().format(widget.answerNumber)
            ,
              style: TextStyle(fontSize: 20)),
          Text(
            formatKoreanNumber(widget.answerNumber),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.left,
          )
        ]),
      ])
    ]);
  }
}
