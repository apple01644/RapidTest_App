import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer_on_android/quizzer_on_android.dart';

const TypingTestButtonCount = 42;

class TestTypingControl extends StatefulWidget {
  final Function onAnswered;
  final TestTyping testData;
  final int testSeq;

  TestTypingControl({Key key, this.onAnswered, this.testData, this.testSeq})
      : super(key: key);
  List<String> typingData;
  List<TestAnswerButtonState> typingButtonStates;
  String typingAnswerDisplay = '';

  @override
  TestTypingControlState createState() => TestTypingControlState();
}

Widget buildBlankButton(
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
          style: paper_text_style_blank_button,
          textAlign: TextAlign.center,
        ),
        style: OutlinedButton.styleFrom(
            alignment: Alignment.center,
            backgroundColor: backgroundColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            padding: EdgeInsets.all(0))),
    width: 35,
    height: 35,
    margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
  );
}

class TestTypingControlState extends State<TestTypingControl> {
  static const String errorDataSamples =
      '가각간갈감갑강개객갱거건걸검격견결겸경계고곡곤골공과곽관광괘괴교구국군굴궁권궐궤귀규균극근금급긍기긴길나낙난남납낭내녀년념녕노농뇌능니다단달담답당대덕도독돈돌동두둔득등라락란람랑래랭략량려력련렬렴렵령례로록론롱뢰료룡루류륙륜률륭릉리린림립마막만말망매맥맹면멸명모목몰몽묘무묵문물미민밀박반발방배백번벌범법벽변별병보복본봉부북분불붕비빈빙사삭산살삼상새색생서석선설섭성세소속손송쇄쇠수숙순술숭습승시식신실심십쌍씨아악안알암압앙애액야약양어억언엄업여역연열염엽영예오옥온옹와완왈왕외요욕용우운웅원월위유육윤은을음읍응의이익인일임입자작잔잠잡장재쟁저적전절점접정제조족존졸종좌죄주죽준중즉증지직진질집징차착찬찰참창채책처척천철첨첩청체초촉촌총최추축춘출충취측층치칙친칠침칭쾌타탁탄탈탐탑탕태택토통퇴투특파판팔패편평폐포폭표품풍피필하학한할함합항해핵행향허헌험혁현혈혐협형혜호혹혼홀홍화확환활황회획횡효후훈훼휘휴흉흑흡흥희';
  static Random rand = new Random();

  @override
  void initState() {
    super.initState();
    buildTestData();
  }

  @override
  didUpdateWidget(covariant TestTypingControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.testSeq == widget.testSeq) return;
    buildTestData();
  }

  buildTestData() {
    List<String> typingButtonData = [];
    List<TestAnswerButtonState> typingButtonStates = [];
    for (int x = 0; x < widget.testData.answer.length; ++x) {
      typingButtonData.add(widget.testData.answer[x]);
    }
    for (int y = 0; y < widget.testData.wrongs.length; ++y) {
      for (int x = 0; x < widget.testData.wrongs[y].length; ++x) {
        typingButtonData.add(widget.testData.wrongs[y][x]);
      }
    }

    while (typingButtonData.length < TypingTestButtonCount) {
      typingButtonData
          .add(errorDataSamples[rand.nextInt(errorDataSamples.length)]);
    }
    typingButtonData.sort();

    for (int x = 0; x < TypingTestButtonCount; ++x) {
      typingButtonStates.add(TestAnswerButtonState.Normal);
    }

    setState(() {
      widget.typingData = typingButtonData;
      widget.typingButtonStates = typingButtonStates;
      widget.typingAnswerDisplay = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typingData == null) buildTestData();

    List<Widget> buttonList = [];
    int x = 0;
    for (String text in widget.typingData) {
      buttonList.add(buildBlankButton(text, (idx) {
        setState(() {
          if (widget.typingAnswerDisplay.length <
                  widget.testData.answer.length &&
              widget.typingButtonStates[idx] == TestAnswerButtonState.Normal) {
            if (widget.testData.answer[widget.typingAnswerDisplay.length] ==
                widget.typingData[idx]) {
              widget.typingAnswerDisplay += widget.typingData[idx];
              if (widget.typingAnswerDisplay.length ==
                  widget.testData.answer.length) widget.onAnswered();
              widget.typingButtonStates[idx] = TestAnswerButtonState.Answered;
              for (int x = 0; x < TypingTestButtonCount; ++x) {
                if (widget.typingButtonStates[x] == TestAnswerButtonState.Wrong)
                  widget.typingButtonStates[x] = TestAnswerButtonState.Normal;
              }
            } else
              widget.typingButtonStates[idx] = TestAnswerButtonState.Wrong;
          }
        });
      }, x, widget.typingButtonStates[x]));
      x += 1;
    }
    return Column(children: [
      Row(children: buttonList.sublist(0, 6)),
      Row(children: buttonList.sublist(6, 12)),
      Row(children: buttonList.sublist(12, 18)),
      Row(children: buttonList.sublist(18, 24)),
      Row(children: buttonList.sublist(24, 30)),
      Row(children: buttonList.sublist(30, 36)),
      Row(children: buttonList.sublist(36, 42)),
      Text(widget.typingAnswerDisplay, style: TextStyle(fontSize: 13))
    ]);
  }
}
