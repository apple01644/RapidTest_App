import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer_on_android/quizzer_on_android.dart';

Widget buildChooseButton(
    String content, Function onPressed, int idx, TestAnswerButtonState state) {
  Color backgroundColor;
  if (state == TestAnswerButtonState.Normal)
    backgroundColor = Color(0xFFFFFFFF);
  else if (state == TestAnswerButtonState.Answered)
    backgroundColor = Color(0xFF80E080);
  else if (state == TestAnswerButtonState.Wrong)
    backgroundColor = Color(0xFFE08080);
  return Container(
    child: ElevatedButton(
        onPressed: () {
          onPressed(idx);
        },
        child: Text(
          content,
          style: paper_text_style_choose_button,
          textAlign: TextAlign.center,
        ),
        style: OutlinedButton.styleFrom(
            alignment: Alignment.center,
            backgroundColor: backgroundColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            padding: EdgeInsets.all(0))),
    width: 240,
    height: 20,
    margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
  );
}

class TestUnorderedSetControl extends StatefulWidget {
  Function onAnswered;
  TestUnorderedSet testData;
  int testSeq;

  TestUnorderedSetControl(
      {Key key, this.onAnswered, this.testData, this.testSeq})
      : super(key: key);
  List<String> chooseButtonData;
  List<String> answeredChooseButtonData;
  List<TestAnswerButtonState> chooseButtonStates;

  @override
  createState() => TestUnorderedSetControlState();
}

class TestUnorderedSetControlState extends State<TestUnorderedSetControl> {
  static Random rand = new Random();

  @override
  void initState() {
    super.initState();
    buildTestData();
  }

  @override
  didUpdateWidget(covariant TestUnorderedSetControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.testSeq == widget.testSeq) return;
    buildTestData();
  }

  buildTestData() {
    List<String> chooseButtonData = [];
    List<TestAnswerButtonState> chooseButtonStates = [];

    for (String answer in widget.testData.answers) chooseButtonData.add(answer);
    for (String answer in widget.testData.wrongs) chooseButtonData.add(answer);
    chooseButtonData.shuffle(rand);

    for (int x = 0; x < chooseButtonData.length; ++x) {
      chooseButtonStates.add(TestAnswerButtonState.Normal);
    }

    setState(() {
      widget.answeredChooseButtonData = [];
      widget.chooseButtonData = chooseButtonData;
      widget.chooseButtonStates = chooseButtonStates;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chooseButtonData == null) buildTestData();

    List<Widget> buttonList = [];
    int x = 0;
    for (String text in widget.chooseButtonData) {
      buttonList.add(buildChooseButton(text, (idx) {
        setState(() {
          if (widget.answeredChooseButtonData.length <
                  widget.testData.answers.length &&
              widget.chooseButtonStates[idx] == TestAnswerButtonState.Normal) {
            if (widget.testData.answers
                .contains(widget.chooseButtonData[idx])) {
              widget.chooseButtonStates[idx] = TestAnswerButtonState.Answered;
              widget.answeredChooseButtonData.add(widget.chooseButtonData[idx]);
              if (widget.answeredChooseButtonData.length ==
                  widget.testData.answers.length) widget.onAnswered();
            } else
              widget.chooseButtonStates[idx] = TestAnswerButtonState.Wrong;
          }
        });
      }, x, widget.chooseButtonStates[x]));
      x += 1;
    }
    return SingleChildScrollView(child: Column(children: buttonList));
  }
}
