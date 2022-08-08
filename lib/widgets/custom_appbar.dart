import 'package:flutter/material.dart';

import '../constants.dart';

AppBar customAppBar(String title) {
  return AppBar(
    centerTitle: true,
    title: Container(
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
      child: Text(title,
          style: TextStyle(
              color: kBlack, fontWeight: FontWeight.bold, fontSize: kAppBar)),
    ),
    elevation: 0,
    backgroundColor: kWhite,
  );
}
