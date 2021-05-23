import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:quizzer_on_android/quizzer_on_android.dart';

import 'package:flutter/services.dart';

enum TestTypingTokenType { Desc, Blank }

class TestTypingToken {
  final String content;
  final TestTypingTokenType type;

  const TestTypingToken({this.content, this.type});
}

const int buttonCount = 80;

class TypingTest {
  List<TestTypingToken> tokenList = [];
  List<String> testData = [];
  List<String> buttons = [];

  static const String errorDataSamples =
      '가각간갈감갑강개객갱거건걸검격견결겸경계고곡곤골공과곽관광괘괴교구국군굴궁권궐궤귀규균극근금급긍기긴길나낙난남납낭내녀년념녕노농뇌능니다단달담답당대덕도독돈돌동두둔득등라락란람랑래랭략량려력련렬렴렵령례로록론롱뢰료룡루류륙륜률륭릉리린림립마막만말망매맥맹면멸명모목몰몽묘무묵문물미민밀박반발방배백번벌범법벽변별병보복본봉부북분불붕비빈빙사삭산살삼상새색생서석선설섭성세소속손송쇄쇠수숙순술숭습승시식신실심십쌍씨아악안알암압앙애액야약양어억언엄업여역연열염엽영예오옥온옹와완왈왕외요욕용우운웅원월위유육윤은을음읍응의이익인일임입자작잔잠잡장재쟁저적전절점접정제조족존졸종좌죄주죽준중즉증지직진질집징차착찬찰참창채책처척천철첨첩청체초촉촌총최추축춘출충취측층치칙친칠침칭쾌타탁탄탈탐탑탕태택토통퇴투특파판팔패편평폐포폭표품풍피필하학한할함합항해핵행향허헌험혁현혈혐협형혜호혹혼홀홍화확환활황회획횡효후훈훼휘휴흉흑흡흥희';
  static Random rand = new Random();

  TestTypingTokenType _mode = TestTypingTokenType.Desc;
  String _buffer = '';

  void flush(TestTypingTokenType newMode) {
    if (_buffer.length > 0) {
      tokenList.add(TestTypingToken(content: _buffer, type: _mode));
      if (_mode == TestTypingTokenType.Blank) {
        testData.add(_buffer);
      }
      _buffer = '';
    }
    _mode = newMode;
  }

  TypingTest(String input) {
    for (var ch in input.characters) {
      switch (_mode) {
        case TestTypingTokenType.Blank:
          if (ch == ' ') {
            _mode = TestTypingTokenType.Desc;
            flush(TestTypingTokenType.Blank);
            break;
          }
          if (ch == ']') {
            flush(TestTypingTokenType.Desc);
            break;
          }
          _buffer += ch;
          flush(TestTypingTokenType.Blank);
          break;
        case TestTypingTokenType.Desc:
          if (ch == '[') {
            flush(TestTypingTokenType.Blank);
            break;
          }
          _buffer += ch;
          break;
      }
    }
    flush(_mode);

    assert(buttons.length == 0);
    for (int x = 0; x < buttonCount; ++x) {
      buttons.add('X');
    }

    for (String testAnswer in testData) {
      int x = -1;
      do {
        x = rand.nextInt(buttonCount);
      } while (buttons[x] != 'X');
      buttons[x] = testAnswer;
    }

    for (int x = 0; x < buttonCount; ++x) {
      if (buttons[x] == 'X') {
        String errorSampleData = 'X';
        do {
          errorSampleData =
              errorDataSamples[rand.nextInt(errorDataSamples.length)];
        } while (testData.contains(errorSampleData));
        buttons[x] = errorSampleData;
      }
    }
    buttons.sort();
  }

  bool guess(int idx, String guessData, int targetIndex) {
    if (targetIndex == testData.length) return false;
    if (testData[targetIndex] != guessData) {
      return false;
    }
    return true;
  }
}

Widget buildBlank(String content, {noBlank: false}) {
  double size = isHangulSyllables(content) ? 36 : 20;
  return Container(
    child: Text(noBlank ? content : '?', style: paper_text_style_hidden),
    width: size,
    height: 36,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(),
      color: Color(0xFF404040),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    margin: EdgeInsets.symmetric(horizontal: 1),
  );
}

Widget buildBlankButton(String content, VoidCallback onPressed, int idx,
    {bool highlight}) {
  return Container(
    child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          content,
          style: paper_text_style_blank_button,
          textAlign: TextAlign.center,
        ),
        style: OutlinedButton.styleFrom(
            minimumSize: Size(36, 36),
            alignment: Alignment.center,
            backgroundColor: Color(highlight ? 0xFFFF0000 : 0xFFFFFFFF),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))))),
    width: 36,
    height: 36,
    margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
  );
}

class TypingTest1 extends StatefulWidget {
  TypingTest1({Key key, this.testCase}) : super(key: key);
  final String testCase;

  List<bool> _buttonHighlightList = [];
  List<String> _buttons = [];
  List<String> _userData = [];
  List<TestTypingToken> _tokenList = [];
  TypingTest _typingTest;

  @override
  _TypingTestState createState() => _TypingTestState();
}

class _TypingTestState extends State<TypingTest1> {
  @override
  void initState() {
    super.initState();

    setState(() {
      List<bool> buttonHighlightList = [];
      for (int x = 0; x < buttonCount; ++x) buttonHighlightList.add(false);

      widget._buttonHighlightList = List.from(buttonHighlightList);
    });

    updateTestData();
  }

  void updateTestData() {
    setState(() {
      print('GGGG');
      widget._typingTest = TypingTest(widget.testCase);
      widget._buttons = List.from(widget._typingTest.buttons);
      widget._tokenList = List.from(widget._typingTest.tokenList);
    });
  }

  @override
  void didUpdateWidget(covariant TypingTest1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._typingTest == null) {
      updateTestData();
    }
    if (widget._buttons.length == 0)
      setState(() {
        widget._buttons = List.from(widget._typingTest.buttons);
      });
    if (widget._buttonHighlightList.length == 0)
      setState(() {
        List<bool> buttonHighlightList = [];
        for (int x = 0; x < buttonCount; ++x) buttonHighlightList.add(false);

        widget._buttonHighlightList = List.from(buttonHighlightList);
      });
  }

  @override
  Widget build(BuildContext context) {
    print('AAAAAAAAAAAA');
    print(widget.testCase);
    print(widget._buttons.length);
    print(widget._typingTest == null);

    var buttonList = <Widget>[];
    widget._buttons.asMap().forEach((idx, buttonText) => buttonList.add(
          buildBlankButton(buttonText, () {
            if (buttonText.length == 0) return;
            if (widget._typingTest
                .guess(idx, buttonText, widget._userData.length)) {
              List<bool> buttonHighlightList = [];
              for (int x = 0; x < buttonCount; ++x)
                buttonHighlightList.add(false);
              setState(() {
                widget._userData.add(buttonText);
                widget._buttons[idx] = '';
                widget._buttonHighlightList = List.from(buttonHighlightList);
              });
            } else {
              setState(() {
                widget._buttonHighlightList[idx] = true;
              });
            }
          }, idx, highlight: widget._buttonHighlightList[idx]),
        ));

    var spanList = <Widget>[];

    var blankIdx = 0;
    for (TestTypingToken token in widget._tokenList) {
      switch (token.type) {
        case TestTypingTokenType.Blank:
          spanList.add(buildBlank(token.content,
              noBlank: blankIdx < widget._userData.length));
          blankIdx += 1;
          break;
        case TestTypingTokenType.Desc:
          spanList.add(
            Container(
              child: Text(token.content, style: paper_text_style),
            ),
          );
          break;
      }
    }

    return Expanded(
        child: FittedBox(
      child: Column(children: [
        Container(
            child: Wrap(
              children: spanList,
            ),
            alignment: Alignment.center,
            height: 360.0 - 40 * 4),
        Container(
            child: Column(
              children: [
                Row(
                  children: buttonList.sublist(0, 20),
                  mainAxisSize: MainAxisSize.min,
                ),
                Row(
                  children: buttonList.sublist(20, 40),
                  mainAxisSize: MainAxisSize.min,
                ),
                Row(
                  children: buttonList.sublist(40, 60),
                  mainAxisSize: MainAxisSize.min,
                ),
                Row(
                  children: buttonList.sublist(60, 80),
                  mainAxisSize: MainAxisSize.min,
                ),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
            height: 40.0 * 4),
      ]),
      fit: BoxFit.fill,
    ));
  }
}
/*showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
title: Text(_typingTest.buttons.length.toString() +
';' +
buttonText +
';' +
idx.toString() +
';' +
widget._buttonHighlightList[idx].toString()),
);
},
);*/
