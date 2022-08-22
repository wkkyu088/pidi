import 'package:flutter/material.dart';

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
double kSplash = 60;
double kAppBar = 20;
double kTitle = 18;
double kContentM = 16;
double kContentS = 14;
double kSubText = 12;

// BorderRdius
// images in list_screen, gallery_screen, detail_screen
BorderRadius kBorderRadius = BorderRadius.circular(10.0);

// images in create_modal
BorderRadius kBorderRadiusL = BorderRadius.circular(20.0);

// textField in create_modal
BorderRadius kBorderRadiusS = BorderRadius.circular(8.0);

// settings
final List<bool> calendarViewSetting = [false, true];
final List<bool> listViewSetting = [true, false];
final List<bool> galleryViewSetting = [false, false, true];
final List<bool> datePickerSetting = [true, false];
final List<bool> startingDayofWeekSetting = [true, false];
String fontFamily = 'GowunDodum';

// calendar day setting
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month, kToday.day);
