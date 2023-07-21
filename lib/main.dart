import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pidi/models/posts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pidi/screens/gallery_screen.dart';
import 'package:pidi/screens/home_screen.dart';
import 'package:pidi/screens/loading_screen.dart';
import 'package:pidi/screens/setting_screen.dart';
import 'package:pidi/widgets/create_modal.dart';
import 'package:provider/provider.dart';
import 'package:pidi/screens/splash_screen.dart';
import './screens/list_screen.dart';
import 'firebase_options.dart';
import './constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: 'pidi',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Posts()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: kBlack,
          onPrimary: kBlack,
          secondary: kGrey,
          onSecondary: kGrey,
          error: kPoint,
          onError: kPoint,
          background: kWhite,
          onBackground: kWhite,
          surface: kBlack,
          onSurface: kBlack,
        ),
        fontFamily: fontFamily,
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: kBlack,
            selectionHandleColor: kBlack,
            selectionColor: kGrey.withOpacity(0.5)),
      ),
      home: const SplashScreen(),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
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

  int _selectedIndex = 2;
  static const List<Widget> _widgetOptions = <Widget>[
    ListScreen(),
    GalleryScreen(),
    LoadingPage(), // 개수 맞추기 위해서 필요함
    HomeScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != 2) {
      _selectedIndex = index;
      setState(() {});
    }
  }

  startTimer() async {
    return Timer(const Duration(seconds: 2), () {
      _selectedIndex = 0;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
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
                      child: CreateModal(selectedDate: kToday));
                },
              );
            },
            child: Icon(Icons.add_rounded, size: 30, color: kWhite),
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
              iconSize: 22,
              items: <BottomNavigationBarItem>[
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
