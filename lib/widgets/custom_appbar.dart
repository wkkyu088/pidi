import 'package:flutter/material.dart';

import '../constants.dart';

AppBar customAppBar(String title) {
  return AppBar(
    centerTitle: true,
    leading: const Icon(Icons.arrow_back_rounded, color: Color(0xFF262626)),
    title: Container(
      child: Text(title,
          style:
              TextStyle(color: Color(0xFF262626), fontWeight: FontWeight.bold)),
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
            Color(0xFFE7E6E6),
          ],
        ),
      ),
    ),
    elevation: 0,
    backgroundColor: kWhite,
  );
}
