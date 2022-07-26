import 'package:flutter/material.dart';

import '../constants.dart';

AppBar customAppBar(String title) {
  return AppBar(
    centerTitle: true,
    actions: [
      IconButton(
          icon: const Icon(Icons.more_horiz_rounded),
          color: kBlack,
          onPressed: () {}),
    ],
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
          style: TextStyle(color: kBlack, fontWeight: FontWeight.bold)),
    ),
    elevation: 0,
    backgroundColor: kWhite,
  );
}
