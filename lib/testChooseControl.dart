import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer_on_android/quizzer_on_android.dart';

enum ChooseTestButtonState { Normal, Answered, Wrong }

Widget buildChooseButton(
    String content, Function onPressed, int idx, ChooseTestButtonState state) {
  Color backgroundColor;
  if (state == ChooseTestButtonState.Normal)
    backgroundColor = Color(0xFFFFFFFF);
  else if (state == ChooseTestButtonState.Answered)
    backgroundColor = Color(0xFF80E080);
  else if (state == ChooseTestButtonState.Wrong)
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
                borderRadius: BorderRadius.all(Radius.circular(8))))),
    width: 240,
    height: 20,
    margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
  );
}

class TestUnorderedSetControl extends StatefulWidget {
  final Function onAnswered;
  final TestUnorderedSet testData;
  final int testSeq;

  TestUnorderedSetControl(
      {Key key, this.onAnswered, this.testData, this.testSeq})
      : super(key: key);
  List<String> chooseButtonData;
  List<String> answeredChooseButtonData;
  List<ChooseTestButtonState> chooseButtonStates;

  @override
  TestUnorderedSetControlState createState() => TestUnorderedSetControlState();
}

class TestUnorderedSetControlState extends State<TestUnorderedSetControl> {
  static const String errorDataSamples =
      '가각간갈감갑강개객갱거건걸검격견결겸경계고곡곤골공과곽관광괘괴교구국군굴궁권궐궤귀규균극근금급긍기긴길나낙난남납낭내녀년념녕노농뇌능니다단달담답당대덕도독돈돌동두둔득등라락란람랑래랭략량려력련렬렴렵령례로록론롱뢰료룡루류륙륜률륭릉리린림립마막만말망매맥맹면멸명모목몰몽묘무묵문물미민밀박반발방배백번벌범법벽변별병보복본봉부북분불붕비빈빙사삭산살삼상새색생서석선설섭성세소속손송쇄쇠수숙순술숭습승시식신실심십쌍씨아악안알암압앙애액야약양어억언엄업여역연열염엽영예오옥온옹와완왈왕외요욕용우운웅원월위유육윤은을음읍응의이익인일임입자작잔잠잡장재쟁저적전절점접정제조족존졸종좌죄주죽준중즉증지직진질집징차착찬찰참창채책처척천철첨첩청체초촉촌총최추축춘출충취측층치칙친칠침칭쾌타탁탄탈탐탑탕태택토통퇴투특파판팔패편평폐포폭표품풍피필하학한할함합항해핵행향허헌험혁현혈혐협형혜호혹혼홀홍화확환활황회획횡효후훈훼휘휴흉흑흡흥희';
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
    List<ChooseTestButtonState> chooseButtonStates = [];

    for (String answer in widget.testData.answers) chooseButtonData.add(answer);
    for (String answer in widget.testData.wrongs) chooseButtonData.add(answer);
    chooseButtonData.shuffle();

    for (int x = 0; x < chooseButtonData.length; ++x) {
      chooseButtonStates.add(ChooseTestButtonState.Normal);
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
              widget.chooseButtonStates[idx] == ChooseTestButtonState.Normal) {
            if (widget.testData.answers
                .contains(widget.chooseButtonData[idx])) {
              widget.chooseButtonStates[idx] = ChooseTestButtonState.Answered;
              widget.answeredChooseButtonData.add(widget.chooseButtonData[idx]);
              if (widget.answeredChooseButtonData.length ==
                  widget.testData.answers.length) widget.onAnswered();
            } else
              widget.chooseButtonStates[idx] = ChooseTestButtonState.Wrong;
          }
        });
      }, x, widget.chooseButtonStates[x]));
      x += 1;
    }
    return SingleChildScrollView(child: Column(children: buttonList));
  }
}
