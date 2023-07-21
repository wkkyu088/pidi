import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pidi/constants.dart';
import 'package:pidi/models/cal_posts.dart';
import 'package:pidi/models/item.dart';
import 'package:pidi/widgets/create_modal.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pidi/screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late CalPosts calPosts;
  List<Item> calPostList = [];

  void getPosts() async {
    calPosts = CalPosts();
    calPosts.getCalPosts(DateTime.now()).then((posts) {
      calPostList = posts;
      setState(() {});
    }).catchError((error) {
      // 오류 처리
      debugPrint(error);
    });
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appWidth = MediaQuery.of(context).size.width;
    final double appHeight = MediaQuery.of(context).size.height;
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

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(top: statusBarHeight),
          width: appWidth,
          height: appHeight,
          child: Column(
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 50),
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
                                width: 50,
                                child: TextButton(
                                  onPressed: () {
                                    onTodayButtonTap();
                                    calPosts
                                        .getCalPosts(DateTime.now())
                                        .then((posts) {
                                      calPostList = posts;
                                      setState(() {});
                                    }).catchError((error) {
                                      // 오류 처리
                                      debugPrint(error);
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: kBlack.withOpacity(0.5),
                                    side: BorderSide(color: kBlack, width: 1.2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: kBorderRadiusL),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    minimumSize: Size.zero,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.reply_rounded,
                                        size: kContentM,
                                        color: kBlack,
                                      ),
                                      Text(
                                        '오늘',
                                        style: TextStyle(
                                            color: kBlack,
                                            fontSize: kContentS,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      );
                    },
                    // 특정한 날 설정
                    prioritizedBuilder: (context, day, focusedDay) {
                      // post가 있는 날
                      for (int i = 0; i < calPostList.length; i++) {
                        if (day.year == calPostList[i].date.year &&
                            day.month == calPostList[i].date.month &&
                            day.day == calPostList[i].date.day) {
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
                                          DetailScreen(post: calPostList[i])));
                            },
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: calPostList[i].images[0].toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      border: day == _selectedDay
                                          ? Border.all(color: kBlack, width: 2)
                                          : day.year == kToday.year &&
                                                  day.month == kToday.month &&
                                                  day.day == kToday.day
                                              ? Border.all(
                                                  color: kPoint, width: 2)
                                              : const Border(),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                // 사진 여러개인 것 개수 표시
                                calPostList[i].images.length > 1
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
                                                calPostList[i]
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
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        constraints: BoxConstraints.loose(
                          Size(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                        ),
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                              child: CreateModal(selectedDate: selectedDay));
                        },
                      );
                    }
                  },
                  onPageChanged: (focusedDay) {
                    calPosts.getCalPosts(focusedDay).then((posts) {
                      calPostList = posts;
                      setState(() {});
                    }).catchError((error) {
                      // 오류 처리
                    });
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
        ),
      ),
    );
  }
}
