import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pidi/screens/detail_screen.dart';

import '../constants.dart';
import 'package:pidi/models/test.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appWidth = MediaQuery.of(context).size.width;
    // 1:1 => appWidth / 7 * 5 + 100
    // 3:4 => appWidth / 7 * 1.4 * 5 + 100
    double calendarHeight = calendarViewSetting.indexOf(true) == 0
        ? appWidth / 7 * 5 + 160
        : appWidth / 7 * 1.4 * 5 + 160;

    void onTodayButtonTap() {
      setState(() {
        _selectedDay = DateTime.now();
        _focusedDay = DateTime.now();
      });
    }

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Stack(
        children: [
          Column(
            children: [
              // 캘린더
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                height: calendarHeight,
                child: TableCalendar(
                  sixWeekMonthsEnforced: true,
                  calendarBuilders: CalendarBuilders(
                    // 헤더 타이틀 + 오늘 버튼
                    headerTitleBuilder: (context, day) {
                      return Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: const [
                                      0.65,
                                      0.35,
                                    ],
                                    colors: [
                                      Colors.transparent,
                                      kUnderline,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  '${day.year}년 ${day.month}월',
                                  style: TextStyle(
                                      color: kBlack,
                                      fontSize: kAppBar - 1,
                                      fontWeight: FontWeight.bold),
                                )),
                            // 오늘로 돌아가는 버튼
                            SizedBox(
                                width: 40,
                                child: TextButton(
                                    onPressed: () {
                                      onTodayButtonTap();
                                    },
                                    style: TextButton.styleFrom(
                                      primary: kBlack.withOpacity(0.5),
                                      side:
                                          BorderSide(color: kBlack, width: 1.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: kBorderRadiusL),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 8),
                                      minimumSize: Size.zero,
                                    ),
                                    child: Text(
                                      '오늘',
                                      style: TextStyle(
                                          color: kBlack,
                                          fontSize: kSubText + 1,
                                          fontWeight: FontWeight.bold),
                                    )))
                          ],
                        ),
                      );
                    },
                    // 특정한 날 설정
                    prioritizedBuilder: (context, day, focusedDay) {
                      // post가 있는 날
                      for (int i = 0; i < postList.length; i++) {
                        if (day.year ==
                                int.parse(postList[i].date.substring(0, 4)) &&
                            day.month ==
                                int.parse(postList[i].date.substring(5, 7)) &&
                            day.day ==
                                int.parse(postList[i].date.substring(8))) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDay = day;
                                _focusedDay = day;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(post: postList[i])));
                            },
                            child: Stack(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        border: day == _selectedDay
                                            ? Border.all(
                                                color: kBlack, width: 2)
                                            : day.year == kToday.year &&
                                                    day.month == kToday.month &&
                                                    day.day == kToday.day
                                                ? Border.all(
                                                    color: kPoint, width: 2)
                                                : const Border(),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(postList[i]
                                                .images[0]
                                                .toString())))),
                                // 사진 여러개인 것 개수 표시
                                postList[i].images.length > 1
                                    ? Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                            ),
                                            child: Center(
                                              child: Text(
                                                postList[i]
                                                    .images
                                                    .length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: kSubText,
                                                    fontWeight: FontWeight.bold,
                                                    color: kWhite),
                                              ),
                                            )),
                                      )
                                    : Container()
                              ],
                            ),
                          );
                        }
                      }
                      // 토요일
                      if (day.weekday == DateTime.saturday &&
                          kToday.difference(day).inDays >= 0) {
                        return Container(
                          decoration: BoxDecoration(
                              border: day == _selectedDay
                                  ? Border.all(color: kBlack, width: 2)
                                  : day.year == kToday.year &&
                                          day.month == kToday.month &&
                                          day.day == kToday.day
                                      ? Border.all(color: kPoint, width: 2)
                                      : const Border()),
                          alignment: Alignment.center,
                          child: Text(day.day.toString(),
                              style: TextStyle(
                                  fontSize: kContentM,
                                  color: const Color(0xFF567DC2))),
                        );
                      }
                      // 일요일
                      else if (day.weekday == DateTime.sunday &&
                          kToday.difference(day).inDays >= 0) {
                        return Container(
                          decoration: BoxDecoration(
                            border: day == _selectedDay
                                ? Border.all(color: kBlack, width: 2)
                                : day.year == kToday.year &&
                                        day.month == kToday.month &&
                                        day.day == kToday.day
                                    ? Border.all(color: kPoint, width: 2)
                                    : const Border(),
                          ),
                          alignment: Alignment.center,
                          child: Text(day.day.toString(),
                              style: TextStyle(
                                  fontSize: kContentM,
                                  color: const Color(0xFFE75959))),
                        );
                      }
                      return null;
                    },
                    // 오늘 설정
                    todayBuilder: (context, day, focusedDay) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: kPoint, width: 2)),
                        child: Text(day.day.toString(),
                            style:
                                TextStyle(fontSize: kContentM, color: kBlack)),
                      );
                    },
                    // 선택한 날 설정
                    selectedBuilder: (context, day, focusedDay) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: kBlack, width: 2)),
                        alignment: Alignment.center,
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(color: kBlack, fontSize: kContentM),
                        ),
                      );
                    },
                    // 요일 이름 설정
                    dowBuilder: (context, day) {
                      if (day.weekday == DateTime.saturday) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text('토',
                              style: TextStyle(
                                  fontSize: kContentM,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF567DC2))),
                        );
                      } else if (day.weekday == DateTime.sunday) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text('일',
                              style: TextStyle(
                                  fontSize: kContentM,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE75959))),
                        );
                      }
                      return null;
                    },
                  ),
                  shouldFillViewport: true,
                  locale: 'ko-KR',
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  startingDayOfWeek: startingDayofWeekSetting[0] == true
                      ? StartingDayOfWeek.sunday
                      : StartingDayOfWeek.monday,
                  daysOfWeekHeight: 28,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                        color: kBlack,
                        fontSize: kContentM,
                        fontWeight: FontWeight.bold),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronIcon: Icon(Icons.chevron_left_rounded,
                        size: 26, color: kBlack),
                    leftChevronPadding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    rightChevronIcon: Icon(Icons.chevron_right_rounded,
                        size: 26, color: kBlack),
                    rightChevronPadding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    cellMargin: const EdgeInsets.all(0.0),
                    tableBorder: TableBorder.symmetric(
                        inside: BorderSide(color: kUnderline, width: 0.4)),
                    defaultTextStyle:
                        TextStyle(color: kBlack, fontSize: kContentM),
                    defaultDecoration: const BoxDecoration(),
                  ),
                ),
              ),
              // 하단 배경
              SizedBox(
                  width: appWidth,
                  child: const Image(
                      image: AssetImage('./assets/images/background.png'))),
              Expanded(child: Container(color: kBackground))
            ],
          ),
        ],
      ),
    );
  }
}
