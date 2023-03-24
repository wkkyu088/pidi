import 'package:flutter/material.dart';

import 'models/item.dart';

// Colors
// 배경색
Color kWhite = const Color(0xFFFAFAFA);

// 메인 컬러, 아이콘 등
Color kBlack = const Color(0xFF262626);

// 비활성화
Color kGrey = const Color(0xFFBFBFBF);

// appbar 타이틀 밑줄, border 등
Color kUnderline = const Color(0xFFE7E6E6);

// 포인트 컬러 (임시)
Color kPoint = const Color(0xFFDB7093);

// 캘린더 하단 배경
Color kBackground = const Color(0xFFF2F2F2);

// FontSize
double kSplash = 52;
double kAppBar = fontFamily == fontList[2] ? 20 : 17;
double kTitle = fontFamily == fontList[2] ? 18 : 15;
double kContentM = fontFamily == fontList[2] ? 16 : 13;
double kContentS = fontFamily == fontList[2] ? 14 : 11;
double kSubText = fontFamily == fontList[2] ? 12 : 9;

// BorderRdius
// images in create_modal
BorderRadius kBorderRadiusL = BorderRadius.circular(18.0);

// images in list_screen, gallery_screen, detail_screen
BorderRadius kBorderRadius = BorderRadius.circular(10.0);

// textField in create_modal
BorderRadius kBorderRadiusS = BorderRadius.circular(8.0);

// settings
final List<bool> calendarViewSetting = [false, true];
final List<bool> listViewSetting = [true, false];
final List<bool> galleryViewSetting = [false, false, true];
final List<bool> datePickerSetting = [true, false];
final List<bool> startingDayofWeekSetting = [true, false];
List fontList = [
  'GowunDodum',
  'GowunBatang',
  'GangwonSaeum',
  'MapoPeacefull',
  'NanumSquare'
];
String fontFamily = fontList[4];

// calendar day setting
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month, kToday.day);

// data
var dataflag = false;
String userid = 'user1';
var lastDoc;
