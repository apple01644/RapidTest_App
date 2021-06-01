import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer_on_android/quizzer_on_android.dart';
import 'package:quizzer_on_android/testChooseControl.dart';
import 'package:quizzer_on_android/testNumberControl.dart';
import 'package:quizzer_on_android/testTypingControl.dart';

Widget TestControl({Function onAnswered, var testData, int testSeq}) {
  Widget control;

  if (testData == null)
    control = Text('Done!');
  else if (testData is TestTyping) {
    control = TestTypingControl(
      testData: testData,
      testSeq: testSeq,
      onAnswered: onAnswered,
    );
  } else if (testData is TestUnorderedSet) {
    control = TestUnorderedSetControl(
      testData: testData,
      testSeq: testSeq,
      onAnswered: onAnswered,
    );
  } else if (testData is TestNumber) {
    control = TestNumberControl(
      testData: testData,
      testSeq: testSeq,
      onAnswered: onAnswered,
    );
  } else {
    control = Text(testData.runtimeType.toString());
  }

  return Column(children: [
    Container(child: control, height: 290),
    TextButton(
      child: Text('Pass'),
      onPressed: () => onAnswered(),
    )
  ]);
}
