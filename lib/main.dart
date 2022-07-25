import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

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
  Color mainColor = Color(0xFFDB7093);
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
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
        // navBarStyle: NavBarStyle.style1,
        // navBarStyle: NavBarStyle.style9,
        // navBarStyle: NavBarStyle.style7,
        // navBarStyle: NavBarStyle.style10,
        // navBarStyle: NavBarStyle.style12,
        // navBarStyle: NavBarStyle.style13,
        // navBarStyle: NavBarStyle.style3,
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.view_stream_rounded),
        title: ("List"),
        activeColorPrimary: mainColor,
        inactiveColorPrimary: kGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.dashboard_rounded),
        title: ("Gallery"),
        activeColorPrimary: mainColor,
        inactiveColorPrimary: kGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add_rounded),
        title: ("Add"),
        activeColorPrimary: mainColor,
        inactiveColorPrimary: kGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.calendar_month_rounded),
        title: ("Calendar"),
        activeColorPrimary: mainColor,
        inactiveColorPrimary: kGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings_rounded),
        title: ("Setting"),
        activeColorPrimary: mainColor,
        inactiveColorPrimary: kGrey,
      ),
    ];
  }
}
