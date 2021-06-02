import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer_on_android/quizzer_on_android.dart';

const ParallelTypingTestButtonCount = 56;

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
          style: TextStyle(
              fontFamily: 'NanumGothicCoding',
              fontSize: 16,
              color: Color(0xFF333333)),
          textAlign: TextAlign.center,
        ),
        style: OutlinedButton.styleFrom(
            //  alignment: Alignment.center,
            backgroundColor: backgroundColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            padding: EdgeInsets.all(0))),
    width: 24,
    height: 24,
    margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
  );
}

class TestParallelTypingControl extends StatefulWidget {
  final Function onAnswered;
  final TestParallelTyping testData;
  final int testSeq;

  TestParallelTypingControl(
      {Key key, this.onAnswered, this.testData, this.testSeq})
      : super(key: key);
  List<String> parallelTypingData;
  List<TestAnswerButtonState> parallelTypingButtonStates;
  List<String> parallelTypingAnswer;
  Map<int, String> parallelTypingDisplayAnswer;

  @override
  TestParallelTypingControlState createState() =>
      TestParallelTypingControlState();
}

class TestParallelTypingControlState extends State<TestParallelTypingControl> {
  static const String errorDataSamples =
      '가각간갈감갑강개객갱거건걸검격견결겸경계고곡곤골공과곽관광괘괴교구국군굴궁권궐궤귀규균극근금급긍기긴길나낙난남납낭내녀년념녕노농뇌능니다단달담답당대덕도독돈돌동두둔득등라락란람랑래랭략량려력련렬렴렵령례로록론롱뢰료룡루류륙륜률륭릉리린림립마막만말망매맥맹면멸명모목몰몽묘무묵문물미민밀박반발방배백번벌범법벽변별병보복본봉부북분불붕비빈빙사삭산살삼상새색생서석선설섭성세소속손송쇄쇠수숙순술숭습승시식신실심십쌍씨아악안알암압앙애액야약양어억언엄업여역연열염엽영예오옥온옹와완왈왕외요욕용우운웅원월위유육윤은을음읍응의이익인일임입자작잔잠잡장재쟁저적전절점접정제조족존졸종좌죄주죽준중즉증지직진질집징차착찬찰참창채책처척천철첨첩청체초촉촌총최추축춘출충취측층치칙친칠침칭쾌타탁탄탈탐탑탕태택토통퇴투특파판팔패편평폐포폭표품풍피필하학한할함합항해핵행향허헌험혁현혈혐협형혜호혹혼홀홍화확환활황회획횡효후훈훼휘휴흉흑흡흥희';
  static Random rand = new Random();

  @override
  void initState() {
    super.initState();
    buildTestData();
  }

  @override
  didUpdateWidget(covariant TestParallelTypingControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.testSeq == widget.testSeq) return;
    buildTestData();
  }

  buildTestData() {
    List<String> typingButtonData = [];
    List<TestAnswerButtonState> typingButtonStates = [];

    for (String answer in widget.testData.answers) {
      for (String ch in answer.characters) typingButtonData.add(ch);
    }

    while (typingButtonData.length < ParallelTypingTestButtonCount) {
      typingButtonData
          .add(errorDataSamples[rand.nextInt(errorDataSamples.length)]);
    }
    typingButtonData.sort();

    for (int x = 0; x < ParallelTypingTestButtonCount; ++x) {
      typingButtonStates.add(TestAnswerButtonState.Normal);
    }

    setState(() {
      widget.parallelTypingData = typingButtonData;
      widget.parallelTypingButtonStates = typingButtonStates;
      widget.parallelTypingAnswer =
          widget.testData.answers.map<String>((e) => '').toList();
      widget.parallelTypingDisplayAnswer = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parallelTypingData == null) buildTestData();

    List<Widget> buttonList = [];
    int x = 0;
    for (String text in widget.parallelTypingData) {
      buttonList.add(buildBlankButton(text, (idx) {
        setState(() {
          bool answered = false;
          Map<int, int> mapByAnswerIndex = {};
          for (int x = 0; x < widget.parallelTypingAnswer.length; ++x) {
            mapByAnswerIndex[x] = widget.parallelTypingAnswer[x].length;
          }
          List<MapEntry<int, int>> entries = mapByAnswerIndex.entries.toList();
          entries.sort((MapEntry a, MapEntry b) {
            return b.value - a.value;
          });

          for (var entry in entries) {
            int x = entry.key;
            String answer = widget.testData.answers[x];
            if (widget.parallelTypingAnswer[x].length < answer.length &&
                answer[widget.parallelTypingAnswer[x].length] ==
                    widget.parallelTypingData[idx]) {
              widget.parallelTypingAnswer[x] += widget.parallelTypingData[idx];
              widget.parallelTypingDisplayAnswer[x] =
                  widget.parallelTypingAnswer[x];
              answered = true;
              break;
            }
          }

          if (answered) {
            widget.parallelTypingButtonStates[idx] =
                TestAnswerButtonState.Answered;
            for (int x = 0; x < ParallelTypingTestButtonCount; ++x) {
              if (widget.parallelTypingButtonStates[x] ==
                  TestAnswerButtonState.Wrong)
                widget.parallelTypingButtonStates[x] =
                    TestAnswerButtonState.Normal;
            }

            bool fullyAnswered = true;
            for (int x = 0; x < widget.testData.answers.length; ++x) {
              if (widget.parallelTypingAnswer[x].length !=
                  widget.testData.answers[x].length) {
                fullyAnswered = false;
                break;
              }
            }
            if (fullyAnswered) widget.onAnswered();
          } else {
            widget.parallelTypingButtonStates[idx] =
                TestAnswerButtonState.Wrong;
          }
        });
      }, x, widget.parallelTypingButtonStates[x]));
      x += 1;
    }

    return Column(children: [
      Row(children: buttonList.sublist(0, 8)),
      Row(children: buttonList.sublist(8, 16)),
      Row(children: buttonList.sublist(16, 24)),
      Row(children: buttonList.sublist(24, 32)),
      Row(children: buttonList.sublist(32, 40)),
      Row(children: buttonList.sublist(40, 48)),
      Row(children: buttonList.sublist(48, 56)),
      Container(
          child: SingleChildScrollView(
            child: Column(
                children: widget.parallelTypingDisplayAnswer.entries
                    .map<Widget>((MapEntry<int, String> entry) {
                      String text = entry.value;
                      if (widget.parallelTypingAnswer[entry.key].length !=
                          widget.testData.answers[entry.key].length)
                        text += '...';
                      return Text(text, style: TextStyle(fontSize: 13));
                    })
                    .toList()
                    .reversed
                    .toList()),
            scrollDirection: Axis.vertical,
          ),
          width: 300,
          height: 94)
    ]);
  }
}
