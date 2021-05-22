import 'package:flutter/material.dart';

const paper_text_style =
    TextStyle(fontFamily: 'NanumGothicCoding', fontSize: 32);
const paper_text_style_hidden = TextStyle(
    fontFamily: 'NanumGothicCoding', fontSize: 32, color: Color(0xFFEEEEEE));
const paper_text_style_blank_button = TextStyle(
    fontFamily: 'NanumGothicCoding', fontSize: 28, color: Color(0xFF333333));

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
