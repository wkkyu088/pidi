import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pidi/screens/splash_screen.dart';

import './screens/detail_screen.dart';
import './screens/gallery_screen.dart';
import './screens/list_screen.dart';
import './screens/Wlist_screen.dart';
import './screens/setting_screen.dart';
import 'screens/home_screen.dart';
import './constants.dart';
import './widgets/create_modal.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'GowunDodum'),
      home: const SplashScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ListScreen(),
    WListScreen(),
    GalleryScreen(),
    DetailScreen(),
    HomeScreen(),
    DetailScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != 3) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: kWhite,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: kWhite,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: kWhite,
        body: Scaffold(
          body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: kBlack,
            onPressed: () {
              showModalBottomSheet(
                constraints: BoxConstraints.loose(Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height)),
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return const CreateModal();
                },
              );
            },
            child: const Icon(Icons.add_rounded, size: 32),
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              elevation: 2,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _selectedIndex,
              selectedItemColor: kBlack,
              unselectedItemColor: kGrey,
              onTap: _onItemTapped,
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.view_stream_rounded),
                  label: 'ListView',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.view_stream_rounded),
                  label: 'ListView',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_rounded),
                  label: 'GalleryView',
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_rounded,
                      color: kWhite,
                    ),
                    label: ''),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.today_rounded),
                  label: 'CalendarView',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.settings_rounded),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ));
  }
}
