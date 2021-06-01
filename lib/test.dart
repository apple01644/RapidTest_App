import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer_on_android/quizzer_on_android.dart';
import 'package:quizzer_on_android/testControl.dart';

Widget unansweredBlank({highlight = false}) {
  return Container(
    child: Text('?', style: TextStyle(color: Color(0xFFFFFFFF))),
    padding: EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
        color: Color(highlight ? 0xFF900000 : 0xFF000000),
        borderRadius: BorderRadius.all(Radius.circular(3))),
    height: 18,
  );
}

Widget answeredBlank(String test) {
  return Container(
    child: Text(test, style: TextStyle(color: Color(0xFFFFFFFF))),
    padding: EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
        color: Color(0xFF000000),
        borderRadius: BorderRadius.all(Radius.circular(3))),
    height: 18,
  );
}

class Test extends StatefulWidget {
  final List testData;
  final int seq;
  List<Object> answerList = [];
  List<bool> answeredFlagList = [];
  int currentAnswerSeq = 0;

  Test({Key key, this.testData, this.seq}) : super(key: key);

  @override
  TestState createState() => TestState();
}

class TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
    buildTest();
  }

  @override
  didUpdateWidget(covariant Test oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.seq == widget.seq) return;

    buildTest();
  }

  buildTest() {
    if (widget.testData.length > 0) {
      List<bool> newAnsweredFlagList = [];
      List<Object> newAnswerList = [];
      for (int x = 0; x < widget.testData.length; ++x) {
        var e = widget.testData[x];
        if (!(e is String)) {
          newAnsweredFlagList.add(false);
          newAnswerList.add(e);
        }
      }
      setState(() {
        widget.currentAnswerSeq = 0;
        widget.answeredFlagList = newAnsweredFlagList;
        widget.answerList = newAnswerList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> spanItems = [];
    int answerSeq = 0;
    for (int x = 0; x < widget.testData.length; ++x) {
      var e = widget.testData[x];
      if (e is String) {
        if (e == '\n')
          spanItems.add(Container(width: displayWidth, height: 0));
        else if (e[0] == '#')
          spanItems.add(Container(
              child: Text(
                e.substring(1),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsetsDirectional.only(top: 20)));
        else
          spanItems.add(Container(
              child: Text(e), margin: EdgeInsetsDirectional.only(top: 2)));
      } else {
        if (widget.answeredFlagList.length > 0 &&
            widget.answeredFlagList[answerSeq]) {
          String text = '!';
          if (e is TestTyping)
            text = e.answer;
          else if (e is TestNumber)
            text = formatKoreanNumber(e.answer);
          else if (e is TestUnorderedSet) {
            text = '';
            for (String answer in e.answers) {
              if (text.length > 0) text += ', ';
              text += answer;
            }
          } else if (e is TestOrderedSet) {
            text = '';
            for (String answer in e.answers) {
              if (text.length > 0) text += '→';
              text += answer;
            }
          }
          spanItems.add(answeredBlank(text));
        } else
          spanItems.add(
              unansweredBlank(highlight: answerSeq == widget.currentAnswerSeq));

        ++answerSeq;
      }
    }

    if (widget.answerList.length == 0) buildTest();
    return Row(children: <Widget>[
      Container(
          child: SingleChildScrollView(
            child: Wrap(children: spanItems),
            padding: EdgeInsets.only(left: 30),
          ),
          width: 600),
      Expanded(
          child: Container(
              child: TestControl(
                  testSeq: widget.testData == null
                      ? -widget.currentAnswerSeq - 1
                      : widget.currentAnswerSeq,
                  testData: (widget.currentAnswerSeq < widget.answerList.length
                      ? widget.answerList[widget.currentAnswerSeq]
                      : null),
                  onAnswered: () {
                    setState(() {
                      if (widget.currentAnswerSeq < widget.answerList.length) {
                        widget.answeredFlagList[widget.currentAnswerSeq] = true;
                        if (widget.currentAnswerSeq + 1 <
                            widget.answerList.length)
                          widget.currentAnswerSeq = widget.currentAnswerSeq + 1;
                      }
                    });
                  })))
    ]);
  }
}
