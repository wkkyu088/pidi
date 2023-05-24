import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pidi/models/posts.dart';
import 'package:pidi/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() async {
    return Timer(const Duration(seconds: 2), initApp);
    // return Timer(const Duration(seconds: 2), () {
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (BuildContext context) => const LoginScreen()));
    // });
  }

  void initApp() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser);

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen()));
    } else {
      var user = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .get();
      final v = user.data() as Map;
      uid = currentUser.uid;
      userName = v['userName'];
      email = v['email'];
      profileImg = v['profileImg'];
      calendarViewSetting = [
        v['calendarViewSetting'][0],
        v['calendarViewSetting'][1]
      ];
      listViewSetting = [v['listViewSetting'][0], v['listViewSetting'][1]];
      galleryViewSetting = [
        v['galleryViewSetting'][0],
        v['galleryViewSetting'][1],
        v['galleryViewSetting'][2]
      ];
      startingDayofWeekSetting = [
        v['startingDayofWeekSetting'][0],
        v['startingDayofWeekSetting'][1]
      ];
      fontFamily = v['fontFamily'];

      print({
        'uid': uid,
        'userName': userName,
        'email': email,
        'profileImg': profileImg,
        'listViewSetting': listViewSetting,
        'galleryViewSetting': galleryViewSetting,
        'calendarViewSetting': calendarViewSetting,
        'startingDayofWeekSetting': startingDayofWeekSetting,
        'fontFamily': fontFamily,
      });

      context.read<DBConnection>().firstLoad();

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const MainPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Center(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0.65,
                0.35,
              ],
              colors: [
                kWhite,
                kUnderline,
              ],
            ),
          ),
          child: Text('PiDi',
              style: TextStyle(
                  color: kBlack,
                  fontSize: kSplash,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GowunBatang')),
        ),
      ),
    );
  }
}
