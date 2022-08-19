import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants.dart';

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
    // 1:1 => 380, 3:4 => 500
    double calendarHeight = calendarViewSetting.indexOf(true) == 0 ? 380 : 500;

    final kToday = DateTime.now();
    final kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month, kToday.day);

    void onTodayButtonTap() {
      setState(() => _focusedDay = DateTime.now());
    }

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 90,
              height: 30,
              margin: const EdgeInsets.only(top: 15.0),
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
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                height: calendarHeight,
                child: TableCalendar(
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
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  daysOfWeekHeight: 28,
                  daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                          color: kBlack,
                          fontSize: kContentM,
                          fontWeight: FontWeight.bold),
                      weekendStyle: TextStyle(
                          color: kPoint,
                          fontSize: kContentM,
                          fontWeight: FontWeight.bold)),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronIcon: Icon(Icons.chevron_left_rounded,
                        size: 26, color: kBlack),
                    rightChevronIcon: Icon(Icons.chevron_right_rounded,
                        size: 26, color: kBlack),
                    titleTextStyle: TextStyle(
                        color: kBlack,
                        fontSize: kTitle,
                        fontWeight: FontWeight.bold),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    cellMargin: const EdgeInsets.all(0.0),
                    tableBorder: TableBorder.symmetric(
                        inside: BorderSide(color: kUnderline, width: 0.4)),
                    defaultTextStyle:
                        TextStyle(color: kBlack, fontSize: kContentM),
                    defaultDecoration: const BoxDecoration(),
                    weekendTextStyle:
                        TextStyle(color: kPoint, fontSize: kContentM),
                    weekendDecoration: const BoxDecoration(),
                    todayTextStyle: const TextStyle(color: Colors.transparent),
                    todayDecoration: BoxDecoration(
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('./assets/images/img0.jpg')),
                        border: Border.all(color: kPoint, width: 2.5)),
                    selectedDecoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: kBlack, width: 2.5),
                    ),
                    disabledDecoration: const BoxDecoration(),
                  ),
                ),
              ),
              SizedBox(
                  width: appWidth,
                  child: const Image(
                      image: AssetImage('./assets/images/background.png'))),
              Expanded(child: Container(color: kBackground))
            ],
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 10.0, left: 120.0),
                child: IconButton(
                    onPressed: () {
                      onTodayButtonTap();
                    },
                    icon: Icon(Icons.calendar_today_rounded,
                        size: 22, color: kPoint)),
              ))
        ],
      ),
    );
  }
}
