import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pidi/models/posts.dart';
import 'package:pidi/screens/splash_screen.dart';

import './screens/gallery_screen.dart';
import './screens/list_screen.dart';
import './screens/setting_screen.dart';
import 'firebase_options.dart';
import 'models/item.dart';
import 'screens/home_screen.dart';
import './constants.dart';
import './widgets/create_modal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
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
        fontFamily: 'GowunDodum',
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: kBlack,
            selectionHandleColor: kBlack,
            selectionColor: kGrey.withOpacity(0.5)),
      ),
      home: const SplashScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
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
  var db;
  var stream;
  @override
  void initState() {
    db = firestore.where('uid', isEqualTo: userid);
    var query = db.orderBy('date', descending: true);
    stream = query.snapshots();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ListScreen(),
    GalleryScreen(),
    SettingScreen(), // 개수 맞추기 위해서 필요함
    HomeScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  List<String> getImages(List images) {
    List<String> imgList = [];
    for (int i = 0; i < images.length; i++) {
      imgList.add(images[i].toString());
    }
    return imgList;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: kWhite,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: kWhite,
        statusBarIconBrightness: Brightness.dark));

    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (dataflag) {
          } else {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text('error');
            }
            if (snapshot.hasData) {
              postList = [];
              for (var doc in snapshot.data!.docs) {
                postList.add(Item(
                    id: doc.id,
                    title: doc['title'],
                    date: doc['date'].toDate(),
                    content: doc['content'],
                    images: getImages(doc['images'])));
                last_doc = doc;
              }
              dataflag = true;
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: kWhite,
              );
            }
          }
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
        });
  }
}
