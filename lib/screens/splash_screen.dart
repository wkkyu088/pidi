import 'dart:async';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const MainPage())));
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
