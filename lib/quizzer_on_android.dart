import 'package:flutter/material.dart';

const displayWidth = 836.2;
const displayHeight = 411.4;

const paper_text_style =
    TextStyle(fontFamily: 'NanumGothicCoding', fontSize: 32);
const paper_text_style_hidden = TextStyle(
    fontFamily: 'NanumGothicCoding', fontSize: 32, color: Color(0xFFEEEEEE));
const paper_text_style_blank_button = TextStyle(
    fontFamily: 'NanumGothicCoding', fontSize: 28, color: Color(0xFF333333));
const paper_text_style_choose_button = TextStyle(
    fontFamily: 'NanumGothicCoding', fontSize: 16, color: Color(0xFF333333));
const paper_text_style_number_button = TextStyle(
    fontFamily: 'NanumGothicCoding', fontSize: 9, color: Color(0xFF333333));

bool isHangulSyllables(String A) {
  return A.codeUnitAt(0) >= 0xAC00 && A.codeUnitAt(0) <= 0xD7AF;
}

bool isHangulLeadingConsonant(String A) {
  return A.codeUnitAt(0) >= 0x3131 && A.codeUnitAt(0) <= 0x314E;
}

String getLeadingConsonant(String A) {
  const leadingConsonants = [
    'ㄱ',
    'ㄲ',
    'ㄴ',
    'ㄷ',
    'ㄸ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅃ',
    'ㅅ',
    'ㅆ',
    'ㅇ',
    'ㅈ',
    'ㅉ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ'
  ];
  if (isHangulSyllables(A)) {
    return leadingConsonants[((A.codeUnitAt(0) - 0xAC00) / 588).floor()];
  } else
    return '~';
}

enum TestDataType {
  None,
  Typing, //[A;B;C]
  Number, //{A}
  UnorderedSet, //{A,B,C;D,E}
  OrderedSet, //{@A,B,C;D,E}
  ParallelTyping, //{A,B,C,D,E}
}

class TestTyping {
  String answer;
  List<String> wrongs = [];
}

class TestNumber {
  double answer;
}

class TestUnorderedSet {
  List<String> answers = [];
  List<String> wrongs = [];
}

class TestOrderedSet {
  List<String> answers = [];
  List<String> wrongs = [];
}

class TestParallelTyping {
  List<String> answers = [];
}

double parseKoreanNumber(String text) {
  double result = 0;
  var index;
  //123억4천5백6십7만333.333
  index = text.indexOf('억');
  if (index != -1) {
    String subpartition = text.substring(0, index);
    text = text.substring(index + 1);
    double x = 0;

    index = subpartition.indexOf('천');
    if (index != -1) {
      if (index > 0)
        x += double.parse(subpartition.substring(0, index)) * 1000;
      else
        x += 1000;
      subpartition = subpartition.substring(index + 1);
    }
    index = subpartition.indexOf('백');
    if (index != -1) {
      if (index > 0)
        x += double.parse(subpartition.substring(0, index)) * 100;
      else
        x += 100;
      subpartition = subpartition.substring(index + 1);
    }
    index = subpartition.indexOf('십');
    if (index != -1) {
      if (index > 0)
        x += double.parse(subpartition.substring(0, index)) * 10;
      else
        x += 10;
      subpartition = subpartition.substring(index + 1);
    }
    if (subpartition.length > 0) x += double.parse(subpartition);
    result += x * 10000 * 10000;
  }

  index = text.indexOf('만');
  if (index != -1) {
    String subpartition = text.substring(0, index);
    text = text.substring(index + 1);
    double x = 0;

    index = subpartition.indexOf('천');
    if (index != -1) {
      if (index > 0)
        x += double.parse(subpartition.substring(0, index)) * 1000;
      else
        x += 1000;
      subpartition = subpartition.substring(index + 1);
    }
    index = subpartition.indexOf('백');
    if (index != -1) {
      if (index > 0)
        x += double.parse(subpartition.substring(0, index)) * 100;
      else
        x += 100;
      subpartition = subpartition.substring(index + 1);
    }
    index = subpartition.indexOf('십');
    if (index != -1) {
      if (index > 0)
        x += double.parse(subpartition.substring(0, index)) * 10;
      else
        x += 10;
      subpartition = subpartition.substring(index + 1);
    }
    if (subpartition.length > 0) x += double.parse(subpartition);
    result += x * 10000;
  }

  index = text.indexOf('.');
  if (index != -1) {
    String subpartition = text.substring(0, index);
    text = text.substring(index);
    double x = 0;

    index = subpartition.indexOf('천');
    if (index != -1) {
      if (index > 0)
        x += double.parse(subpartition.substring(0, index)) * 1000;
      else
        x += 1000;
      subpartition = subpartition.substring(index + 1);
    }
    index = subpartition.indexOf('백');
    if (index != -1) {
      if (index > 0)
        x += double.parse(subpartition.substring(0, index)) * 100;
      else
        x += 100;
      subpartition = subpartition.substring(index + 1);
    }
    index = subpartition.indexOf('십');
    if (index != -1) {
      if (index > 0)
        x += double.parse(subpartition.substring(0, index)) * 10;
      else
        x += 10;
      subpartition = subpartition.substring(index + 1);
    }
    if (subpartition.length > 0) x += double.parse(subpartition);
    result += x;
  }
  if (text.length > 0) result += double.parse(text);
  return result;
}

String formatKoreanNumber(double x) {
  String result = '';
  int part_2 = 0;
  int part_1 = 0;
  while (x >= 10000 * 10000) {
    part_2 += 1;
    x -= 10000 * 10000;
  }
  while (x >= 10000) {
    part_1 += 1;
    x -= 10000;
  }

  int y = part_2;
  if (y > 0) {
    int thousand = 0;
    int hundred = 0;
    int ten = 0;
    int one = 0;
    while (y >= 1000) {
      thousand += 1;
      y -= 1000;
    }
    while (y >= 100) {
      hundred += 1;
      y -= 100;
    }
    while (y >= 10) {
      ten += 1;
      y -= 10;
    }
    one = y;
    if (thousand > 0) {
      if (thousand > 1)
        result += thousand.toString() + '천';
      else
        result += '천';
    }
    if (hundred > 0) {
      if (hundred > 1)
        result += hundred.toString() + '백';
      else
        result += '백';
    }
    if (ten > 0) {
      if (ten > 1)
        result += ten.toString() + '십';
      else
        result += '십';
    }
    if (one > 0) result += one.toString();
    result += '억';
  }
  y = part_1;
  if (y > 0) {
    int thousand = 0;
    int hundred = 0;
    int ten = 0;
    int one = 0;
    while (y >= 1000) {
      thousand += 1;
      y -= 1000;
    }
    while (y >= 100) {
      hundred += 1;
      y -= 100;
    }
    while (y >= 10) {
      ten += 1;
      y -= 10;
    }
    one = y;
    if (thousand > 0) {
      if (thousand > 1)
        result += thousand.toString() + '천';
      else
        result += '천';
    }
    if (hundred > 0) {
      print('HUNDERED' + hundred.toString());
      if (hundred > 1)
        result += hundred.toString() + '백';
      else
        result += '백';
    }
    if (ten > 0) {
      if (ten > 1)
        result += ten.toString() + '십';
      else
        result += '십';
    }
    if (one > 0) result += one.toString();
    result += '만';
  }

  if (x > 0) {
    if (x % 1 == 0)
      result += x.floor().toString();
    else
      result += x.toString();
  }
  return result;
}

List exportTestData(String string) {
  List result = [];
  String buffer = '';
  TestNumber testNumber;
  TestTyping testTyping;
  TestUnorderedSet testUnorderedSet;
  TestOrderedSet testOrderedSet;
  TestParallelTyping testParallelTyping;

  String mode = 'plain';
  bool putWrong = false;

  for (var ch in string.characters) {
    //print('CH: ' + ch + ', mode: ' + mode);

    if (mode == 'plain') {
      if (ch == '[') {
        if (buffer.length > 0) result.add(buffer);
        testTyping = TestTyping();
        putWrong = false;
        buffer = '';
        mode = 'typing';
      } else if (ch == '{') {
        if (buffer.length > 0) result.add(buffer);
        buffer = '';
        testNumber = TestNumber();
        putWrong = false;
        mode = 'number';
      } else if (ch.codeUnitAt(0) == 13) {
        if (buffer.length > 0) result.add(buffer);
        result.add('\n');
        buffer = '';
      } else {
        buffer += ch;
      }
    } else if (mode == 'number') {
      if (ch == '@') {
        mode = 'ordered_set';
        testOrderedSet = TestOrderedSet();
        buffer = '';
      } else if (ch == ',') {
        mode = 'parallel_typing';
        testParallelTyping = TestParallelTyping();
        testParallelTyping.answers.add(buffer);
        buffer = '';
      } else if (ch == ';') {
        mode = 'unordered_set';
        testUnorderedSet = TestUnorderedSet();
        testUnorderedSet.answers.add(buffer);
        putWrong = true;
        buffer = '';
      } else if (ch == '}') {
        testNumber.answer = parseKoreanNumber(buffer);
        result.add(testNumber);
        buffer = '';
        mode = 'plain';
      } else
        buffer += ch;
    } else if (mode == 'ordered_set') {
      if (ch == ',' || ch == ';') {
        if (putWrong)
          testOrderedSet.wrongs.add(buffer);
        else
          testOrderedSet.answers.add(buffer);
        if (ch == ';') putWrong = true;
        buffer = '';
      } else if (ch == '}') {
        if (putWrong)
          testOrderedSet.wrongs.add(buffer);
        else
          testOrderedSet.answers.add(buffer);
        if (ch == ';') putWrong = true;
        buffer = '';
        mode = 'plain';
        result.add(testOrderedSet);
      } else
        buffer += ch;
    } else if (mode == 'unordered_set') {
      if (ch == ',' || ch == ';') {
        if (putWrong)
          testUnorderedSet.wrongs.add(buffer);
        else
          testUnorderedSet.answers.add(buffer);
        if (ch == ';') putWrong = true;
        buffer = '';
      } else if (ch == '}') {
        if (putWrong)
          testUnorderedSet.wrongs.add(buffer);
        else
          testUnorderedSet.answers.add(buffer);
        if (ch == ';') putWrong = true;
        buffer = '';
        mode = 'plain';
        result.add(testUnorderedSet);
      } else
        buffer += ch;
    } else if (mode == 'parallel_typing') {
      if (ch == ',') {
        testParallelTyping.answers.add(buffer);
        buffer = '';
      } else if (ch == ';') {
        mode = 'unordered_set';
        testUnorderedSet = TestUnorderedSet();
        testUnorderedSet.answers = testParallelTyping.answers;
        testUnorderedSet.answers.add(buffer);
        putWrong = true;
        buffer = '';
      } else if (ch == '}') {
        testParallelTyping.answers.add(buffer);
        result.add(testParallelTyping);
        buffer = '';
        mode = 'plain';
      } else
        buffer += ch;
    } else if (mode == 'typing') {
      if (ch == ']') {
        if (testTyping.answer != null)
          testTyping.wrongs.add(buffer);
        else
          testTyping.answer = buffer;
        buffer = '';
        result.add(testTyping);
        mode = 'plain';
      } else if (ch == ';' || ch == ',') {
        if (testTyping.answer != null)
          testTyping.wrongs.add(buffer);
        else
          testTyping.answer = buffer;
        buffer = '';
      } else
        buffer += ch;
    }
  }

  if (mode == 'plain' && buffer.length > 0) result.add(buffer);

  for (var item in result) {
    //if (item is TestTyping)
    //  print('@@[' + item.answer + ']@@');
    //else
    //`  print(item);
  }

  return result;
}

enum TestAnswerButtonState { Normal, Answered, Wrong }
