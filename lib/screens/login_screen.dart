import 'dart:math';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

import '../constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 75,
              padding: const EdgeInsets.symmetric(horizontal: 7),
              margin: const EdgeInsets.symmetric(vertical: 50),
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
                      fontSize: kSplash + 5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GowunBatang')),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  color: Colors.amber[100],
                ),
                Container(
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  color: Colors.amber[100],
                ),
                Container(
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  color: Colors.amber[100],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
