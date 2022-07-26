import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:flutter/services.dart';

import './screens/detail_screen.dart';
import './screens/gallery_screen.dart';
import './screens/list_screen.dart';
import './screens/setting_screen.dart';
import './screens/home_screen.dart';
import './constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'GowunDodum'),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 투명색
    ));
    return PersistentTabView(
      context,
      controller: _controller,
      screens: const [
        ListScreen(),
        GalleryScreen(),
        DetailScreen(),
        HomeScreen(),
        SettingScreen(),
      ],
      items: _navBarsItems(),
      backgroundColor: kWhite,
      navBarStyle: NavBarStyle.style15,
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
          border: Border(top: BorderSide(color: kUnderline, width: 0.5))),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.view_stream_rounded),
        activeColorPrimary: kBlack,
        inactiveColorPrimary: kGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.dashboard_rounded),
        activeColorPrimary: kBlack,
        inactiveColorPrimary: kGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.add_rounded,
          size: 35,
          color: Color(0xFFFAFAFA),
        ),
        activeColorPrimary: kBlack,
        inactiveColorPrimary: kGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.today_rounded),
        activeColorPrimary: kBlack,
        inactiveColorPrimary: kGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings_rounded),
        activeColorPrimary: kBlack,
        inactiveColorPrimary: kGrey,
      ),
    ];
  }
}
